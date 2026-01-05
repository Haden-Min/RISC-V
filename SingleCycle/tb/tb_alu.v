`timescale 1ns / 1ps

module tb_alu;

    // ========================================================================
    // 1. Signal Declaration
    // ========================================================================
    reg  [31:0] src_a_r      ; // Stimulus reg A
    reg  [31:0] src_b_r      ; // Stimulus reg B
    reg  [3:0]  alu_op_r     ; // Stimulus reg Op
    wire [31:0] alu_result_w ; // Output wire Result
    wire        zero_flag_w  ; // Output wire Zero

    integer     err_cnt = 0  ; // Error Counter

    // ========================================================================
    // 2. Instantiate the DUT
    // ========================================================================
    alu u_alu (
        .src_a_i      (src_a_r     ),
        .src_b_i      (src_b_r     ),
        .alu_op_i     (alu_op_r    ),
        .alu_result_o (alu_result_w),
        .zero_flag_o  (zero_flag_w )
    );

    // ========================================================================
    // 3. ALU Operation Constants
    // ========================================================================
    localparam OP_ADD  = 4'b0000 ;
    localparam OP_SUB  = 4'b0001 ;
    localparam OP_AND  = 4'b0010 ;
    localparam OP_OR   = 4'b0011 ;
    localparam OP_XOR  = 4'b0100 ;
    localparam OP_SLL  = 4'b0101 ;
    localparam OP_SRL  = 4'b0110 ;
    localparam OP_SRA  = 4'b0111 ;
    localparam OP_SLT  = 4'b1000 ;
    localparam OP_SLTU = 4'b1001 ;

    // ========================================================================
    // 4. Test Procedure
    // ========================================================================
    initial begin
        $display("==================================================");
        $display("   Starting ALU Verification (Self-Checking)");
        $display("==================================================");

        // TC 1: Arithmetic
        run_test(32'd10,  32'd20,  OP_ADD, 32'd30,      1'b0, "ADD: 10 + 20");
        run_test(32'd100, 32'd100, OP_SUB, 32'd0,       1'b1, "SUB: 100 - 100 (Zero)");
        run_test(32'd10,  32'd20,  OP_SUB, -32'd10,     1'b0, "SUB: 10 - 20 (Neg)");

        // TC 2: Logic
        run_test(32'hAA, 32'h55, OP_AND, 32'h00, 1'b1, "AND: AA & 55");
        run_test(32'hAA, 32'h55, OP_OR,  32'hFF, 1'b0, "OR : AA | 55");
        run_test(32'hAA, 32'h55, OP_XOR, 32'hFF, 1'b0, "XOR: AA ^ 55");

        // TC 3: Shift
        run_test(32'd1,        32'd31, OP_SLL, 32'h80000000, 1'b0, "SLL: 1 << 31");
        run_test(32'hFFFFFFFF, 32'd31, OP_SRL, 32'd1,        1'b0, "SRL: -1 >> 31");
        run_test(-32'd4,       32'd1,  OP_SRA, -32'd2,       1'b0, "SRA: -4 >>> 1");
        run_test(32'hFFFFFFFF, 32'd31, OP_SRA, 32'hFFFFFFFF, 1'b0, "SRA: -1 >>> 31");

        // TC 4: Comparison
        run_test(32'hFFFFFFFF, 32'd1, OP_SLT,  32'd1, 1'b0, "SLT : -1 < 1 (Signed)");
        run_test(32'hFFFFFFFF, 32'd1, OP_SLTU, 32'd0, 1'b1, "SLTU: -1 < 1 (Unsigned)");

        // Final Report
        $display("==================================================");
        if (err_cnt == 0) $display("   SUCCESS: All Tests Passed! :)");
        else              $display("   FAILURE: Found %d Errors :(", err_cnt);
        $display("==================================================");
        
        $finish;
    end

    // ========================================================================
    // Task: Automated Checking
    // ========================================================================
    task run_test;
        input [31:0]  i_a       ;
        input [31:0]  i_b       ;
        input [3:0]   i_op      ;
        input [31:0]  exp_res   ;
        input         exp_zero  ;
        input [255:0] test_name ;
        begin
            src_a_r  = i_a  ;
            src_b_r  = i_b  ;
            alu_op_r = i_op ;
            
            #10; // Wait for logic

            if ((alu_result_w !== exp_res) || (zero_flag_w !== exp_zero)) begin
                $display("[FAIL] %0s", test_name);
                $display("       Got: Res=0x%h, Z=%b", alu_result_w, zero_flag_w);
                err_cnt = err_cnt + 1;
            end else begin
                $display("[PASS] %0s", test_name);
            end
        end
    endtask

endmodule