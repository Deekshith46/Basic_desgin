`timescale 1ns/1ps

parameter int WIDTH = 32;

///////////////////////// INTERFACE /////////////////////////
interface adder_if #(parameter int W = WIDTH) ();
  logic [W-1:0] a;
  logic [W-1:0] b;
  logic [4:0]  opcode; // match your OP_LEN = 5
  logic [W-1:0] sum;
  logic cout;
  logic negative_flag;
  logic overflow_flag;
  logic zero_flag;
endinterface

///////////////////////// TRANSACTION ///////////////////////
class transaction;
  rand bit [WIDTH-1:0] a;
  rand bit [WIDTH-1:0] b;
  bit [4:0]            opcode;

  bit [WIDTH-1:0] sum;
  bit             cout;
  bit             negative_flag;
  bit             overflow_flag;
  bit             zero_flag;

  function void display(string name);
    $display("[%0s] A=0x%0h  B=0x%0h  OP=0b%0b | SUM=0x%0h COUT=%0d N=%0d V=%0d Z=%0d",
             name, a, b, opcode, sum, cout, negative_flag, overflow_flag, zero_flag);
  endfunction
endclass

///////////////////////// GENERATOR ////////////////////////
class generator;
  mailbox gen2drv;
  transaction tr;

  function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
    tr = new();
  endfunction

  task run(int num);
    int i;
    for (i=0; i<num; i++) begin
      assert(tr.randomize()) else $error("randomize failed");
      // cycle opcode 00001 (unsigned add), 00010 (signed add), 00011 (sub)
      case (i % 3)
        0: tr.opcode = 5'b00001;
        1: tr.opcode = 5'b00010;
        2: tr.opcode = 5'b00011;
      endcase
      tr.display("GEN");
      gen2drv.put(tr);
    end
  endtask
endclass

///////////////////////// DRIVER //////////////////////////
class driver;
  virtual adder_if vif;
  mailbox gen2drv;
  transaction tr;

  function new(virtual adder_if vif, mailbox gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
    tr = new();
  endfunction

  task run(int num);
    int i;
    for (i=0;i<num;i++) begin
      gen2drv.get(tr);
      // drive inputs (non-blocking to mimic signal assignment)
      vif.a <= tr.a;
      vif.b <= tr.b;
      vif.opcode <= tr.opcode;
      tr.display("DRV");
      #2; // give DUT time to compute (combinational)
    end
  endtask
endclass

///////////////////////// MONITOR /////////////////////////
class monitor;
  virtual adder_if vif;
  mailbox mon2sco;
  transaction tr;

  function new(virtual adder_if vif, mailbox mon2sco);
    this.vif = vif;
    this.mon2sco = mon2sco;
    tr = new();
  endfunction

  task run(int num);
    int i;
    for (i=0;i<num;i++) begin
      #4; // sample after driver & DUT propagation
      tr = new();
      tr.a = vif.a;
      tr.b = vif.b;
      tr.opcode = vif.opcode;
      tr.sum = vif.sum;
      tr.cout = vif.cout;
      tr.negative_flag = vif.negative_flag;
      tr.overflow_flag = vif.overflow_flag;
      tr.zero_flag = vif.zero_flag;
      tr.display("MON");
      mon2sco.put(tr);
    end
  endtask
endclass

//////////////////////// SCOREBOARD ///////////////////////
class scoreboard;
  mailbox mon2sco;
  transaction tr;

  function new(mailbox mon2sco);
    this.mon2sco = mon2sco;
  endfunction

  // helper: compute signed overflow for addition
  function bit signed_add_overflow(bit [WIDTH-1:0] a, bit [WIDTH-1:0] b, bit [WIDTH-1:0] res);
    return (a[WIDTH-1] & b[WIDTH-1] & ~res[WIDTH-1]) | (~a[WIDTH-1] & ~b[WIDTH-1] & res[WIDTH-1]);
  endfunction

  // helper: compute signed overflow for subtraction (a - b)
  function bit signed_sub_overflow(bit [WIDTH-1:0] a, bit [WIDTH-1:0] b, bit [WIDTH-1:0] res);
    return (a[WIDTH-1] & ~b[WIDTH-1] & ~res[WIDTH-1]) | (~a[WIDTH-1] & b[WIDTH-1] & res[WIDTH-1]);
  endfunction

  task run(int num);
    int i;
    for (i=0;i<num;i++) begin
      mon2sco.get(tr);
      tr.display("SCO");

      // Use automatic regs/bits inside task (legal)
      automatic reg [WIDTH:0]   expected_full;
      automatic reg [WIDTH-1:0] expected_sum;
      automatic bit             expected_cout;
      automatic bit             expected_zero;
      automatic bit             expected_negative;
      automatic bit             expected_overflow;

      case (tr.opcode)
        5'b00001: begin // unsigned add
          expected_full = {1'b0, tr.a} + {1'b0, tr.b};
          expected_sum  = expected_full[WIDTH-1:0];
          expected_cout = expected_full[WIDTH];
          expected_zero = (expected_sum == {WIDTH{1'b0}});
          expected_negative = expected_sum[WIDTH-1];
          expected_overflow = signed_add_overflow(tr.a, tr.b, expected_sum);
        end

        5'b00010: begin // signed add (same hardware; overflow is signed)
          expected_full = {1'b0, tr.a} + {1'b0, tr.b};
          expected_sum  = expected_full[WIDTH-1:0];
          expected_cout = expected_full[WIDTH];
          expected_zero = (expected_sum == {WIDTH{1'b0}});
          expected_negative = expected_sum[WIDTH-1];
          expected_overflow = signed_add_overflow(tr.a, tr.b, expected_sum);
        end

        5'b00011: begin // subtract: a - b (a + (~b) + 1)
          expected_full = {1'b0, tr.a} + {1'b0, ~tr.b} + 1'b1;
          expected_sum  = expected_full[WIDTH-1:0];
          expected_cout = expected_full[WIDTH];
          expected_zero = (expected_sum == {WIDTH{1'b0}});
          expected_negative = expected_sum[WIDTH-1];
          expected_overflow = signed_sub_overflow(tr.a, tr.b, expected_sum);
        end

        default: begin
          expected_full = '0;
          expected_sum  = '0;
          expected_cout = 1'b0;
          expected_zero = 1'b1;
          expected_negative = 1'b0;
          expected_overflow = 1'b0;
        end
      endcase

      // Compare DUT vs expected
      if ( (tr.sum === expected_sum) &&
           (tr.cout === expected_cout) &&
           (tr.zero_flag === expected_zero) &&
           (tr.negative_flag === expected_negative) &&
           (tr.overflow_flag === expected_overflow) ) begin
        $display("    >>> OK: result matches expected");
      end else begin
        $display("    >>> ERROR: mismatch!");
        $display("    Expected SUM=0x%0h COUT=%0d N=%0d V=%0d Z=%0d",
                 expected_sum, expected_cout, expected_negative, expected_overflow, expected_zero);
      end

      $display("-------------------------------------------------------------");
    end
  endtask
endclass

///////////////////////// ENVIRONMENT ///////////////////////
class environment;
  mailbox m1, m2;
  generator gen;
  driver drv;
  monitor mon;
  scoreboard sco;
  virtual adder_if vif;

  function new(virtual adder_if vif);
    this.vif = vif;
    m1 = new();
    m2 = new();
    gen = new(m1);
    drv = new(vif, m1);
    mon = new(vif, m2);
    sco = new(m2);
  endfunction

  task run(int num);
    fork
      gen.run(num);
      drv.run(num);
      mon.run(num);
      sco.run(num);
    join
  endtask
endclass

///////////////////////// PROGRAM //////////////////////////
program test(adder_if i_intf);
  environment env;
  initial begin
    int count = 30; // total transactions (will cycle opcodes)
    env = new(i_intf);
    env.run(count);
    $finish();
  end
endprogram

///////////////////////// TOP-LEVEL TB //////////////////////
module tb_top;
  adder_if #(WIDTH) i_intf();
  test t1(i_intf);

  // instantiate your DUT (top). Map outputs to interface signals
  top #(.WIDTH(WIDTH)) dut (
    .a(i_intf.a),
    .b(i_intf.b),
    .opcode(i_intf.opcode),
    .final_sum(i_intf.sum),
    .cout(i_intf.cout),
    .negative_flag(i_intf.negative_flag),
    .overflow_flag(i_intf.overflow_flag),
    .zero_flag(i_intf.zero_flag)
  );

  initial begin
    $shm_open("wave.shm");
    $shm_probe("ACTMF");
  end
endmodule
