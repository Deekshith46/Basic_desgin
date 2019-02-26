module tb;
reg [31:0] instruction;
wire [1:0] bc;
wire ct;
wire [4:0] opcode;
wire [4:0] rd;
wire [4:0] rs1;
wire [4:0] rs2;
wire [13:0] immediate;
wire [18:0] jump_immediate;
wire [23:0] system_op;

bit_slicing dut(.instruction(instruction),.bc(bc),.ct(ct),.opcode(opcode),.rd(rd),.rs1(rs1),.rs2(rs2),.immediate(immediate),.jump_immediate(jump_immediate),.system_op(system_op));


initial begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end

initial begin

instruction = 32'b00100011000010001000100000000000;#50;
end

endmodule
