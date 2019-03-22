
`include "interface.sv"
`include "random_test.sv"

module tb_top;
bit clk;

bit rst;

always #5 clk= ~clk'

initial begin
rst = 1;
#5 rst =0;
end

intf i_intf(clk,rst);
test t1(i_intf);

counter dut(.clk(i_intf.clk),
            .mod(i_intf.mod),
            .rst(i_intf.mod),
            .count(i_intf.counter));

initial begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end
endmodule
