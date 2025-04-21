`timescale 1ns / 1ps

module booth_wallace_cla_tb;

    reg signed [15:0] multiplicand, multiplier;
    wire signed [31:0] product;

    // Instantiate the combined module
    booth_wallace_cla uut (
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product)
    );

    initial begin
        // Test Case 1: Small positive numbers
        multiplicand = 16'h0003; multiplier = 16'h0002;
        #10;

        // Test Case 2: Small negative numbers
        multiplicand = -16'h0003; multiplier = -16'h0002;
        #10;

        // Test Case 3: Mixed sign numbers
        multiplicand = -16'h0003; multiplier = 16'h0002;
        #10;

        // Test Case 4: Large positive numbers
        multiplicand = 16'h7FFF; multiplier = 16'h7FFF;
        #10;

        // Test Case 5: Large negative numbers
        multiplicand = -16'h8000; multiplier = -16'h8000;
        #10;

        $finish;
    end

endmodule
