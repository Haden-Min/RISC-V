module main_decoder (
    input  wire [6:0] op,
    output reg        reg_write,
    output reg  [2:0] imm_src,
    output reg        alu_src,
    output reg        mem_write,
    output reg  [1:0] result_src, // 2비트로 확장 (00:ALU, 01:Mem, 10:PC+4)
    output reg        branch,
    output reg        jump,
    output reg  [1:0] alu_op,
    output reg        alu_asrc    // AUIPC를 위해 추가 (0:rs1, 1:PC)
);

    always @(*) begin
        // 기본값 설정 (Default)
        reg_write = 0; imm_src = 3'b000; alu_src = 0; mem_write = 0;
        result_src = 2'b00; branch = 0; jump = 0; alu_op = 2'b00; alu_asrc = 0;

        case (op)
            7'b0110011: begin // R-type
                reg_write = 1; alu_op = 2'b10; 
            end
            7'b0010011: begin // I-type ALU
                reg_write = 1; imm_src = 3'b000; alu_src = 1; alu_op = 2'b10;
            end
            7'b0000011: begin // Load
                reg_write = 1; imm_src = 3'b000; alu_src = 1; result_src = 2'b01;
            end
            7'b0100011: begin // Store
                imm_src = 3'b001; alu_src = 1; mem_write = 1;
            end
            7'b1100011: begin // Branch
                imm_src = 3'b010; branch = 1; alu_op = 2'b01;
            end
            7'b1101111: begin // JAL
                reg_write = 1; imm_src = 3'b100; jump = 1; result_src = 2'b10;
            end
            7'b1100111: begin // JALR
                reg_write = 1; imm_src = 3'b000; alu_src = 1; jump = 1; result_src = 2'b10;
            end
            7'b0110111: begin // LUI
                reg_write = 1; imm_src = 3'b011; alu_src = 1; alu_op = 2'b11;
            end
            7'b0010111: begin // AUIPC
                reg_write = 1; imm_src = 3'b011; alu_src = 1; alu_asrc = 1; // PC + Imm
            end
            default: ; 
        endcase
    end
endmodule