`timescale 1ns / 1ps

module alu(
    input   wire    [31:0]  src_a       ,
    input   wire    [31:0]  src_b       ,
    input   wire    [3:0]   alu_op      ,
    output  reg     [31:0]  alu_result  ,
    output  wire            zero_flag
    );

    // 1. ALU Operation Logic
    always @(*) begin
        case (alu_op)
            // Arithmetic
            4'b0000: alu_result = src_a + src_b;                    // ADD
            4'b0001: alu_result = src_a - src_b;                    // SUB

            // Logical
            4'b0010: alu_result = src_a & src_b;                    // AND
            4'b0011: alu_result = src_a | src_b;                    // OR
            4'b0100: alu_result = src_a ^ src_b;                    // XOR

            // Shift
            4'b0101: alu_result = src_a << src_b[4:0];              // SLL
            4'b0110: alu_result = src_a >> src_b[4:0];              // SRL
            4'b0111: alu_result = $signed(src_a) >>> src_b[4:0];    // SRA 

            // Comparison
            4'b1000: begin  // SLT
                if ($signed(src_a) < $signed(src_b)) begin
                    alu_result = 32'd1;
                end
                else begin
                    alu_result = 32'd0;
                end
            end
            4'b0000: begin  // SLTU
                if (src_a < src_b) begin
                    alu_result = 32'd1;
                end
                else begin
                    alu_result = 32'd0;
                end
            end
            default: alu_result = 32'b0;
        endcase
    end

    // 2. Zero Flag
    assign zero_flag = (alu_result == 32'b0) ? 1'b1 : 1'b0;
endmodule
