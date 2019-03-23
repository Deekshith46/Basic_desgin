`timescale 1ns/1ps

module async_fifo #(
    parameter DATA_WIDTH = 8,  // Width of the data
    parameter DEPTH = 16        // Depth of the FIFO (must be a power of 2)
) (
    input wr_clk,               // Write clock
    input rd_clk,               // Read clock
    input rst,                  // Reset signal
    input wr_en,                // Write enable
    input rd_en,                // Read enable
    input [DATA_WIDTH-1:0] din, // Data input
    output reg [DATA_WIDTH-1:0] dout, // Data output
    output reg full,            // FIFO full flag
    output reg empty,           // FIFO empty flag
    output reg overflow,        // FIFO overflow flag
    output reg underflow        // FIFO underflow flag
);

    // Memory array to store FIFO data
    reg [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];

    reg underflow_r ;

    // Write and read pointers
    reg [4:0] wr_ptr;  // 5-bit pointer for write
    reg [4:0] rd_ptr;  // 5-bit pointer for read

    // FIFO count to track number of elements
    reg [4:0] count;   // Needs 5 bits for depth of 16

    // Write process
    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            count <= 0;
            full <= 0;
        end else if (wr_en && !full) begin
            fifo_mem[wr_ptr] <= din;           // Write data
            wr_ptr <= (wr_ptr + 1) % DEPTH;    // Increment pointer with wraparound
            count <= count + 1;                // Increment count
        end
        full <= (count == DEPTH);              // Update full flag
    end

    // Overflow detection
    always @(posedge wr_clk or posedge rst) begin
        if (rst) begin
            overflow <= 0;
        end else if (wr_en && full) begin      // Overflow when writing to full FIFO
            overflow <= 1;
        end else begin
            overflow <= 0;                     // Clear overflow when not writing to full
        end
    end

    // Read process
    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            rd_ptr <= 0;
            dout <= 0;
            empty <= 1;
        end else if (rd_en && !empty) begin
            dout <= fifo_mem[rd_ptr];          // Read data
            rd_ptr <= (rd_ptr + 1) % DEPTH;    // Increment pointer with wraparound
            count <= count - 1;                // Decrement count
        end
        empty <= (count == 0);                 // Update empty flag
    end

    // Underflow detection
    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            underflow_r <= 0;
        end else if (rd_en && empty) begin     // Underflow when reading from empty FIFO
            underflow_r <= 1;
        end else begin
            underflow_r <= 0;                    // Clear underflow when not reading empty
        end
    end

    always @(posedge rd_clk or posedge rst) begin
        if (rst) begin
            underflow <= 0;
        end else
        begin
        underflow <= underflow_r    ;
        end
    end    
        
    

endmodule



