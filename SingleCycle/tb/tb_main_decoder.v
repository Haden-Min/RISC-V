`timescale 1ns / 1ps

module tb_main_decoder();
    // 1. 입출력 신호 선언
    reg  [6:0] op;
    wire       reg_write;
    wire [2:0] imm_src;
    wire       alu_src;
    wire       mem_write;
    wire [1:0] result_src;
    wire       branch;
    wire       jump;
    wire [1:0] alu_op;
    wire       alu_asrc;

    // 2. DUT (Device Under Test) 인스턴스화 - 구조적 모델링
    main_decoder uut (
        .op(op),
        .reg_write(reg_write),
        .imm_src(imm_src),
        .alu_src(alu_src),
        .mem_write(mem_write),
        .result_src(result_src),
        .branch(branch),
        .jump(jump),
        .alu_op(alu_op),
        .alu_asrc(alu_asrc)
    );

    // 3. 테스트 시나리오
    initial begin
        $display("------------------------------------------------------------");
        $display("Opcode | RW | ImmS | ASrc | MW | ResS | Br | Jp | ALUOp | AASrc");
        $display("------------------------------------------------------------");

        // R-type 테스트
        op = 7'b0110011; #10;
        $display("R-type | %b  | %b  | %b    | %b  | %b   | %b  | %b  | %b    | %b", 
                  reg_write, imm_src, alu_src, mem_write, result_src, branch, jump, alu_op, alu_asrc);

        // I-type ALU 테스트
        op = 7'b0010011; #10;
        $display("I-ALU  | %b  | %b  | %b    | %b  | %b   | %b  | %b  | %b    | %b", 
                  reg_write, imm_src, alu_src, mem_write, result_src, branch, jump, alu_op, alu_asrc);

        // Load (lw) 테스트
        op = 7'b0000011; #10;
        $display("Load   | %b  | %b  | %b    | %b  | %b   | %b  | %b  | %b    | %b", 
                  reg_write, imm_src, alu_src, mem_write, result_src, branch, jump, alu_op, alu_asrc);

        // Store (sw) 테스트
        op = 7'b0100011; #10;
        $display("Store  | %b  | %b  | %b    | %b  | %b   | %b  | %b  | %b    | %b", 
                  reg_write, imm_src, alu_src, mem_write, result_src, branch, jump, alu_op, alu_asrc);

        // Branch (beq) 테스트
        op = 7'b1100011; #10;
        $display("Branch | %b  | %b  | %b    | %b  | %b   | %b  | %b  | %b    | %b", 
                  reg_write, imm_src, alu_src, mem_write, result_src, branch, jump, alu_op, alu_asrc);

        // JAL 테스트
        op = 7'b1101111; #10;
        $display("JAL    | %b  | %b  | %b    | %b  | %b   | %b  | %b  | %b    | %b", 
                  reg_write, imm_src, alu_src, mem_write, result_src, branch, jump, alu_op, alu_asrc);

        // JALR 테스트
        op = 7'b1100111; #10;
        $display("JALR   | %b  | %b  | %b    | %b  | %b   | %b  | %b  | %b    | %b", 
                  reg_write, imm_src, alu_src, mem_write, result_src, branch, jump, alu_op, alu_asrc);

        // LUI 테스트
        op = 7'b0110111; #10;
        $display("LUI    | %b  | %b  | %b    | %b  | %b   | %b  | %b  | %b    | %b", 
                  reg_write, imm_src, alu_src, mem_write, result_src, branch, jump, alu_op, alu_asrc);

        // AUIPC 테스트
        op = 7'b0010111; #10;
        $display("AUIPC  | %b  | %b  | %b    | %b  | %b   | %b  | %b  | %b    | %b", 
                  reg_write, imm_src, alu_src, mem_write, result_src, branch, jump, alu_op, alu_asrc);

        $display("------------------------------------------------------------");
        $finish;
    end
endmodule