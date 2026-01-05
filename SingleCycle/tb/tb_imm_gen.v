`timescale 1ns / 1ps

module tb_imm_gen();
    // ---------------------------------------------------------
    // Signal Declaration
    // ---------------------------------------------------------
    reg  [31:0] inst_r             ; // Stimulus reg for instruction
    reg  [2:0]  imm_src_r          ; // Stimulus reg for source type
    wire [31:0] imm_ext_w          ; // Output wire for extended immediate

    // ---------------------------------------------------------
    // DUT Instantiation
    // ---------------------------------------------------------
    imm_gen u_imm_gen (
        .inst_i    (inst_r   )     ,
        .imm_src_i (imm_src_r)     ,
        .imm_ext_o (imm_ext_w) 
    );

    // ---------------------------------------------------------
    // Test Procedure
    // ---------------------------------------------------------
    initial begin
        // 1. I-type (addi t0, t1, -1)
        inst_r = 32'hFFF00293; imm_src_r = 3'b000;
        #10;
        $display("I-type: Result = %h (Expected: ffffffff)", imm_ext_w);

        // 2. B-type (beq x0, x0, offset)
        inst_r = 32'h00000463; imm_src_r = 3'b010;
        #10;
        $display("B-type: Result = %h (Expected: 00000008)", imm_ext_w);

        // 3. U-type (lui x5, 0x12345)
        inst_r = 32'h123452B7; imm_src_r = 3'b011;
        #10;
        $display("U-type: Result = %h (Expected: 12345000)", imm_ext_w);

        $finish;
    end

endmodule