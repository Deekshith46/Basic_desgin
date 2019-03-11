////Desginer:-Deekshith
////Desgin :- BCD_ADDER
module bcd_adder(a,b,cin,sum,carry);
input [3:0] a,b;
input cin;
output  [3:0] sum;
output  carry;

reg [4:0] sum_result, correction;

always@(*) begin
    sum_result = a + b + cin;
    if(sum_result>9)begin
       correction = sum_result + 3'b110;
   end

   else begin
       correction = sum_result;
    end
end
    assign sum = correction[3:0];
    assign carry = correction[4];


endmodule


`timescale 1ns/1ps

`include "uvm_macros.svh"
    import uvm_pkg::*;

class transaction extends uvm_sequence_item;

    randc bit [3:0] a;
    randc bit [3:0] b;
          bit [3:0] y;

    function new(string path = "transaction" );
    super.new(path);
    endfunction

   `uvm_object_utils_begin(transaction)
   `uvm_field_int(a,UVM_DEFAULT)
   `uvm_field_int(b,UVM_DEFAULT)
   `uvm_field_int(y,UVM_DEFAULT)    
   `uvm_object_utils_end

endclass

class generator extends uvm_sequence #(transaction);
    `uvm_object_utils(generator)

    transaction t;

    integer i;

    function new(input string path = "generator" );
    super.new(path);
    endfunction

    virtual task body();
    t = transaction::type_id::create("t");
    repeat(10)
    begin
    start_item(t);
    t.randomize();
    `uvm_info("GEN",$sformatf("Data send to driver a:%0d , b:%0d",t.a, t.b),UVM_NONE);
    finish_item(t);
    end
    endtask

endclass


interface adder_if();
logic [3:0] a;
logic [3:0] b;
logic [3:0] y;
endinterface



class driver extends uvm_driver#(transaction);

    `uvm_component_utils(driver)

    function new (input string path = "driver" , uvm_component parent =  null);
     super.new(path,parent);
    endfunction

    transaction tc;
    virtual adder_if addif;

    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tc = transaction::type_id::create("tc");
    if(!uvm_config_db #(virtual adder_if)::get(this,"","addif",addif))
    `uvm_error("DRV", "UNABLE TO ACCESS UVM_CONGIF_DB");
    endfunction



    virtual task run_phase(uvm_phase phase);
    forever begin
    seq_item_port.get_next_item(tc);
    addif.a <= tc.a;
    addif.b <= tc.b;
    `uvm_info("DRV",$sformatf("Data driver to DUT a:%0d , b:%0d",tc.a, tc.b),UVM_NONE);
    seq_item_port.item_done();
    #10;
    end
    endtask
endclass

///////////MONITOR///////////

class monitor extends uvm_monitor;

    `uvm_component_utils(monitor)

    uvm_analysis_port #(transaction)send;

    function new (input string path = "monitor" , uvm_component parent =  null);
     super.new(path,parent);
     send = new("send",this);
    endfunction

    transaction t;
    virtual adder_if addif;

    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t =  transaction::type_id::create("t");
    if(!uvm_config_db #(virtual adder_if)::get(this,"","addif",addif))
    `uvm_error("MON", "UNABLE TO ACCESS UVM_CONGIF_DB");
    endfunction


    virtual task run_phase(uvm_phase phase);
    forever begin
    #10;
    t.a = addif.a;
    t.b = addif.b;
    t.y = addif.y;
    `uvm_info("MON",$sformatf("Data driver to DUT a:%0d , b:%0d",seq.a, seq.b),UVM_NONE)
    send.write(t);
        end
    endtask
endclass

//////////scoreboard///////

class scoreboard extends uvm_scoreboard;
    
    `uvm_component_utils(scoreboard)

    uvm_analysis_imp #(transaction, scoreboard) recv;

    transaction tr;


    function new(input string path ="scoreboard" , uvm_component parent = null);
    super.new(path,parent);
    recv = new("recv",this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr =  transaction::type_id::create("tr");
    endfunction

    virtual function void write(input transaction t );
    tr = t;
    `uvm_info("SCO", $sformarf("Data rcvd from mon a= %0d, b = %0d, and y = %0d ",tr.a, tr.b, tr.y),UVM_NONE);
    if(tr.y == tr.a + tr.b)
        `uvm_info("SCO","Test passed ", UVM_NONE);
        else
         `uvm_info("SCO","Test failed", UVM_NONE);
    endfunction
endclass

////////////agent///////////
class agent extends uvm_extend;

    `uvm_component_utils(agent)

    function new (input string path = "agent" , uvm_component parent = null);
     super.new(path , parent);
    endfunction

    monitor mon;
    driver drv;
    uvm_sequencer #(transaction) seqr;

    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon = monitor::type_id::create("mon",this);
    drv = driver::type_id::create("drv",this);
    seqr =  uvm_sequencer #(transaction)::type_id::create("seqr",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction

endclass


class env extends uvm_env;

    `uvm_component_utils(env)

    function new (input string path = "env" , uvm_component parent = null);
     super.new(path,parent);
    endfunction

    scoreboard s;
    agent a;

 
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    s = scoreboard::type_id::create("s",this);
    a = agent::type_id::create("a",this);   
    endfunction

    virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a.mon.send.connect(s.recv);
    endfunction

endclass


class test extends uvm_test;

    `uvm_component_utils(test)

    function new (string path = "test" , uvm_component parent =  null);
     super.new(path,parent);
    endfunction

   generator gen;
   env e;
 
    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    gen = generator::type_id::create("gen",this);
    e = env::type_id::create("e",this);   
    endfunction

    virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    gen.start(e.a.seqr);
    #50;
    phase.drop_objection(this);
    endtask
endclass

module add_tb();

adder_if addif();

adder dut(.a(addif.a), .b(addif.b), .y(addif.y));

initial begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end

initial begin
uvm_config_db#(virtual adder_if()::set(null,"uvm_test_top.e.a*","addif",addif));
run_test("test");
end
endmodule
