module booth_radix4_multiplier_32 (
    input  signed [31:0] A,   // multiplicand
    input  signed [31:0] B,   // multiplier
    output signed [63:0] P    // final product
);
    reg signed [63:0] partial_products [15:0]; // 16 groups
    reg signed [63:0] result;
    reg [32:0] B_ext;   // extra bit at LSB for grouping
    integer i;

    always @(*) begin
        B_ext = {B, 1'b0};   // extend with LSB=0
        result = 0;

        // Booth Radix-4 recoding loop
        for (i = 0; i < 16; i = i + 1) begin
            case (B_ext[2*i +: 3]) // take 3 bits at a time
                3'b000, 3'b111: partial_products[i] = 64'd0; // 0
                3'b001, 3'b010: partial_products[i] = {{32{A[31]}}, A} << (2*i); // +A
                3'b011:          partial_products[i] = ({{31{A[31]}}, A, 1'b0}) << (2*i); // +2A
                3'b100:          partial_products[i] = -( {{31{A[31]}}, A, 1'b0} << (2*i)); // -2A
                3'b101, 3'b110: partial_products[i] = -( {{32{A[31]}}, A} << (2*i)); // -A
            endcase

            result = result + partial_products[i]; // accumulate
        end
    end

    assign P = result;
endmodule

