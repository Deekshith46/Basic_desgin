/////Designer :- Deekshith
/////Design :- 8-bit Ripple carry adder

module bitripple (a,b,cin,sum,cout);
input [7:0] a,b;
input cin;
output  [7:0] sum;
output  cout;

wire w1,w2,w3,w4,w5,w6,w7;

fulladder  fa1(.a(a[0]),
                .b(b[0]),
                .cin(cin),
                .sum(sum[0]),
                .carry(w1));

fulladder  fa2(.a(a[1]),
                .b(b[1]),
                .cin(w1),
                .sum(sum[1]),
                .carry(w2));

fulladder  fa3(.a(a[2]),
                .b(b[2]),
                .cin(w2),
                .sum(sum[2]),
                .carry(w3));

fulladder  fa4(.a(a[3]),
                .b(b[3]),
                .cin(w3),
                .sum(sum[3]),
                .carry(w4));

fulladder  fa5(.a(a[4]),
                .b(b[4]),
                .cin(w4),
                .sum(sum[4]),
                .carry(w5));

fulladder  fa6(.a(a[5]),
                .b(b[5]),
                .cin(w5),
                .sum(sum[5]),
                .carry(w6));

fulladder  fa7(.a(a[6]),
                .b(b[6]),
                .cin(w6),
                .sum(sum[6]),
                .carry(w7));

fulladder  fa8(.a(a[7]),
                .b(b[7]),
                .cin(w7),
                .sum(sum[7]),
                .carry(cout));
endmodule



