`timescale 1ns / 1ps

module tb_imm_gen();
    reg  [31:0] inst;
    reg  [2:0]  imm_src;
    wire [31:0] imm_ext;

    // ImmGen 모듈 인스턴스화 (DUT: Device Under Test)
    imm_gen uut (
        .inst(inst),
        .imm_src(imm_src),
        .imm_ext(imm_ext)
    );

    initial begin
        // 1. I-type 테스트 (addi t0, t1, -1)
        // 명령어: 111111111111_00000_000_00101_0010011 (0xFFF00293)
        inst = 32'hFFF00293; imm_src = 3'b000;
        #10;
        $display("I-type: Result = %h (Expected: ffffffff)", imm_ext);

        // 2. B-type 테스트 (beq x0, x0, offset)
        // 명령어의 비트들을 섞어서 offset 4(실제로는 8)를 표현
        inst = 32'h00000463; imm_src = 3'b010;
        #10;
        $display("B-type: Result = %h (Expected: 00000008)", imm_ext);

        // 3. U-type 테스트 (lui x5, 0x12345)
        inst = 32'h123452B7; imm_src = 3'b011;
        #10;
        $display("U-type: Result = %h (Expected: 12345000)", imm_ext);

        $finish;
    end
endmodule