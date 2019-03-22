class scoreboard;
transaction trans;
    mailbox mon2sco;
    int no_transaction;
    logic [2:0] sco_count;

        function new(mailbox mon2sco);
        this.mon2sco = mon2sco;
        endfunction

        task main();
        
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
