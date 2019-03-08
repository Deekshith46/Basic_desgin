/////Designer :- Deekshith
/////Design :- 8-bit Ripple carry adder

module tb;
reg [7:0] a,b;
reg cin;
wire [7:0] sum;
wire cout;

 bitripple dut(.a(a),
                  .b(b),
                  .cin(cin),
                  .sum(sum),
                  .cout(cout));
initial begin
        $display("---------------------------");

    for(int i = 0 ; i<5 ; i++) begin
       // for(int j = 0 ; j<5 ; j++) begin
            a =$urandom();
            b =$urandom();
            cin =$urandom();
#10;
    $display(" a=%0b , b=%0b, cin=%0b, sum=%0b, carry=%0d",a,b,cin,sum,cout);
//end
end
end 

initial begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end
initial begin
#10000;
$finish();
end
endmodule

    
        
