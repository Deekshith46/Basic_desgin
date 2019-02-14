`timescale 1ns / 1ps

module booth_wallace_cla(
    input  signed [15:0] multiplicand,
    input  signed [15:0] multiplier,
    output signed [31:0] product
);
    wire [255:0] partial_products;
    wire [31:0] sum, carry;
    wire carryout;

    boothalgm booth_inst (
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(partial_products)
    );

    wallactreeee wallace_inst (
        .pp(partial_products[127:0]), // Use the lower 128 bits
        .sumlast1(sum),
        .sumlast2(carry)
    );

    fastadderrr cla_inst (
        .A(sum),
        .B(carry),
        .Cin(1'b0),
        .Sum(product),
        .Cout(carryout)
    );
endmodule
