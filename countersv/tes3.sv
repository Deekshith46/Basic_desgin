////////// Transaction Class //////////
class transaction;
    rand bit mod;
     bit [2:0] count;

     function transaction copy();
     copy =new();
     copy.mod = this.mod;
     copy.count =this.count;
     endfunction

    function void display(input string tag);
        $display("%[0s]: mod=%0d, count=%0d", tag , mod, count);
    endfunction

    endclass

////////// Generator Class //////////
class generator;
transaction tr;

    mailbox #(transaction) gen2drv;
    event sconext;
    event done;
    int count;

    function new(mailbox #(transaction) gen2drv);
        this.gen2drv = gen2drv;
        tr=new();
    endfunction

    task run();
        repeat(count)begin
        assert (tr.randomize())
       else $error("[GEN] :Transaction randomization failed");
        gen2drv.put(tr.copy);
        tr.display("GEN");
        @(sconext);
        end
        ->done;
    endtask
endclass
//////////////int/////
/////////interface///////////
interface intf();
logic clk,rst;
logic mod;
logic [2:0] count;
endinterface


////////// Driver Class //////////
 class driver;
    transaction trs;
     mailbox #(transaction) gen2drv;
     virtual intf vif;

     
    function new(mailbox #(transaction) gen2drv);/// function new(virtual intf vif, mailbox gen2drv);
        //this.vif = vif;
        this.gen2drv = gen2drv;
    endfunction

    task reset();
        vif.rst <= 1'b1;
        repeat(5) @(posedge vif.clk);
        vif.rst <= 1'b0;
        @(posedge vif.clk);
        $display("[DRV] : RESET DONE");
        endtask

   

    task run();
        forever begin
           gen2drv.get(tr);
           vif.mod <= tr.mod;
           @(posedge vif.clk);
           tr.display("DRV");
           vif.mod <= 1'b0;
           @(posedge vif.clk);
         end
    endtask
endclass

////////// Monitor Class //////////
class monitor;
transaction tr;
 mailbox #(transaction) mon2sco;
  virtual intf vif;


   function new(mailbox #(transaction) mon2sco);/// function new(virtual intf vif, mailbox gen2drv);
        //this.vif = vif;
        this.mon2sco = mon2sco;
    endfunction

    task run();
    tr =new();
            forever begin
            repeat(2)@(posedge vif.clk);
            //trans.mod = vif.mod;
            tr.count = vif.count;
            mon2sco.put(tr);
            tr.display("MONITOR");
        end
    endtask
endclass

////////// Scoreboard Class //////////
class scoreboard;
transcation tr;

    mailbox #(transaction) mon2sco;
    event sconext;

    
   function new(mailbox #(transaction) mon2sco);/// function new(virtual intf vif, mailbox gen2drv);
        //this.vif = vif;
        this.mon2sco = mon2sco;
    endfunction


    task run();
    int expected_count;
               
        forever begin
            mon2scb.get(tr);
            tr.display("SCO");
           
            if (trans.mod)
                expected_count++;
                
            else

                expected_count--;

            expected_count = (expected_count + 8) % 8;  // Wrap around 3-bit range

            if (expected_count == tr.count)
                $display("[SCOREBOARD] PASS: Time=%0t, Expected=%0d, dutout=%0d", $time, expected_count,trans.count);
            else
                $display("[SCOREBOARD] FAIL: Time=%0t, Expected=%0d, dutout=%0d", $time, expected_count, trans.count);
        end
        ->sconext;
        
    endtask
endclass


////////// Environment Class //////////
class environment;

    generator gen;
    driver drv;
    monitor mon;
    scoreboard scb;
event next;

    mailbox #(transaction) gen2drv;
    mailbox #(transaction) mon2sco;

    virtual intf vif;

    function new(virtual intf vif);
        //this.vif = vif;
        gen2drv = new();
        mon2sco = new();
        gen = new(gen2drv);
        drv = new( gen2drv);
        mon = new( mon2sco);
        scb = new(mon2sco);
        this.vif = vif;
        drv.vif = this.vif;
        mon.vif = this.vif;
        gen.sconext = next;
        sco.sconext = next;
    endfunction

    task pre_test();
        drv.reset();
    endtask

    task test();
        fork
            gen.run();
            drv.run();
            mon.run();
            scb.run();
        join_any
    endtask

    task post_test();
    wait(gen.done.triggered);
    $finish();
    endtask

    task run();
    pre_test();
    test();
    post_test();
    endtask

  endclass


////////// Testbench Top //////////
module tb_top;

intf vif();

counter dut(
        .clk(vif.clk),
        .mod(vif.mod),
        .rst(vif.rst),
        .count(vif.count)
    );

 
    initial begin
    vif.clk <= 0;
    end
    
    always #10 vif.clk = ~vif.clk;

    environment env;

    initial begin
    env=new(vif);
    env.gen.count =30;
    env.run();
    end

    
    /*initial begin
        $shm_open("wave.shm");
        $shm_probe("ACTMF");
        $finish();
    end*/
endmodule
