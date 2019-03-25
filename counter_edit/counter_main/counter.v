
module counter(input clk,mod,rst, output reg[2:0] count);

    always@(posedge clk )
        begin
            if(rst)begin
            count = 3'b000;
        end
        else begin
            if(mod)begin
            count = (count+1)%8;
        end

        else begin
            count = (count+8-1)%8; 
    end
        end
    end
endmodule

