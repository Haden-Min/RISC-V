`timescale 1ns / 1ps

module alu_decoder (
    input  wire       op_5_i           , // Bit 5 of the opcode
    input  wire [2:0] funct3_i         , // funct3 field (inst[14:12])
    input  wire       funct7_5_i       , // Bit 5 of funct7 field (inst[30])
    input  wire [1:0] alu_op_i         , // ALU Opcode from Main Decoder
    output reg  [2:0] alu_control_o      // Final Control Signal for ALU
);

    // ---------------------------------------------------------
    // ALU Control Signal Definition
    // ---------------------------------------------------------
    // 3'b000 : ADD
    // 3'b001 : SUB
    // 3'b010 : AND
    // 3'b011 : OR
    // 3'b101 : SLT (Set Less Than)
    // ---------------------------------------------------------

    always @(*) begin
        case (alu_op_i)
            // -------------------------------------------------
            // 1. Memory Access or Address Calculation
            // -------------------------------------------------
            2'b00: begin
                alu_control_o = 3'b000 ; // ADD
            end

            // -------------------------------------------------
            // 2. Branch Instructions
            // -------------------------------------------------
            2'b01: begin
                alu_control_o = 3'b001 ; // SUB
            end

            // -------------------------------------------------
            // 3. R-type / I-type ALU Instructions
            // -------------------------------------------------
            2'b10: begin
                case (funct3_i)
                    3'b000: begin
                        if (op_5_i && funct7_5_i) 
                            alu_control_o = 3'b001 ; // SUB
                        else                  
                            alu_control_o = 3'b000 ; // ADD
                    end
                    
                    3'b010: alu_control_o = 3'b101 ; // SLT
                    3'b110: alu_control_o = 3'b011 ; // OR
                    3'b111: alu_control_o = 3'b010 ; // AND

                    default: alu_control_o = 3'b000 ; 
                endcase
            end

            // -------------------------------------------------
            // 4. LUI (Load Upper Immediate)
            // -------------------------------------------------
            2'b11: begin
                alu_control_o = 3'b000 ; // ADD
            end

            default: alu_control_o = 3'b000 ;
        endcase
    end

endmodule