
module rem_tb;
reg clk;
reg rst;
reg x;
wire out;

rem5 dut1(.clk(clk),
          .rst(rst),
          .x(x),
          .out(out));

initial begin
    $shm_open("wave.shm");
    $shm_probe("ACMTF");
end

always begin
    clk = 0;
    forever #5 clk= ~clk;
end

initial begin
    rst = 1'b0;
    x = 1'b0;
#10
rst = 1'b1;#10
x = 1'b1; #10
x = 1'b0; #10
x = 1'b1; #10
x = 1'b1; #20
$finish();
end
endmodule

