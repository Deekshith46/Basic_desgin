////Desginer:-Deekshith
////Desgin :- BCD_ADDER
module bcd_adder(a,b,cin,sum,carry);
input [3:0] a,b;
input cin;
output  [3:0] sum;
output  carry;

reg [4:0] sum_result, correction;

always@(*) begin
    sum_result = a + b + cin;
    if(sum_result>9)begin
       correction = sum_result + 3'b110;
   end

   else begin
       correction = sum_result;
    end
end
    assign sum = correction[3:0];
    assign carry = correction[4];


endmodule
