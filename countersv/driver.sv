class driver;
int no_transaction;

virtual intf vif;

mailbox gen2drv;
    function new(virtual intf vif , mailbox gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
    endfunction

    task rst;
        wait(vif.rst);
        $display("[DRV]--------RESET STARTED-----");
        vif.mod <= 0;
        wait(!vif.rst);
        $display("[DRV] --------RESET ENDED------");
        endtask

     task main;
     forever begin
        transaction trans;
        gen2drv.get(trans);
        @(posedge vif.clk);
        vif.mod <= trans.mod;
       @(posedge vif.clk);
       trans.counter = vif.counter;
       @(posedge vif.clk);
       trans.display("[ DRIVER]");
       no_transaction++;
       end
     endtask
endclass
