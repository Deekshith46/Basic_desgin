module freq_3(clk,rst,clk_out);
input clk,rst;
output clk_out;

reg [1:0] pos_edge;
reg [1:0] neg_edge;

always@(posedge clk)begin
    if(rst)begin
        pos_edge =1'b0;
    end
    else if(pos_edge == 2)begin
        pos_edge = 1'b0;
    end
    else begin
        pos_edge = pos_edge +1;
    end
end

always@(posedge clk)begin
    if(rst)begin
       neg_edge =1'b0;
    end
    else if(neg_edge == 2)begin
        neg_edge = 1'b0;
    end
    else begin
        neg_edge = neg_edge +1;
    end
end
assign clk_out = (pos_edge==2) | (neg_edge==2);
endmodule
