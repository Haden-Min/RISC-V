`timescale 1ns / 1ps

module controller (
    input  wire [6:0] op_i             , // Opcode field
    input  wire [2:0] funct3_i         , // funct3 field
    input  wire       funct7_5_i       , // funct7 bit 5 (inst[30])
    input  wire       zero_flag_i      , // Zero flag from ALU
    output wire [2:0] imm_src_o        , // Immediate generator control
    output wire [2:0] alu_control_o    , // Final ALU control signal
    output wire       alu_src_o        , // ALU source B mux select
    output wire       alu_asrc_o       , // ALU source A mux select (AUIPC)
    output wire       reg_write_o      , // Register file write enable
    output wire       mem_write_o      , // Data memory write enable
    output wire [1:0] result_src_o     , // Writeback source select
    output wire       pc_src_o           // Next PC select logic (Branch/Jump)
);

    // ---------------------------------------------------------
    // Internal Wires
    // ---------------------------------------------------------
    wire [1:0] alu_op_w                ;
    wire       branch_w                ;
    wire       jump_w                  ;

    // ---------------------------------------------------------
    // Main Decoder: Generates basic control signals
    // ---------------------------------------------------------
    main_decoder u_main_decoder (
        .op_i         (op_i           ),
        .reg_write_o  (reg_write_o    ),
        .imm_src_o    (imm_src_o      ),
        .alu_src_o    (alu_src_o      ),
        .mem_write_o  (mem_write_o    ),
        .result_src_o (result_src_o   ),
        .branch_o     (branch_w       ),
        .jump_o       (jump_w         ),
        .alu_op_o     (alu_op_w       ),
        .alu_asrc_o   (alu_asrc_o     )
    );

    // ---------------------------------------------------------
    // ALU Decoder: Generates specific ALU control signals
    // ---------------------------------------------------------
    alu_decoder u_alu_decoder (
        .alu_op_i      (alu_op_w      ),
        .funct3_i      (funct3_i      ),
        .funct7_5_i    (funct7_5_i    ),
        .op_5_i        (op_i[5]       ),
        .alu_control_o (alu_control_o )
    );

    // ---------------------------------------------------------
    // PCSrc Logic: Decide whether to branch or jump
    // ---------------------------------------------------------
    assign pc_src_o = jump_w | (branch_w & zero_flag_i) ;

endmodule