////////// Transaction Class //////////
class transaction;
    randc bit mod;
    randc bit [2:0] count;

    function void display(input string name);
        $display("------------------------------");
        $display("- %s", name);
        $display("------------------------------");
        $display("- mod   = %0d", mod);
        $display("- count = %0d", count);
    endfunction
endclass

////////// Generator Class //////////
class generator;
    transaction trans;
    int repeat_count;
    mailbox gen2drv;
    event ended;

    function new(mailbox gen2drv);
        this.gen2drv = gen2drv;
        trans = new();
    endfunction

    task main();
        repeat (repeat_count) begin
            if (!trans.randomize()) begin
                $display("[GEN] Randomization failed!");
                $fatal("GEN :: transaction randomization failed");
            end
            trans.display("[GEN]");
            gen2drv.put(trans);
        end
        -> ended;
    endtask
endclass

////////// Driver Class //////////
class driver;
    transaction trans;
    int no_transaction;
    virtual intf vif;
    mailbox gen2drv;

    function new(virtual intf vif, mailbox gen2drv);
        this.vif = vif;
        this.gen2drv = gen2drv;
    endfunction

    task reset();
        $display("[DRV] -------- RESET STARTED --------");
        vif.mod <= 0;
        @(posedge vif.clk);
        @(negedge vif.rst);
        $display("[DRV] -------- RESET ENDED --------");
    endtask

    task main();
        forever begin
            gen2drv.get(trans);
            @(posedge vif.clk);
            vif.mod <= trans.mod;
            @(posedge vif.clk);
            trans.count = vif.count;
            @(posedge vif.clk);
            trans.display("[DRV]");
            no_transaction++;
        end
    endtask
endclass

////////// Monitor Class //////////
class monitor;
    transaction trans;
    virtual intf vif;
    mailbox mon2sco;

    function new(virtual intf vif, mailbox mon2sco);
        this.vif = vif;
        this.mon2sco = mon2sco;
    endfunction

    task main();
        forever begin
            trans = new();
            @(posedge vif.clk);
            trans.mod = vif.mod;
            @(posedge vif.clk);
            trans.count = vif.count;
            @(posedge vif.clk);
            mon2sco.put(trans);
            trans.display("[MONITOR]");
        end
    endtask
endclass

////////// Scoreboard Class //////////
class scoreboard;
    transaction trans;
    mailbox mon2sco;
    int no_transaction;
    logic [2:0] sco_count = 0;

    function new(mailbox mon2sco);
        this.mon2sco = mon2sco;
    endfunction

    task main();
        forever begin
            mon2sco.get(trans);
            if (trans.mod)
                sco_count = (sco_count + 1) % 8;
            else
                sco_count = (sco_count - 1 + 8) % 8;

            trans.display("[SCOREBOARD]");
            if (sco_count == trans.count)
                $display("[SCOREBOARD] Match: Time = %0t, RTL Count = %0d, SCO Count = %0d", $time, trans.count, sco_count);
            else
                $display("[SCOREBOARD] Mismatch: Time = %0t, RTL Count = %0d, SCO Count = %0d", $time, trans.count, sco_count);
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

    task test();
        fork
            gen.main();
            drv.main();
            mon.main();
            scb.main();
        join_any
    endtask

    task post_test();
        wait(gen.ended.triggered);
        $display("[ENV] Transactions generated: %0d, Transactions processed: %0d", gen.repeat_count, drv.no_transaction);
        if (gen.repeat_count == drv.no_transaction)
            $display("[ENV] Test PASSED");
        else
            $display("[ENV] Test FAILED");
    endtask

    task run();
        pre_test();
        test();
        post_test();
        $finish();
    endtask
endclass

////////// Test Program //////////
program test(intf i_intf);
    environment env;

    initial begin
        env = new(i_intf);
        env.gen.repeat_count = 4;
        env.run();
    end
endprogram

////////// Testbench Top //////////
module tb_top;
    bit clk, rst;

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        #10 rst = 0;
    end

    intf i_intf();

    test t1(i_intf);

    counter dut(
        .clk(i_intf.clk),
        .mod(i_intf.mod),
        .rst(i_intf.rst),
        .count(i_intf.count)
    );

    /*initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_top);
    end*/
endmodule