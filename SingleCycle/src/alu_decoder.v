`timescale 1ns / 1ps

module alu_decoder(
    input   wire    [1:0]   alu_op_i        ,   // Opcode from Main Decoder
    input   wire    [2:0]   funct3_i        ,   // Instruction funct3
    input   wire            funct7_5_i      ,   // Instruction funct7[5]
    input   wire            op_5_i          ,   // Opcode[5] for I/R checking
    output  reg     [2:0]   alu_control_o       // Control Signal to ALU
    );

    always @(*) begin
        case (alu_op_i)
            // 00: ADD for memory and addr-based instructions
            2'b00: begin
                alu_control_o = 3'b000  ;
            end 
            // 01: SUB for branch comparison
            2'b01: begin
                alu_control_o = 3'b001  ;
            end
            // 10: R and I type ALU Operation
            2'b10: begin
                case (funct3_i)
                    3'b000: begin
                        if (funct7_5_i && op_5_i) begin
                            alu_control_o = 3'b001;
                        end
                        else begin
                            alu_control_o = 3'b000;
                        end
                    end
                    3'b010: begin   // SLT
                        alu_control_o = 3'b101;
                    end
                    3'b110: begin   // OR
                        alu_control_o = 3'b011;
                    end
                    3'b111: begin
                        alu_control_o = 3'b010;
                    end
                    default: begin
                        alu_control_o = 3'b000;
                    end
                endcase
            end
            2'b11: begin    // ADD for LUI
                alu_control_o = 3'b000;
            end
            default: alu_control_o = 3'b000;
        endcase
    end
endmodule
