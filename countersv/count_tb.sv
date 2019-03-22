
//////////trans///////////
class transaction;
randc bit mod;
 bit[2:0]count;

function void display(input string name);
    $display("------------------------------");
    $display("- %s",name);
    $display("------------------------------");
    $display("-mod = %0d",mod);
    $display("-count = %0d",count);
endfunction
endclass
////////gen/////////////
class generator;
   transaction trans;
int repeat_count;
mailbox gen2drv;
event ended;

    function new(mailbox gen2drv);
    trans=new();
    this.gen2drv = gen2drv;
    endfunction

    task main();
    repeat(repeat_count)begin
    //trans = new();
        if(!trans.randomize()) $fatal("GEN :: transa randomization failed");
        trans.display("[GEN]");
        gen2drv.put(trans);
    end
    -> ended;
    endtask
endclass
/////////interface///////////
interface intf();
logic clk,rst;
logic mod;
logic[2:0] count;
endinterface
//////driver//////////
class driver;
    transaction trans;
int no_transaction;

virtual intf vif;

mailbox gen2drv;
    function new(virtual intf vif , mailbox gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
    endfunction

    task rst();
        wait(vif.rst);
        $display("[DRV]--------RESET STARTED-----");
        vif.mod <= 0;
        wait(!vif.rst);
        $display("[DRV] --------RESET ENDED------");
        endtask

     task main();
     forever begin
        transaction trans;
        gen2drv.get(trans);
        @(posedge vif.clk);
        vif.mod <= trans.mod;
       @(posedge vif.clk);
       trans.count = vif.count;
       @(posedge vif.clk);
       trans.display("[ DRIVER]");
       no_transaction++;
       end
     endtask
endclass
//////////monitor////////////
class monitor;
transaction trans;
    virtual intf vif;
    mailbox mon2sco;

    function new(virtual intf vif, mailbox mon2sco);
    this.vif = vif;
    this.mon2sco = mon2sco;
    endfunction

    task main();
    trans = new();
    forever begin
                
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
///////////score////////
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
                    sco_count = sco_count -1;
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
/////////////env////////////////
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
/////////program////////
program test(intf i_intf);

    environment env;

    initial begin

        env = new(i_intf);
        env.gen.repeat_count = 4;
        env.run();
        end
        endprogram
///////////////////test/////////
module tb_top;
bit clk;

bit rst;

always #5 clk= ~clk;

initial begin
    rst =1;
#10 rst =0;
end


intf i_intf();
test t1(i_intf);

counter dut(.clk(i_intf.clk),
            .mod(i_intf.mod),
            .rst(i_intf.rst),
            .count(i_intf.count));

initial begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end
initial begin
$finish();
end
endmodule
