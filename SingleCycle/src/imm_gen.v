`timescale 1ns / 1ps

module imm_gen (
    input  wire [31:0] inst_i          , // Instruction input
    input  wire [2:0]  imm_src_i       , // Control signal to select type
    output reg  [31:0] imm_ext_o         // Sign-extended immediate
);

    always @(*) begin
        case (imm_src_i)
            // I-Type
            3'b000: imm_ext_o = { {20{inst_i[31]}}, inst_i[31:20] } ;
            // S-Type
            3'b001: imm_ext_o = { {20{inst_i[31]}}, inst_i[31:25], inst_i[11:7] } ;
            // B-Type
            3'b010: imm_ext_o = { {19{inst_i[31]}}, inst_i[31], inst_i[7], inst_i[30:25], inst_i[11:8], 1'b0 } ;
            // U-Type
            3'b011: imm_ext_o = { inst_i[31:12], 12'b0 } ;
            // J-Type
            3'b100: imm_ext_o = { {11{inst_i[31]}}, inst_i[31], inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0 } ;
            
            default: imm_ext_o = 32'b0 ;
        endcase
    end

endmodule