/////Designer :- Deekshith
/////Design :- 8-bit Ripple carry adder

module fulladder(a,b,cin,sum,carry);
input a,b,cin;
output reg sum , carry;
    always@(*) begin
        sum = a ^ b ^ cin;
        carry = (a&b)|(b&cin)|(a&cin);
    end
endmodule
