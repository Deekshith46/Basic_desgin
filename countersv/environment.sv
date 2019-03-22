
`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;

    generator gen;
    driver driv;
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
        driv = new(vif,gen2drv);
        mon = new(vif,mon2sco);
        scb = new(mon2sco);
        endfunction

        task pre_test();
            driv.rst();
            endtask

          task test();
          fork
          gen.main();
          driv.main();
          mon.main();
          scb.main();
          join_any
          endtask

          task post_test();
          wait(gen.ended.triggered);
          wait(gen.repeat_count == driv.no_transaction);
          endtask

          task run();
            pre_test();
            test();
            post_test();
            $finish();
            endtask

endclass
