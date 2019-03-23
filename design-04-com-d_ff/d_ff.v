module d_ff(din,clk,rst,dout);
input din,clk,rst;
output reg dout;

always@(posedge clk) begin
    if(rst) begin
        dout <= ~din;
    end
    else begin
        dout <= din;
    end
end
endmodule
