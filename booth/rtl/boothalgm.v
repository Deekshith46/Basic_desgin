`timescale 1ns / 1ps

module boothalgm(
    input  signed [15:0] multiplicand,
    input  signed [15:0] multiplier,
    output reg [255:0] product
);
    reg signed [31:0] partial_products[0:7];
    integer i;

    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            case ({multiplier[2*i+1], multiplier[2*i], (i == 0 ? 1'b0 : multiplier[2*i-1])})
                3'b000, 3'b111: partial_products[i] = 0;
                3'b001, 3'b010: partial_products[i] = multiplicand;
                3'b011: partial_products[i] = multiplicand << 1;
                3'b100: partial_products[i] = -(multiplicand << 1);
                3'b101, 3'b110: partial_products[i] = -multiplicand;
                default: partial_products[i] = 0;
            endcase
            partial_products[i] = partial_products[i] << (2 * i);
        end

        product = 0;
        for (i = 0; i < 8; i = i + 1)
            product = product | (partial_products[i] << (32 * i));
    end
endmodule
