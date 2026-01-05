`timescale 1ns / 1ps

module alu (
    input  wire [31:0] src_a_i          , // ALU input source A
    input  wire [31:0] src_b_i          , // ALU input source B
    input  wire [3:0]  alu_op_i         , // ALU control signal (4-bit)
    output reg  [31:0] alu_result_o     , // ALU computation result
    output wire        zero_flag_o        // Zero flag (1 if result is 0)
);

    // ---------------------------------------------------------
    // 1. ALU Operation Logic (Combinational)
    // ---------------------------------------------------------
    always @(*) begin
        case (alu_op_i)
            // Arithmetic Operations
            4'b0000: alu_result_o = src_a_i + src_b_i ;                         // ADD
            4'b0001: alu_result_o = src_a_i - src_b_i ;                         // SUB

            // Logical Operations
            4'b0010: alu_result_o = src_a_i & src_b_i ;                         // AND
            4'b0011: alu_result_o = src_a_i | src_b_i ;                         // OR
            4'b0100: alu_result_o = src_a_i ^ src_b_i ;                         // XOR

            // Shift Operations (Only lower 5 bits of src_b used for shift amount)
            4'b0101: alu_result_o = src_a_i <<  src_b_i[4:0] ;                   // SLL (Shift Left Logical)
            4'b0110: alu_result_o = src_a_i >>  src_b_i[4:0] ;                   // SRL (Shift Right Logical)
            4'b0111: alu_result_o = $signed(src_a_i) >>> src_b_i[4:0] ;          // SRA (Shift Right Arithmetic)

            // Comparison Operations
            4'b1000: begin // SLT (Set Less Than - Signed)
                if ($signed(src_a_i) < $signed(src_b_i)) 
                    alu_result_o = 32'd1 ;
                else                                     
                    alu_result_o = 32'd0 ;
            end

            4'b1001: begin // SLTU (Set Less Than - Unsigned)
                if (src_a_i < src_b_i)                   
                    alu_result_o = 32'd1 ;
                else                                     
                    alu_result_o = 32'd0 ;
            end

            default: alu_result_o = 32'b0 ;
        endcase
    end

    // ---------------------------------------------------------
    // 2. Zero Flag Generation
    // ---------------------------------------------------------
    // Returns 1 if the ALU result is zero, otherwise 0
    assign zero_flag_o = (alu_result_o == 32'b0) ? 1'b1 : 1'b0 ;

endmodule