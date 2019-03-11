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
//////////////transaction/////////////

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

    //integer i;

    function new(input string path = "generator" );
    super.new(path);
    endfunction

    virtual task body();
    transaction t;
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
    virtual add_if aif;

    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tc = transaction::type_id::create("tc");
    if(!uvm_config_db #(virtual add_if)::get(this,"","aif",aif))
    `uvm_error("DRV", "UNABLE TO ACCESS UVM_CONGIF_DB");
    endfunction



    virtual task run_phase(uvm_phase phase);
    forever begin
    seq_item_port.get_next_item(tc);
    aif.a <= tc.a;
    aif.b <= tc.b;
    `uvm_info("DRV",$sformatf("Data driver to DUT a:%0d , b:%0d",tc.a, tc.b),UVM_NONE);
    seq_item_port.item_done();
    #10;
    end
    endtask
endclass

///////////MONITOR///////////

class monitor extends uvm_monitor;

    `uvm_component_utils(monitor)

    uvm_analysis_port #(transaction) send;

    function new (input string path = "monitor" , uvm_component parent =  null);
     super.new(path,parent);
     send = new("send",this);
    endfunction

    transaction t;
    virtual addr_if aif;

    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t =  transaction::type_id::create("t");
    if(!uvm_config_db #(virtual add_if)::get(this,"","aif",aif))
    `uvm_error("MON", "UNABLE TO ACCESS UVM_CONGIF_DB");
    endfunction


    virtual task run_phase(uvm_phase phase);
    forever begin
    #10;
    t.a = aif.a;
    t.b = aif.b;
    t.y = aif.y;
    `uvm_info("MON",$sformatf("Data driver to DUT a:%0d , b:%0d , y=%0d",t.a, t.b,t.y),UVM_NONE)
    send.write(t);
        end
    endtask
endclass

//////////scoreboard///////

class scoreboard extends uvm_scoreboard;
    
    `uvm_component_utils(scoreboard)

    uvm_analysis_imp #(transaction, scoreboard) recv;

  
    function new(input string path ="scoreboard" , uvm_component parent = null);
    super.new(path,parent);
    recv = new("recv",this);
    endfunction

   /* virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr =  transaction::type_id::create("tr");
    endfunction*/

    virtual function void write(input transaction t );
     `uvm_info("SCO", $sformatf("Data rcvd from mon a= %0d, b = %0d, and y = %0d ",t.a, t.b, t.y),UVM_NONE);
    if(t.y == t.a + t.b)
        `uvm_info("SCO","Test passed ", UVM_NONE);
        else
         `uvm_info("SCO","Test failed", UVM_NONE);
    endfunction
endclass

////////////agent///////////
class agent extends uvm_agent;

    `uvm_component_utils(agent)

    function new (input string path = "agent" , uvm_component parent = null);
     super.new(path,parent);
    endfunction

    monitor m;
    driver d;
    uvm_sequencer #(transaction) seqr;

    virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m = monitor::type_id::create("m",this);
    d = driver::type_id::create("d",this);
    seqr =  uvm_sequencer #(transaction)::type_id::create("seqr",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d.seq_item_port.connect(seqr.seq_item_export);
    endfunction

endclass


class env extends uvm_env;

    `uvm_component_utils(env)

    function new (input string path = "ENV" , uvm_component parent c);
     super.new(inst,c);
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
    a.m.send.connect(s.recv);
    endfunction

endclass


class test extends uvm_test;

    `uvm_component_utils(test)

    function new (string path = "TEST" , uvm_component parent c);
     super.new(inst,c);
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

add_if aif();

adder dut(.a(aif.a), .b(aif.b), .y(aif.y));

initial begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end

initial begin
uvm_config_db #(virtual add_if)::set(null,"uvm_test_top.e.a*","aif",aif);
run_test("test");
end
endmodule

|
ncvlog: *W,DLCPTH (/tools/cadence/FOUNDRY/cds.lib,19): cds.lib Invalid path '/home/install/FOUNDRY/rfLib_new' (cds.lib command ignored).
file: verification.sv
    t.randomize();
              |
ncvlog: *W,FUNTSK (verification.sv,40|14): function called as a task without void'().
        else
           |
ncvlog: *E,NOTSTT (verification.sv,147|11): expecting a statement [9(IEEE)].
class agent extends uvm_agent;
                            |
ncvlog: *E,SVNOTY (verification.sv,153|28): Syntactically this identifier appears to begin a datatype but it does not refer to a visible datatype in the current scope.
    `uvm_component_utils (agent);
                               |
ncvlog: *E,SVNOTY (verification.sv,155|31): Syntactically this identifier appears to begin a datatype but it does not refer to a visible datatype in the current scope.
(`define macro: m_uvm_component_registry_internal [/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/macros/uvm_object_defines.svh line 467], `define macro: uvm_component_utils [/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/macros/uvm_object_defines.svh line 330], file: verification.sv line 155)
    `uvm_component_utils (agent);
                               |
ncvlog: *E,SVEXTK (verification.sv,155|31): expecting a ';' (to terminate a type_declaration).
(`define macro: m_uvm_component_registry_internal [/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/macros/uvm_object_defines.svh line 467], `define macro: uvm_component_utils [/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/macros/uvm_object_defines.svh line 330], file: verification.sv line 155)
    `uvm_component_utils (agent);
                               |
ncvlog: *E,SVEXTK (verification.sv,155|31): expecting a ';' (to terminate a type_declaration).
(`define macro: m_uvm_component_registry_internal [/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/macros/uvm_object_defines.svh line 467], `define macro: uvm_component_utils [/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/macros/uvm_object_defines.svh line 330], file: verification.sv line 155)
    `uvm_component_utils (agent);
                               |
ncvlog: *E,SVNOTY (verification.sv,155|31): Syntactically this identifier appears to begin a datatype but it does not refer to a visible datatype in the current scope.
(`define macro: m_uvm_component_registry_internal [/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/macros/uvm_object_defines.svh line 467], `define macro: uvm_component_utils [/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/macros/uvm_object_defines.svh line 330], file: verification.sv line 155)
    `uvm_component_utils (agent);
                               |
ncvlog: *E,EXPSMC (verification.sv,155|31): expecting a semicolon (';') [10.3.1(IEEE)].
(`define macro: m_uvm_component_registry_internal [/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/macros/uvm_object_defines.svh line 467], `define macro: uvm_component_utils [/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/macros/uvm_object_defines.svh line 330], file: verification.sv line 155)
    `uvm_component_utils (agent);
                               |
ncvlog: *E,SVNOTY (verification.sv,155|31): Syntactically this identifier appears to begin a datatype but it does not refer to a visible datatype in the current scope.
(`define macro: m_uvm_component_registry_internal [/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/macros/uvm_object_defines.svh line 467], `define macro: uvm_component_utils [/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/macros/uvm_object_defines.svh line 330], file: verification.sv line 155)
    `uvm_component_utils (agent);
                               |
ncvlog: *E,EXPSMC (verification.sv,155|31): expecting a semicolon (';') [10.3.1(IEEE)].
(`define macro: m_uvm_component_registry_internal [/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/macros/uvm_object_defines.svh line 467], `define macro: uvm_component_utils [/tools/cadence/INCISIVE152/tools/methodology/UVM/CDNS-1.1d/sv/src/macros/uvm_object_defines.svh line 330], file: verification.sv line 155)
    `uvm_component_utils (agent);
                                |
ncvlog: *W,UEXPSC (verification.sv,155|32): Ignored unexpected semicolon following SystemVerilog description keyword (endfunction).
    function new (input string path = "agent" , uvm_component parent = null);
                                                            |
ncvlog: *E,EXPRPA (verification.sv,157|60): expecting a right parenthesis (')') [A.2.6(IEEE)].
    function new (input string path = "agent" , uvm_component parent = null);
                                                            |
ncvlog: *E,NOIPRT (verification.sv,157|60): Unrecognized declaration 'uvm_component' could be an unsupported keyword, a spelling mistake or missing instance port list '()' [SystemVerilog].
    function new (input string path = "agent" , uvm_component parent = null);
                                                            |
ncvlog: *E,NOTINF (verification.sv,157|60): Interfaces are not allowed within tasks [SystemVerilog].
    function new (input string path = "agent" , uvm_component parent = null);
                                                                   |
ncvlog: *E,ILLPDL (verification.sv,157|67): Mixing of ansi & non-ansi style port declaration is not legal.
    function new (input string path = "agent" , uvm_component parent = null);
                                                                     |
ncvlog: *E,EXPSMC (verification.sv,157|69): expecting a semicolon (';') [12.3.2(IEEE)].
     super.new(path,parent);
         |
ncvlog: *E,EXPRPA (verification.sv,158|9): expecting a right parenthesis (')') [A.2.6(IEEE)].
    monitor m;
          |
ncvlog: *E,NOIPRT (verification.sv,161|10): Unrecognized declaration 'monitor' could be an unsupported keyword, a spelling mistake or missing instance port list '()' [SystemVerilog].
    driver d;
         |
ncvlog: *E,NOIPRT (verification.sv,162|9): Unrecognized declaration 'driver' could be an unsupported keyword, a spelling mistake or missing instance port list '()' [SystemVerilog].
    uvm_sequencer #(transaction) seqr;
                |
ncvlog: *E,EXPENC (verification.sv,163|16): Expecting the keyword 'endclass'.
    virtual function void build_phase(uvm_phase phase);
                   |
ncvlog: *E,BADQAL (verification.sv,165|19): Lifetime or qualifier(s) 'virtual' not allowed before function declaration.
    virtual function void build_phase(uvm_phase phase);
                                              |
ncvlog: *E,SVNOTY (verification.sv,165|46): Syntactically this identifier appears to begin a datatype but it does not refer to a visible datatype in the current scope.
    virtual function void connect_phase(uvm_phase phase);
                   |
ncvlog: *E,BADQAL (verification.sv,172|19): Lifetime or qualifier(s) 'virtual' not allowed before function declaration.
    virtual function void connect_phase(uvm_phase phase);
                                                |
ncvlog: *E,SVNOTY (verification.sv,172|48): Syntactically this identifier appears to begin a datatype but it does not refer to a visible datatype in the current scope.
endclass
       |
ncvlog: *E,MPANDC (verification.sv,177|7): expecting the keyword 'module', 'macromodule', 'primitive', 'connectmodule','connect', 'discipline' or 'nature' [A.1].
	module worklib.add_tb:sv
		errors: 0, warnings: 0
	Total errors/warnings found outside modules and primitives:
		errors: 23, warnings: 4
irun: *E,VLGERR: An error occurred during parsing.  Review the log file for errors with the code *E and fix those identified problems to proceed.  Exiting with code (status 1).

