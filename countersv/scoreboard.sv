class scoreboard;
    mailbox mon2sco;
    int no_transaction;
    int [2:0] sco_count;

        function new(mailbox mon2sco);
        this.mon2sco = mon2sco;
        endfunction

        task main;
        transaction trans;
            forever begin
            mon2sco.get(trans);
                if(trans.mod)
                begin
                    sco_count = sco_count +1;
                end
                else
                begin
                    sco_count = sco-count -1;
                end 
                trans.display("[SCOREBOARD]");
            end
            @(posedge clk)begin
                if(sco_count == trans.count)begin
                    $display("Match = %0t , rtl out = %0d , scoout = %0d", $time,trans.count,sco_count);
                    end
                    else
                        begin
                        $display("NOTMatch = %0t , rtl out = %0d , scoout = %0d", $time,trans.count,sco_count);
                       end
            end
        endtask
endclass
