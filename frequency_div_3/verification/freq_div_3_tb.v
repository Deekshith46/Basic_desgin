module tb;
reg clk;
reg rst;
wire clk_out;

freq_3 dut(.clk(clk),.rst(rst),.clk_out(clk_out));

initial begin
    $shm_open("wave.shm");
    $shm_probe("ACTMF");
end

always begin
    clk =0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 1'b1;
#30;
rst = 1'b0;
#200;
$finish();
end
endmodule
