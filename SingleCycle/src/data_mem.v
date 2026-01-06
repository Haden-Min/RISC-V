`timescale 1ns / 1ps

module data_mem (
    input  wire        clk_i           , // Clock input
    input  wire        mem_write_i     , // Write enable from controller
    input  wire [31:0] addr_i          , // ALU result as memory address
    input  wire [31:0] write_data_i    , // Data to be stored (rs2)
    output wire [31:0] read_data_o       // Data loaded from memory
);

    // 16KB Data Memory (4096 words x 32-bit)
    reg [31:0] mem_r [0:4095]          ;

    integer i;

    // Initialize memory to zero
    initial begin
        for (i = 0; i < 4096; i = i + 1) begin
            mem_r[i] = 32'b0           ;
        end
    end

    // Synchronous Write: Occurs at the rising edge of the clock
    always @(posedge clk_i) begin
        if (mem_write_i) begin
            mem_r[addr_i[13:2]] <= write_data_i ;
        end
    end

    // Asynchronous Read: Provides data immediately for single-cycle paths
    assign read_data_o = mem_r[addr_i[13:2]] ;

endmodule