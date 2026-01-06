`timescale 1ns / 1ps

module pc_reg (
    input  wire        clk_i           , // Clock input
    input  wire        rst_ni          , // Asynchronous reset (Active low)
    input  wire [31:0] pc_next_i       , // Next PC address input
    output reg  [31:0] pc_o              // Current PC address output
);

    always @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            pc_o <= 32'b0              ; // Reset PC to 0
        end
        else begin
            pc_o <= pc_next_i          ; // Update PC at clock edge
        end
    end

endmodule