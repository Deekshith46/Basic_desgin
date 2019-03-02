module test;
    parameter   WIDTH = 32;
    parameter   OP_LEN = 5;
    reg   [WIDTH -1 :0] a;
    reg   [WIDTH -1 :0] b;
   // reg  cin;
    reg [OP_LEN -1 :0 ] opcode;
    wire [WIDTH-1 :0 ] final_sum;
    wire cout;
    wire negative_flag;
    wire overflow_flag;
    wire zero_flag;


top dut (.a(a),
          .b(b),
          .opcode(opcode),
          .final_sum(final_sum),
          .cout(cout),
          .negative_flag(negative_flag),
          .overflow_flag(overflow_flag),
          .zero_flag(zero_flag));

 initial begin
 $shm_open("new_dpa.shm");
 $shm_probe("ACTMF");
 end

 initial begin
    opcode = 5'b00001; a = 12 ; b = 13;//cin =0;
#20
    opcode = 5'b00010; a = -12 ; b = 1;//cin =0;
#20
    opcode = 5'b00010; a = 12 ; b = -1;//cin=0;
#20
    opcode = 5'b00010; a = -12 ; b = -1;//cin =0;
#200
$finish();
 end

endmodule
