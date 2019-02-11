///////////////////////////TRANSACTION//////////////////
class transaction;
rand bit a;
rand bit b;
bit sum;
bit carry;

function void display(input string name);
$display("[%0s] : A = %0d ,\t B = %0d,\t SUM = %0d, CARRY = %0d", name,a,b,sum,carry);
endfunction

constraint data_a {
                    b dist{ 0 :/ 50 , 1 :/ 50};}


constraint data_b {
                    a dist{ 0 :/ 50 , 1 :/50};}
endclass

/////////////////////GENERATOR////////////////////////

class generator;
transaction tr;
mailbox gen2drv;

function new(mailbox gen2drv);
this.gen2drv = gen2drv;
tr = new();

endfunction


task run();
   repeat(1)
        begin
       // for(int i = 0 ; i <10 ; i++) begin
            assert(tr.randomize()) else $error("RANDOMIZE FAILED");
    $display("RANDOMIZE SUCEESSFULLY");
    //$display("GEN");
    tr.display("GEN");
    gen2drv.put(tr);
        end
    endtask
    endclass
///////////////////////////////////////////////INTERFACE////////////////////////////////////

interface half_add();
logic a;
logic b;
logic sum;
logic carry;
endinterface

//////////////////////////DRIVER////////////////////////////

class driver;

transaction tr;

virtual half_add vif;

mailbox gen2drv;

function new(virtual half_add vif,mailbox gen2drv);
this.vif = vif;
this.gen2drv =gen2drv;
endfunction

task run();
repeat(1)
     begin
    gen2drv.get(tr);
    vif.a <= tr.a;
    vif.b <= tr.b;
    tr.display("DRV");
    end
endtask
endclass

/////////////////MONITOR//////////////////////////
class monitor;
transaction tr;

virtual half_add vif;

mailbox mon2sco;

function new ( virtual half_add vif,mailbox mon2sco );
this.vif = vif;
this.mon2sco =mon2sco;
endfunction

task run();
tr = new();
    repeat(1)
#4;
    begin

tr.a = vif.a;
tr.b = vif.b;
tr.sum = vif.sum;
tr.carry = vif.carry;
mon2sco.put(tr);
tr.display("MON");
end
endtask

endclass

///////////////////////////////////SCOREBOARD/////////////////////

class scoreboard;
mailbox mon2sco;
transaction tr;

function new(mailbox mon2sco);
this.mon2sco = mon2sco;
endfunction

task run();

    repeat(1)
        begin
        mon2sco.get(tr);
        tr.display("SCO");
       // if((tr.sum == (tr.a ^ tr.b)) && ( tr.carry == (tr.a & tr.b ) )

       if(((tr.a ^ tr.b) == tr.sum ) && ((tr.a & tr.b ) == tr.carry))
       //if((tr.sum == (tr.a ^ tr.b) && (tr.carry == (tr.a & tr.b)))
           begin
        $display("--------------HALF-ADDER VERIFED----------------");
        end
        else begin
            $display("--------------MISMATCHED------------");
            end
            $display("---------------------------------------------");
            end
            endtask
            endclass
////////////////////////////////////ENVIRONMENT///////////////////////////

class environment;

generator gen;
monitor mon;
driver drv;
scoreboard sco;

mailbox m1,m2;


virtual half_add vif;

function new (virtual half_add vif);
this.vif = vif;
m1 = new();
m2 = new();
gen = new(m1);
drv = new(vif,m1);
mon = new(vif,m2);
sco = new(m2);
endfunction

task test();
fork
gen.run();
drv.run();
mon.run();
sco.run();
join
endtask

task run();
test();
endtask

endclass

///////////////////////////////PROGRAM////////////////////////////

program test(half_add i_intf);
environment env;
initial begin
int count=6;
env = new(i_intf);
repeat(count)
env.run;
//env.run;
//env.run;
//env.run;
$finish();
end
endprogram

///////////////////////TESTBENCH/////////////////////////////

module tb_top;

half_add i_intf();
test t1(i_intf);

half_adder dut(.a(i_intf.a),
               .b(i_intf.b),
               .sum(i_intf.sum),
               .carry(i_intf.carry));

initial begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end
endmodule



