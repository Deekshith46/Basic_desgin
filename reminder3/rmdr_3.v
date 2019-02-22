module rmdr(clk,rst,in,out);

parameter R0=2'b00,R1=2'b01,R2=2'b10;

input clk,rst,in;
output out;

reg [1:0] ps,ns;

assign out = (ps == R0);

always@(posedge clk)
begin

    if(rst)
        ps <= R0;

    else
        ps<= ns;

end

always@(ps or in)
begin

    case(ps)

        R0:  ns = in ? R1 : R0;

        R1:  ns = in ? R0 : R2;

        R2:  ns = in ? R2 : R1;

        default: ns = R0;

    endcase

end

endmodule

