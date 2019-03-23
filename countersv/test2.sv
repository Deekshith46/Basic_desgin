////////// Transaction Class //////////
class transaction;
    randc bit mod;
     bit [2:0] count;
    function void display(string  name);
        $display("%0s: mod=%0d, count=%0d", name , mod, count);
    endfunction

    endclass

////////// Generator Class //////////
class generator;
    mailbox gen2drv;
    int num_transactions;

    function new(mailbox gen2drv);
        this.gen2drv = gen2drv;
    endfunction

    task main();
        transaction trans;
        repeat (num_transactions) begin
            trans = new();
            if (!trans.randomize())
                $fatal("Transaction randomization failed");
            trans.display("[GEN]");
            gen2drv.put(trans);
        end
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
    transaction trans;
    virtual intf vif;
    mailbox gen2drv;

    function new(virtual intf vif, mailbox gen2drv);
        this.vif = vif;
        this.gen2drv = gen2drv;
    endfunction

    /*task reset();
        $display("[DRV] -------- RESET STARTED --------");
        vif.mod <= 0;
        vif.count <= 0;
        @(posedge vif.clk);
        @(negedge vif.rst);
        $display("[DRV] -------- RESET ENDED --------");
    endtask*/
    task reset();
        $display("[DRV] -------- RESET STARTED --------");
        vif.mod <= 0;
        while(!vif.rst)
            @(posedge vif.clk);
            $display("[drv] reset asserted");
            while(vif.rst)
            @(posedge vif.clk);
            $display("[drv] reset de-asserted");
              $display("[DRV] -------- RESET ENDED --------");
    endtask
    
    /*task reset();
        wait(vif.rst);
        $display("[DRV]--------RESET STARTED-----");
        vif.mod <= 0;
        wait(!vif.rst);
        $display("[DRV] --------RESET ENDED------");
        endtask*/


    task main();
        forever begin
        gen2drv.get(trans);
            @(posedge vif.clk);
            vif.mod <= trans.mod;
            trans.display("[DRV]");
                   end
    endtask
endclass

////////// Monitor Class //////////
class monitor;
        virtual intf vif;
    mailbox mon2sco;

    function new(virtual intf vif, mailbox mon2sco);
        this.vif = vif;
        this.mon2sco = mon2sco;
    endfunction

    task main();
    transaction trans;
        forever begin
             @(posedge vif.clk);
            trans = new();
            trans.mod = vif.mod;
            trans.count = vif.count;
            mon2sco.put(trans);
            trans.display("[MONITOR]");
        end
    endtask
endclass

////////// Scoreboard Class //////////
class scoreboard;
    mailbox mon2scb;

    function new(mailbox mon2scb);
        this.mon2scb = mon2scb;
    endfunction

    task main();
        transaction trans;
        int expected_count = 0;
       
        forever begin
            mon2scb.get(trans);
           
            if (trans.mod)
                expected_count++;
                
            else

                expected_count--;

            expected_count = (expected_count + 8) % 8;  // Wrap around 3-bit range

            if (expected_count == trans.count)
                $display("[SCOREBOARD] PASS: Time=%0t, Expected=%0d, dutout=%0d", $time, expected_count,trans.count);
            else
                $display("[SCOREBOARD] FAIL: Time=%0t, Expected=%0d, dutout=%0d", $time, expected_count, trans.count);
        end
        
    endtask
endclass


////////// Environment Class //////////
class environment;
    generator gen;
    driver drv;
    monitor mon;
    scoreboard scb;

    mailbox gen2drv;
    mailbox mon2sco;
    virtual intf vif;

    function new(virtual intf vif);
        this.vif = vif;
        gen2drv = new();
        mon2sco = new();
        gen = new(gen2drv);
        drv = new(vif, gen2drv);
        mon = new(vif, mon2sco);
        scb = new(mon2sco);
    endfunction

    task pre_test();
        drv.reset();
    endtask

    task run(int num_transactions);
    gen.num_transactions = num_transactions;
        fork
            gen.main();
            drv.main();
            mon.main();
            scb.main();
        join
    endtask

   /* task post_test();
        wait(gen.ended.triggered);
        wait(gen.repeat_count == driv.no_transaction);

       // $display("[ENV] Transactions generated: %0d, Transactions processed: %0d", gen.repeat_count, drv.no_transaction);
       // if (gen.repeat_count == drv.no_transaction)
           // $display("[ENV] Test PASSED");
        //else
           // $display("[ENV] Test FAILED");
    endtask*/

    /*task run();
        pre_test();
        //test();
        post_test();
        $finish();
    endtask*/
endclass

////////// Test Program //////////
program test(intf i_intf);
    environment env;

    initial begin
        env = new(i_intf);
        //env.gen.repeat_count = 4;
        env.run(10);
    end
endprogram

////////// Testbench Top //////////
module tb_top;
    logic clk, rst;

    always #5 clk = ~clk;

    initial begin
        clk = 0;
#5
        rst = 1;
        #10 rst = 0;
    end

    intf i_intf();
   assign i_intf.clk = clk;
    assign i_intf.rst =rst;

    test t1(i_intf);

    counter dut(
        .clk(i_intf.clk),
        .mod(i_intf.mod),
        .rst(i_intf.rst),
        .count(i_intf.count)
    );

    initial begin
        $shm_open("wave.shm");
        $shm_probe("ACTMF");
#1000;
        $finish();
    end
endmodule
