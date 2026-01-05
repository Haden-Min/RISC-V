`timescale 1ns / 1ps

module main_decoder (
    input  wire [6:0] op_i             , // Opcode input
    output reg        reg_write_o      , // Register write enable
    output reg  [2:0] imm_src_o        , // Immediate source select
    output reg        alu_src_o        , // ALU source B select
    output reg        mem_write_o      , // Memory write enable
    output reg  [1:0] result_src_o     , // Register writeback select
    output reg        branch_o         , // Branch instruction flag
    output reg        jump_o           , // Jump instruction flag
    output reg  [1:0] alu_op_o         , // ALU operation hint
    output reg        alu_asrc_o         // ALU source A select (AUIPC)
);

    always @(*) begin
        // Default values
        reg_write_o  = 1'b0  ; imm_src_o    = 3'b000 ; alu_src_o    = 1'b0  ; mem_write_o = 1'b0  ;
        result_src_o = 2'b00 ; branch_o     = 1'b0  ; jump_o       = 1'b0  ; alu_op_o    = 2'b00 ; 
        alu_asrc_o   = 1'b0  ;

        case (op_i)
            7'b0110011: begin // R-type
                reg_write_o  = 1'b1  ; alu_op_o     = 2'b10 ; 
            end
            7'b0010011: begin // I-type ALU
                reg_write_o  = 1'b1  ; imm_src_o    = 3'b000 ; alu_src_o    = 1'b1  ; alu_op_o    = 2'b10 ;
            end
            7'b0000011: begin // Load
                reg_write_o  = 1'b1  ; imm_src_o    = 3'b000 ; alu_src_o    = 1'b1  ; result_src_o = 2'b01 ;
            end
            7'b0100011: begin // Store
                imm_src_o    = 3'b001 ; alu_src_o    = 1'b1  ; mem_write_o  = 1'b1  ;
            end
            7'b1100011: begin // Branch
                imm_src_o    = 3'b010 ; branch_o     = 1'b1  ; alu_op_o     = 2'b01 ;
            end
            7'b1101111: begin // JAL
                reg_write_o  = 1'b1  ; imm_src_o    = 3'b100 ; jump_o       = 1'b1  ; result_src_o = 2'b10 ;
            end
            7'b1100111: begin // JALR
                reg_write_o  = 1'b1  ; imm_src_o    = 3'b000 ; alu_src_o    = 1'b1  ; jump_o       = 1'b1  ; 
                result_src_o = 2'b10 ;
            end
            7'b0110111: begin // LUI
                reg_write_o  = 1'b1  ; imm_src_o    = 3'b011 ; alu_src_o    = 1'b1  ; alu_op_o     = 2'b11 ;
            end
            7'b0010111: begin // AUIPC
                reg_write_o  = 1'b1  ; imm_src_o    = 3'b011 ; alu_src_o    = 1'b1  ; alu_asrc_o   = 1'b1  ;
            end
            default: ; 
        endcase
    end

endmodule