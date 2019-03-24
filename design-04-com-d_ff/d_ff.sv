/////////////D FLIP FLOP///////////////////

///////////////////TRANSACTION//////////////

class transaction;
rand bit din;
bit dout;

function transaction copy();
copy = new();
copy.din = this.din;
copy.dout = this.dout;
endfunction

function void display(input string tag);
$display("[%0s] : DIN : %0b DOUT : %0b" , tag ,din,dout);
endfunction

endclass

////////////////////////Generator//////////////
class generator;
transaction tr;

mailbox #(transaction) mbx;/////////mailbox for driver
mailbox #(transaction) mbxref ;//////////mailbox for generator

event sconext;
event done;

int count;

function new(mailbox #(transaction) mbx,mailbox #(transaction) mbxref );
this.mbx = mbx;
this.mbxref = mbxref;
tr = new();
endfunction

task run();
    repeat(count) begin
        assert(tr.randomize) else $error("[GEN] : RANDOMIZATION FAILED");
        mbx.put(tr.copy);
        mbxref.put(tr.copy);
        tr.display("GEN");
        @(sconext);
        end
        -> done;
        endtask
        endclass

//////////////////////////////INTERFACE////////////

interface dff_if;
logic clk;
logic rst;
logic din;
logic dout;
endinterface


///////////////////////////DRIVER////////////////

class driver;
transaction tr;
mailbox #(transaction) mbx; //////////to recive from the gene///////
virtual dff_if vif;
function new(mailbox #(transaction) mbx);
this.mbx = mbx;
endfunction
task reset();
//tr = new();
vif.rst <= 1'b1;
repeat(5) @(posedge vif.clk);
vif.rst <= 1'b0;
@(posedge vif.clk);
$display("[DRV] : RESET DONE");
endtask

task run();
//tr = new();
forever begin
mbx.get(tr);
vif.din <= tr.din;
@(posedge vif.clk);
tr.display("DRV");
vif.din <= 1'b0;
@(posedge vif.clk);
end
endtask
endclass

/////////////////////MONIOR////////////

class monitor;
transaction tr;

mailbox #(transaction) mbx;

virtual dff_if vif;

function new(mailbox #(transaction) mbx);
this.mbx = mbx;
endfunction

task run();
tr = new();
forever begin
repeat(2) @(posedge vif.clk);
tr.dout = vif.dout;
mbx.put(tr);
tr.display("MON");
end
endtask

endclass

//////////////////SCOREBOARD///////////////////
class scoreboard;
transaction tr;
transaction trref;

mailbox #(transaction) mbx;
mailbox #(transaction) mbxref;
event sconext;

function new(mailbox #(transaction) mbx,mailbox #(transaction) mbxref );
this.mbx = mbx;
this.mbxref = mbxref;
//tr = new();
endfunction

task run();
forever begin
mbx.get(tr);
mbxref.get(trref);

tr.display("SCO");
trref.display("REF");

if(tr.dout == trref.din)
    $display("[SCO] : DATA MATCHED");
    else
        $display("[SCO] : DATA MISMATCHED");

        $display("------------------------------------------------");
        -> sconext;
        end
        endtask
        endclass

///////////////////////////ENVIRONMENT////////////////

class environment;
generator gen;
driver drv;
monitor mon;
scoreboard sco;

event next;

mailbox #(transaction) gdmbx;///////gen2drv

mailbox #(transaction) msmbx; ///////mon2sco


mailbox #(transaction) mbxref; /////////gen2sco

virtual dff_if vif;

function new(virtual dff_if vif);
gdmbx = new();
mbxref = new();


gen = new(gdmbx,mbxref);
drv = new(gdmbx);
msmbx = new();
mon = new(msmbx);
sco = new(msmbx , mbxref);


this.vif = vif;
drv.vif = this.vif;
mon.vif = this.vif;

gen.sconext = next;
sco.sconext = next;

endfunction

task pre_test();
drv.reset();
endtask

task test();
fork
gen.run();
drv.run();
mon.run();
sco.run();
join_any
endtask


task post_test();
wait(gen.done.triggered);
$finish();
endtask

task run();
pre_test();
test();
post_test();
endtask

endclass

////////////////////TESTBENCH//////////
module tb;
dff_if vif();

d_ff dut(.din(vif.din),
          .clk(vif.clk),
          .rst(vif.rst),
          .dout(vif.dout));

initial begin
vif.clk <= 0;
end

always #10 vif.clk = ~vif.clk;

environment env;

initial begin
env= new(vif);
env.gen.count = 30;
env.run();
end
endmodule







