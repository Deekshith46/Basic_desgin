//Designer:-Deekshith H P
//Design :- Sequence_Detector_0101
module seq_det(clk,rst,x,out);
input clk,rst,x;
output reg out;

parameter a = 2'b00;
parameter b = 2'b01;
parameter c = 2'b10;
parameter d = 2'b11;

reg [1:0] present_state , next_state;

always@(posedge clk or negedge rst) 
begin
    if(rst)begin
        present_state = next_state;
    end
    else begin
        present_state = a;
    end
end

always@(*)
begin
    case(present_state)
        a:begin
            if(x) begin
                next_state = a;
                out = 1'b0;

            end
            else begin
                next_state = b;
                out = 1'b0;

            end
        end
 
        b:begin
            if(x) begin
                next_state = c;
                out = 1'b0;

            end
            else begin
                next_state = b;
                out = 1'b0;

            end
        end

        c:begin
            if(x) begin
                next_state = a;
                out = 1'b0;

            end
            else begin
                next_state =d ;
                out = 1'b0;

            end
        end

        d:begin
            if(x) begin
                next_state = c;
                out = 1'b1;
            end
            else begin
                next_state = b;
                out = 1'b0;
            end
        end
    endcase
end

endmodule
