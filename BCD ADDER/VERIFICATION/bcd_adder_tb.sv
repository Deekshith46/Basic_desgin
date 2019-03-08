module tb;
reg [3:0] a,b;
reg cin;
wire [3:0] sum;
wire carry;

bcd_adder dut(.a(a),
              .b(b),
              .cin(cin),
              .sum(sum),
              .carry(carry));
initial begin
$shm_open("wave.shm");
$shm_probe("ACTMF");
end

initial begin
    for(int i =0 ; i <10 ; i++) begin
        a = $urandom();
#10;
        b = $urandom();
#10;
        cin = $urandom(); 
#10;
        $display("a = %0d , b = %0d , cin = %0d , sum = %0d , carry = %0d",a,b,cin,sum,carry);

        end
        
end
initial begin
#1000;
$finish();
end
endmodule
