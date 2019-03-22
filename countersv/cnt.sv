////interface///
interface intf();
    logic clk, rst;
    logic mod;
    logic [2:0] count;
endinterface

//////trans/////
class transaction;
    rand bit mod;          // Randomized mode signal
    rand bit [2:0] count;  // Expected count value

    constraint valid_count {
        count >= 0 && count <= 7;  // Constrain count within 3-bit range
    }

    function void display(string  name);
        $display("%0s: mod=%0d, count=%0d", name , mod, count);
    endfunction
endclass

////gene////
class generator;
    mailbox gen2drv;
    int num_transactions;

    function new(mailbox gen2drv);
        this.gen2drv = gen2drv;
    endfunction

    task generat();
        transaction trans;
        repeat (num_transactions) begin
            trans = new();
            if (!trans.randomize()) $fatal("Transaction randomization failed");
            trans.display("[GEN]");
            gen2drv.put(trans);
        end
    endtask
endclass

///drv////
class driver;
    virtual intf vif;
    mailbox gen2drv;

    function new(virtual intf vif, mailbox gen2drv);
        this.vif = vif;
        this.gen2drv = gen2drv;
    endfunction

    task drive();
        transaction trans;
        forever begin
            gen2drv.get(trans);
            @(posedge vif.clk);
            vif.mod <= trans.mod;
        end
    endtask
endclass

////mon//
class monitor;
    virtual intf vif;
    mailbox mon2scb;

    function new(virtual intf vif, mailbox mon2scb);
        this.vif = vif;
        this.mon2scb = mon2scb;
    endfunction

    task monitor();
        transaction trans;
        forever begin
            @(posedge vif.clk);
            trans = new();
            trans.mod = vif.mod;
            trans.count = vif.count;
            mon2scb.put(trans);
            trans.display("[MONITOR]");
        end
    endtask
endclass
///sco///
class scoreboard;
    mailbox mon2scb;

    function new(mailbox mon2scb);
        this.mon2scb = mon2scb;
    endfunction

    task check();
        transaction trans;
        int expected_count = 0;

        forever begin
            mon2scb.get(trans);
            if (trans.mod)
#15
                expected_count++;
            else
#10
                expected_count--;

            expected_count = (expected_count + 8) % 8;  // Wrap around 3-bit range

            if (expected_count == trans.count)
                $display("[SCOREBOARD] PASS: Time=%0t, Count=%0d", $time, trans.count);
            else
                $display("[SCOREBOARD] FAIL: Time=%0t, Expected=%0d, Got=%0d", $time, expected_count, trans.count);
        end
    endtask
endclass
//env///
class environment;
    generator gen;
    driver drv;
    monitor mon;
    scoreboard scb;

    mailbox gen2drv, mon2scb;
    virtual intf vif;

    function new(virtual intf vif);
        this.vif = vif;
        gen2drv = new();
        mon2scb = new();
        gen = new(gen2drv);
        drv = new(vif, gen2drv);
        mon = new(vif, mon2scb);
        scb = new(mon2scb);
    endfunction

    task run(int num_transactions);
        gen.num_transactions = num_transactions;
        fork
            gen.generat();
            drv.drive();
            mon.monitor();
            scb.check();
        join
    endtask
endclass
///pro//
program test(intf i_intf);
    environment env;

    initial begin
        env = new(i_intf);
        env.run(10);  // Generate 10 transactions
        $finish;
    end
endprogram
///test///
module tb_top;
    logic clk, rst;
    intf i_intf();

    // DUT instance
    counter dut(
        .clk(i_intf.clk),
        .mod(i_intf.mod),
        .rst(i_intf.rst),
        .count(i_intf.count)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Reset generation
    initial begin
        clk = 0;
        rst = 1;
        #15 rst = 0;
    end

    assign i_intf.clk = clk;
    assign i_intf.rst = rst;

    // Test instantiation
    test t1(i_intf);

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_top);
        #1000;
        $finish;
    end
endmodule
