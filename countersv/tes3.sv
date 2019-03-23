////////// Transaction Class //////////
class transaction;
    randc bit mod;
      bit [2:0] count;
     // bit rst;

     /*constraint vaild_transcation{
         count inside{0,1,2,3,4,5,6,7};}*/

     function transaction copy();
     copy =new();
     copy.mod = this.mod;
     copy.count =this.count;
     endfunction

    function void display(input string name);
        $display("[%0s]: mod=%0d, count=%0d", name , mod, count);
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
        @(sconext);
        end
        ->done;
        $display("[gen] : all transaction generated");
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
    transaction tr;
     mailbox #(transaction) gen2drv;
     virtual intf vif;

     
    function new( virtual intf vif ,mailbox #(transaction) gen2drv);/// function new(virtual intf vif, mailbox gen2drv);
        this.vif = vif;
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
            tr.display("GEN");
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


   function new( virtual intf vif,mailbox #(transaction) mon2sco);/// function new(virtual intf vif, mailbox gen2drv);
        this.vif = vif;
        this.mon2sco = mon2sco;
    endfunction

    task run();
    tr =new();
            forever begin
            repeat(2)@(posedge vif.clk);
            tr.mod = vif.mod;
            tr.count = vif.count;
            mon2sco.put(tr);/////
            tr.display("MONITOR");
        end
    endtask
endclass

////////// Scoreboard Class //////////
class scoreboard;
transaction tr;
//int rst=0;
int expected_count;

    mailbox #(transaction) mon2sco;
    event sconext;

    
   function new(mailbox #(transaction) mon2sco);/// function new(virtual intf vif, mailbox gen2drv);
        //this.vif = vif;
        this.mon2sco = mon2sco;
    endfunction


    task run();
                   
        forever begin
            mon2sco.get(tr);
            tr.display("SCO");

           /*@(posedge vif.clk);
            if(rst)
            begin
                expected_count = 3'b000;
                end
            else 
            begin
                if(tr.mod)
                begin
                    expected_count++;
                end
                else
                begin
                    expected_count--;
                    expected_count =(expected_count +8)%8;

                end  
                            end  

            if(expected_count == tr.count)begin
                $display("---------passed----------");
                end
                else begin
                    $display("------------failed---");
                    end
end
      */     
            if

                (tr.mod)
                expected_count++;
                
            else

                expected_count--;

            expected_count = (expected_count + 8) % 8;  // Wrap around 3-bit range

            if (expected_count == tr.count)
               //$display("--------passed---------");
                $display("[SCOREBOARD] PASS: Time=%0t, Expected=%0d, dutout=%0d", $time, expected_count,tr.count);
            else
                //$display("----------FAILED--------");
               
               $display("[SCOREBOARD] FAIL: Time=%0t, Expected=%0d, dutout=%0d", $time, expected_count, tr.count);
         $display("------------------------------");

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
        this.vif = vif;
        gen2drv = new();
        mon2sco = new();
        gen = new(gen2drv);
        drv = new(vif, gen2drv);
        mon = new(vif, mon2sco);
        scb = new(mon2sco);
        gen.sconext = next;
        scb.sconext =next;
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
        join
    endtask

    task post_test();
           //if(!gen.done.triggered)begin
    wait(gen.done.triggered);
     //$display("simulation complete");
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
    
    /*initial begin
    vif.rst =1;
#50 vif.rst=0;
#20 vif.mod =0;
#100 vif.mod =1;
#1000;
    $finish();
    end*/
    always #10 vif.clk = ~vif.clk;

    environment env;

    initial begin
    env=new(vif);
    env.gen.count =30;
    env.run();
    env.run();
env.run();

    end

    
    initial begin
        $shm_open("wave.shm");
        $shm_probe("ACTMF");
#1000;
        $finish();
    end
endmodule
