
module rem(clk,rst,x,out);
input clk,rst,x;
output reg  out;

parameter a= 2'b00;
parameter b = 2'b01;
parameter c = 2'b10;

reg[1:0] present_state, next_state;

//assign out =( present_state == a);

always@(posedge clk ) begin
    if(rst==0)
    begin
        present_state<=  a;
    end
    else begin
        present_state <=  next_state;
    end
end


//always@(present_state or x) 
always@(*)
begin

    case(present_state)
        a:begin
            if(x==0)begin
                next_state =  a;
               out = 1'b1;
            end
            else begin
                next_state = b;
                out =1'b0;
            end
        end

        b:begin
            if(x==0)begin
                next_state =  c;
               out =1'b0;

            end
            else begin
                next_state = a;
                out =1'b1;

            end
        end

        c:begin
            if(x==0)begin
                next_state =  b;
                out =1'b0;

            end
            else begin
                next_state =  c;
                out =1'b0;

            end
        end
        default : next_state = a;
    endcase
end

/*always@(*) begin
    case(present_state)
        a: begin
            if(x==0)begin
                out = 1'b1;
            end
            else begin
                out = 1'b0;
            end
        end
        b: begin
            if(x==0)begin
                out = 1'b0;
            end
            else begin
                out = 1'b1;
            end
        end
        c: out = 1'b0;
    endcase
end*/

endmodule
