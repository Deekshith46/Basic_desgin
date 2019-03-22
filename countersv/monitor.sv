class monitor;
    virtual int vif;
    mailbox mon2sco;

    function new(virtual intf vif, mailbox mon2sco);
    this.vif = vif;
    this.mon2sco = mon2sco;
    endfunction

    task main();
    forever begin
        transaction trans;
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
