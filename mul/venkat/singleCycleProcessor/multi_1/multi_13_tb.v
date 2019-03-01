module tb_booth_radix4_32;
    reg  [31:0] A, B;
    wire [63:0] P;
    wire [63:0] partial_products [0:16];

    booth_radix4_multiplier_32 uut (.A(A), .B(B), .partial_products(partial_products), .P(P));

    initial begin
        $shm_open("wave.shm");
        $shm_probe("ACTMF");
    end
    integer i;

    initial begin
        $monitor("Time=%0t A=%d B=%d => Product=%d", $time, A, B, P);
	for (i=0; i < 17 ; i = i+1) begin
		$monitor("PP[%d] = %h", i, partial_products[i]);
	end

        // Example 1:  15 * 3 = 45
        A = 15; B = 3; #10;

        // Example 2:  -25 * 12 = -300
        A = -25; B = 12; #10;

        // Example 3:  12345 * -6789
        A = 12345; B = -6789; #10;

        // Example 4:  -1024 * -2048
        A = -1024; B = -2048; #10;

        $finish;
    end
endmodule
