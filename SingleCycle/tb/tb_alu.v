`timescale 1ns / 1ps

module tb_alu;

    // ========================================================================
    // 1. Signal Declaration
    // ========================================================================
    reg  [31:0] src_a;
    reg  [31:0] src_b;
    reg  [3:0]  alu_op;
    wire [31:0] alu_result;
    wire        zero_flag;

    // Error Counter
    integer err_cnt = 0;

    // ========================================================================
    // 2. Instantiate the DUT (Device Under Test)
    // ========================================================================
    alu u_alu (
        .src_a      (src_a),
        .src_b      (src_b),
        .alu_op     (alu_op),
        .alu_result (alu_result),
        .zero_flag  (zero_flag)
    );

    // ========================================================================
    // 3. Define ALU Operations (Readable Constants)
    // ========================================================================
    localparam OP_ADD  = 4'b0000;
    localparam OP_SUB  = 4'b0001;
    localparam OP_AND  = 4'b0010;
    localparam OP_OR   = 4'b0011;
    localparam OP_XOR  = 4'b0100;
    localparam OP_SLL  = 4'b0101;
    localparam OP_SRL  = 4'b0110;
    localparam OP_SRA  = 4'b0111;
    localparam OP_SLT  = 4'b1000;
    localparam OP_SLTU = 4'b1001;

    // ========================================================================
    // 4. Test Procedure
    // ========================================================================
    initial begin
        $display("==================================================");
        $display("   Starting ALU Verification (Self-Checking)");
        $display("==================================================");

        // ------------------------------------------------------------
        // Test Case 1: Arithmetic (ADD, SUB) & Zero Flag
        // ------------------------------------------------------------
        // 1-1. Simple ADD (10 + 20 = 30)
        run_test(32'd10, 32'd20, OP_ADD, 32'd30, 1'b0, "ADD: 10 + 20");

        // 1-2. SUB to Zero (100 - 100 = 0) -> Zero Flag Check
        run_test(32'd100, 32'd100, OP_SUB, 32'd0, 1'b1, "SUB: 100 - 100 (Zero Check)");

        // 1-3. Negative Result (10 - 20 = -10)
        run_test(32'd10, 32'd20, OP_SUB, -32'd10, 1'b0, "SUB: 10 - 20 (Negative)");


        // ------------------------------------------------------------
        // Test Case 2: Logic (AND, OR, XOR)
        // ------------------------------------------------------------
        // A = 0xAA (10101010), B = 0x55 (01010101)
        run_test(32'hAA, 32'h55, OP_AND, 32'h00, 1'b1, "AND: AA & 55");
        run_test(32'hAA, 32'h55, OP_OR,  32'hFF, 1'b0, "OR : AA | 55");
        run_test(32'hAA, 32'h55, OP_XOR, 32'hFF, 1'b0, "XOR: AA ^ 55");


        // ------------------------------------------------------------
        // Test Case 3: Shift Operations (Boundary Checks)
        // ------------------------------------------------------------
        // 3-1. SLL: 1 << 31 (Should be 0x80000000)
        run_test(32'd1, 32'd31, OP_SLL, 32'h80000000, 1'b0, "SLL: 1 << 31");

        // 3-2. SRL: -1 (All 1s) >> 31 (Should be 1)
        run_test(32'hFFFFFFFF, 32'd31, OP_SRL, 32'd1, 1'b0, "SRL: -1 >> 31");

        // 3-3. SRA: -4 (111...100) >>> 1 (Should be -2, 111...110) - Sign Extension
        run_test(-32'd4, 32'd1, OP_SRA, -32'd2, 1'b0, "SRA: -4 >>> 1");
        
        // 3-4. SRA: -1 (All 1s) >>> 31 (Should still be -1) - Sign Extension Max
        run_test(32'hFFFFFFFF, 32'd31, OP_SRA, 32'hFFFFFFFF, 1'b0, "SRA: -1 >>> 31");


        // ------------------------------------------------------------
        // Test Case 4: Comparison (SLT vs SLTU) - Important!
        // ------------------------------------------------------------
        // Case: -1 (0xFFFFFFFF) vs 1 (0x00000001)
        
        // 4-1. SLT (Signed): -1 < 1 IS TRUE (Result 1)
        run_test(32'hFFFFFFFF, 32'd1, OP_SLT, 32'd1, 1'b0, "SLT: -1 < 1 (Signed)");

        // 4-2. SLTU (Unsigned): 0xFFFFFFFF(Huge number) < 1 IS FALSE (Result 0)
        run_test(32'hFFFFFFFF, 32'd1, OP_SLTU, 32'd0, 1'b1, "SLTU: -1 < 1 (Unsigned)");


        // ========================================================================
        // 5. Final Report
        // ========================================================================
        $display("==================================================");
        if (err_cnt == 0)
            $display("   SUCCESS: All Tests Passed! :)");
        else
            $display("   FAILURE: Found %d Errors :(", err_cnt);
        $display("==================================================");
        
        $finish;
    end

    // ========================================================================
    // Task: Automated Checking
    // ========================================================================
    task run_test;
        input [31:0] i_a;
        input [31:0] i_b;
        input [3:0]  i_op;
        input [31:0] exp_res;
        input        exp_zero;
        input [255:0] test_name; // String for debug
        begin
            // 1. Stimulus Apply
            src_a = i_a;
            src_b = i_b;
            alu_op = i_op;
            
            // 2. Wait for Combinational Logic (Delta delay is enough, but use 10ns for wave)
            #10;

            // 3. Check Results
            if ((alu_result !== exp_res) || (zero_flag !== exp_zero)) begin
                $display("[FAIL] %0s", test_name);
                $display("       Input: A=0x%h, B=0x%h, Op=%b", src_a, src_b, alu_op);
                $display("       Exp  : Res=0x%h, Z=%b", exp_res, exp_zero);
                $display("       Got  : Res=0x%h, Z=%b", alu_result, zero_flag);
                err_cnt = err_cnt + 1;
            end else begin
                $display("[PASS] %0s", test_name);
            end
        end
    endtask

endmodule