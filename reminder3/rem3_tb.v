module tb;
reg clk;
reg x;
reg rst;
wire out;

rem dut1(.clk(clk),
         .rst(rst),
         .x(x),
         .out(out));

initial begin
    $shm_open("wave.shm");
    $shm_probe("ACTMF");
end

initial  begin
    #1 clk =0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 0;
    x =0;
#10 rst = 1;
#10 x =1;
#10 x =0;
#10 x =0;
#10 x =1;
#10 x =1;
#20 $finish();
end

endmodule
