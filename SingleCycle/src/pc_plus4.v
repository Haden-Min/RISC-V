`timescale 1ns / 1ps

module pc_plus4 (
    input  wire [31:0] pc_i            , // Current Program Counter
    output wire [31:0] pc_plus4_o        // Next sequential PC (PC + 4)
);

    // RISC-V instructions are 4 bytes (32-bit) aligned.
    // Sequential next PC is always the current PC plus 4.
    assign pc_plus4_o = pc_i + 32'd4   ;

endmodule