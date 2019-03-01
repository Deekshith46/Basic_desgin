module tb_booth_pp_radix4_4bit;

    reg  signed [3:0] A;     // Multiplicand
    reg  [3:0] B;            // Multiplier
    reg  [2:0] y;            // Booth group
    wire signed [5:0] pp;    // Partial product

    integer i;

    // DUT
    booth_pp_radix4_4bit dut (
        .A(A),
        .B(B),
        .y(y),
        .pp(pp)
    );

    initial begin
        $dumpfile("booth_pp_array.vcd");
        $dumpvars(0, tb_booth_pp_radix4_4bit);

        // --- Test case: A = -3, B = 2 ---
        A = -3;       // multiplicand (4’b1101)
        B =  2;       // multiplier   (4’b0010)

        $display("Booth Partial Product Generation for A=%0d, B=%0d", A, B);

        // Generate Booth groups
        // For 4-bit B: we form groups {b[i+1], b[i], b[i-1]} with b[-1]=0
        for (i = 0; i < 4; i = i + 2) begin
            y = {B[i+1], B[i], (i==0)? 1'b0 : B[i-1]};
            #10; // wait 10 time units
            $display("Time=%0t | Booth group=%b | Partial Product=%0d (bin=%b)",
                      $time, y, pp, pp);
        end

        $finish;
    end

endmodule

   

