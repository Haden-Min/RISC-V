`timescale 1ns / 1ps

module tb_alu_decoder ();

    // ---------------------------------------------------------
    // 1. Signal Declaration
    // ---------------------------------------------------------
    reg  [1:0] alu_op_r        ; // Stimulus: alu_op
    reg  [2:0] funct3_r        ; // Stimulus: funct3
    reg        funct7_5_r      ; // Stimulus: funct7[5]
    reg        op_5_r          ; // Stimulus: opcode[5]
    wire [2:0] alu_control_w   ; // Output: alu_control

    integer    err_cnt = 0     ; // Error Counter

    // ---------------------------------------------------------
    // 2. DUT Instantiation
    // ---------------------------------------------------------
    alu_decoder u_alu_decoder (
        .alu_op_i      (alu_op_r     ),
        .funct3_i      (funct3_r     ),
        .funct7_5_i    (funct7_5_r   ),
        .op_5_i        (op_5_r       ),
        .alu_control_o (alu_control_w)
    );

    // ---------------------------------------------------------
    // 3. Test Procedure
    // ---------------------------------------------------------
    initial begin
        $display("=========================================================");
        $display("   Starting Comprehensive ALU Decoder Verification");
        $display("=========================================================");

        // --- Case 1: Memory Access / AUIPC (Expect ADD: 000) ---
        check_case(2'b00, 3'b000, 1'b0, 1'b0, 3'b000, "Load/Store/AUIPC");
        check_case(2'b00, 3'b111, 1'b1, 1'b1, 3'b000, "Load/Store Don't Care Check");

        // --- Case 2: Branch (Expect SUB: 001) ---
        check_case(2'b01, 3'b000, 1'b0, 1'b0, 3'b001, "Branch (BEQ/BNE)");
        check_case(2'b01, 3'b010, 1'b1, 1'b1, 3'b001, "Branch Don't Care Check");

        // --- Case 3: ALU Operations (alu_op = 10) ---
        // 3-1. ADD (R-type)
        check_case(2'b10, 3'b000, 1'b0, 1'b1, 3'b000, "R-type ADD");
        // 3-2. SUB (R-type) - Only when OP5=1 and F7_5=1
        check_case(2'b10, 3'b000, 1'b1, 1'b1, 3'b001, "R-type SUB");
        // 3-3. ADDI (I-type) - Even if F7_5 is 1, should be ADD because OP5=0
        check_case(2'b10, 3'b000, 1'b1, 1'b0, 3'b000, "I-type ADDI (F7_5 check)");
        // 3-4. Logical & Comparison
        check_case(2'b10, 3'b010, 1'b0, 1'b1, 3'b101, "SLT (Set Less Than)");
        check_case(2'b10, 3'b110, 1'b0, 1'b1, 3'b011, "OR operation");
        check_case(2'b10, 3'b111, 1'b0, 1'b1, 3'b010, "AND operation");
        // 3-5. Default (Unknown funct3)
        check_case(2'b10, 3'b100, 1'b0, 1'b1, 3'b000, "Default funct3 (XOR/Other)");

        // --- Case 4: LUI (Expect ADD: 000) ---
        check_case(2'b11, 3'b000, 1'b0, 1'b1, 3'b000, "LUI operation");

        // --- Final Report ---
        $display("=========================================================");
        if (err_cnt == 0)
            $display("   SUCCESS: All Decoder Cases Passed!");
        else
            $display("   FAILURE: Found %d mismatches.", err_cnt);
        $display("=========================================================");
        $finish;
    end

    // ---------------------------------------------------------
    // Task: check_case
    // ---------------------------------------------------------
    task check_case;
        input [1:0]  i_alu_op   ;
        input [2:0]  i_f3       ;
        input        i_f7_5     ;
        input        i_op5      ;
        input [2:0]  exp_ctrl   ;
        input [255:0] t_name    ;
        begin
            alu_op_r   = i_alu_op ;
            funct3_r   = i_f3     ;
            funct7_5_r = i_f7_5   ;
            op_5_r     = i_op5    ;
            #10; // Wait for logic

            if (alu_control_w !== exp_ctrl) begin
                $display("[FAIL] %0s | Got:%b Exp:%b", t_name, alu_control_w, exp_ctrl);
                err_cnt = err_cnt + 1;
            end else begin
                $display("[PASS] %0s", t_name);
            end
        end
    endtask

endmodule