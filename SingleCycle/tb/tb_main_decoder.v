`timescale 1ns / 1ps

module tb_main_decoder();
    // ---------------------------------------------------------
    // 1. Signal Declaration
    // ---------------------------------------------------------
    reg  [6:0] op_r             ; // Stimulus reg for Opcode
    wire       reg_write_w      ; // Output wire for RegWrite
    wire [2:0] imm_src_w        ; // Output wire for ImmSrc
    wire       alu_src_w        ; // Output wire for ALUSrc
    wire       mem_write_w      ; // Output wire for MemWrite
    wire [1:0] result_src_w     ; // Output wire for ResultSrc
    wire       branch_w         ; // Output wire for Branch
    wire       jump_w           ; // Output wire for Jump
    wire [1:0] alu_op_w         ; // Output wire for ALUOp
    wire       alu_asrc_w       ; // Output wire for ALU_ASrc

    // ---------------------------------------------------------
    // 2. DUT Instantiation
    // ---------------------------------------------------------
    main_decoder u_main_decoder (
        .op_i         (op_r         ),
        .reg_write_o  (reg_write_w  ),
        .imm_src_o    (imm_src_w    ),
        .alu_src_o    (alu_src_w    ),
        .mem_write_o  (mem_write_w  ),
        .result_src_o (result_src_w ),
        .branch_o     (branch_w     ),
        .jump_o       (jump_w       ),
        .alu_op_o     (alu_op_w     ),
        .alu_asrc_o   (alu_asrc_w   )
    );

    // ---------------------------------------------------------
    // 3. Test Procedure
    // ---------------------------------------------------------
    initial begin
        $display("------------------------------------------------------------");
        $display("Opcode | RW | ImmS | ASrc | MW | ResS | Br | Jp | ALUOp | AASrc");
        $display("------------------------------------------------------------");

        // R-type
        op_r = 7'b0110011; #10;
        $display("R-type | %b  | %b  | %b    | %b  | %b   | %b  | %b  | %b    | %b", 
                  reg_write_w, imm_src_w, alu_src_w, mem_write_w, result_src_w, branch_w, jump_w, alu_op_w, alu_asrc_w);

        // I-ALU
        op_r = 7'b0010011; #10;
        $display("I-ALU  | %b  | %b  | %b    | %b  | %b   | %b  | %b  | %b    | %b", 
                  reg_write_w, imm_src_w, alu_src_w, mem_write_w, result_src_w, branch_w, jump_w, alu_op_w, alu_asrc_w);

        // Load
        op_r = 7'b0000011; #10;
        $display("Load   | %b  | %b  | %b    | %b  | %b   | %b  | %b  | %b    | %b", 
                  reg_write_w, imm_src_w, alu_src_w, mem_write_w, result_src_w, branch_w, jump_w, alu_op_w, alu_asrc_w);

        // Store
        op_r = 7'b0100011; #10;
        $display("Store  | %b  | %b  | %b    | %b  | %b   | %b  | %b  | %b    | %b", 
                  reg_write_w, imm_src_w, alu_src_w, mem_write_w, result_src_w, branch_w, jump_w, alu_op_w, alu_asrc_w);

        // Branch
        op_r = 7'b1100011; #10;
        $display("Branch | %b  | %b  | %b    | %b  | %b   | %b  | %b  | %b    | %b", 
                  reg_write_w, imm_src_w, alu_src_w, mem_write_w, result_src_w, branch_w, jump_w, alu_op_w, alu_asrc_w);

        // JAL
        op_r = 7'b1101111; #10;
        $display("JAL    | %b  | %b  | %b    | %b  | %b   | %b  | %b  | %b    | %b", 
                  reg_write_w, imm_src_w, alu_src_w, mem_write_w, result_src_w, branch_w, jump_w, alu_op_w, alu_asrc_w);

        // JALR
        op_r = 7'b1100111; #10;
        $display("JALR   | %b  | %b  | %b    | %b  | %b   | %b  | %b  | %b    | %b", 
                  reg_write_w, imm_src_w, alu_src_w, mem_write_w, result_src_w, branch_w, jump_w, alu_op_w, alu_asrc_w);

        // LUI
        op_r = 7'b0110111; #10;
        $display("LUI    | %b  | %b  | %b    | %b  | %b   | %b  | %b  | %b    | %b", 
                  reg_write_w, imm_src_w, alu_src_w, mem_write_w, result_src_w, branch_w, jump_w, alu_op_w, alu_asrc_w);

        // AUIPC
        op_r = 7'b0010111; #10;
        $display("AUIPC  | %b  | %b  | %b    | %b  | %b   | %b  | %b  | %b    | %b", 
                  reg_write_w, imm_src_w, alu_src_w, mem_write_w, result_src_w, branch_w, jump_w, alu_op_w, alu_asrc_w);

        $display("------------------------------------------------------------");
        $finish;
    end

endmodule