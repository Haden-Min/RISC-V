`timescale 1ns / 1ps

module single_cycle_processor (
    input  wire        clk_i           ,
    input  wire        rst_ni            // Active-low reset
);

    // ---------------------------------------------------------
    // Internal Wires (Interconnects)
    // ---------------------------------------------------------
    // IF Stage
    wire [31:0] pc_w                   ;
    wire [31:0] pc_next_w              ;
    wire [31:0] pc_plus4_w             ;
    wire [31:0] pc_target_w            ;
    wire [31:0] instr_w                ;

    // ID Stage
    wire [31:0] rd_data1_w             ;
    wire [31:0] rd_data2_w             ;
    wire [31:0] imm_ext_w              ;

    // EX Stage
    wire [31:0] src_a_w                ;
    wire [31:0] src_b_w                ;
    wire [31:0] alu_result_w           ;
    wire        zero_flag_w            ;

    // MEM Stage
    wire [31:0] read_data_w            ;

    // WB Stage
    wire [31:0] result_w               ;

    // Control Signals
    wire [2:0]  imm_src_w              ;
    wire [2:0]  alu_control_w          ;
    wire        alu_src_w              ;
    wire        alu_asrc_w             ;
    wire        reg_write_w            ;
    wire        mem_write_w            ;
    wire [1:0]  result_src_w           ;
    wire        pc_src_w               ;

    // ---------------------------------------------------------
    // 1. IF Stage: Instruction Fetch
    // ---------------------------------------------------------
    pc_reg u_pc_reg (
        .clk_i       (clk_i          ),
        .rst_ni      (rst_ni         ),
        .pc_next_i   (pc_next_w      ),
        .pc_o        (pc_w           )
    );

    instr_mem u_instr_mem (
        .addr_i      (pc_w           ),
        .instr_o     (instr_w        )
    );

    pc_plus4 u_pc_plus4 (
        .pc_i        (pc_w           ),
        .pc_plus4_o  (pc_plus4_w     )
    );

    // PC Source Mux
    assign pc_next_w = (pc_src_w) ? pc_target_w : pc_plus4_w ;

    // ---------------------------------------------------------
    // 2. ID Stage: Instruction Decode & RegFile Read
    // ---------------------------------------------------------
    controller u_controller (
        .op_i         (instr_w[6:0]   ),
        .funct3_i     (instr_w[14:12] ),
        .funct7_5_i   (instr_w[30]    ),
        .zero_flag_i  (zero_flag_w    ),
        .imm_src_o    (imm_src_w      ),
        .alu_control_o(alu_control_w  ),
        .alu_src_o    (alu_src_w      ),
        .alu_asrc_o   (alu_asrc_w     ),
        .reg_write_o  (reg_write_w    ),
        .mem_write_o  (mem_write_w    ),
        .result_src_o (result_src_w   ),
        .pc_src_o     (pc_src_w       )
    );

    register_file u_register_file (
        .clk_i        (clk_i          ),
        .rs1_addr_i   (instr_w[19:15] ),
        .rs2_addr_i   (instr_w[24:20] ),
        .rd_addr_i    (instr_w[11:7]  ),
        .rd_data_i    (result_w       ),
        .reg_wen_i    (reg_write_w    ),
        .rs1_data_o   (rd_data1_w     ),
        .rs2_data_o   (rd_data2_w     )
    );

    imm_gen u_imm_gen (
        .inst_i       (instr_w        ),
        .imm_src_i    (imm_src_w      ),
        .imm_ext_o    (imm_ext_w      )
    );

    // ---------------------------------------------------------
    // 3. EX Stage: Execution & Address Calculation
    // ---------------------------------------------------------
    // ALU Source A Mux (For AUIPC)
    assign src_a_w = (alu_asrc_w) ? pc_w : rd_data1_w ;

    // ALU Source B Mux
    assign src_b_w = (alu_src_w) ? imm_ext_w : rd_data2_w ;

    alu u_alu (
        .src_a_i      (src_a_w        ),
        .src_b_i      (src_b_w        ),
        .alu_op_i     ({1'b0, alu_control_w}), // 4-bit input
        .alu_result_o (alu_result_w   ),
        .zero_flag_o  (zero_flag_w    )
    );

    // Branch/Jump Target Adder
    assign pc_target_w = pc_w + imm_ext_w ;

    // ---------------------------------------------------------
    // 4. MEM Stage: Data Memory Access
    // ---------------------------------------------------------
    data_mem u_data_mem (
        .clk_i        (clk_i          ),
        .mem_write_i  (mem_write_w    ),
        .addr_i       (alu_result_w   ),
        .write_data_i (rd_data2_w     ),
        .read_data_o  (read_data_w    )
    );

    // ---------------------------------------------------------
    // 5. WB Stage: Write Back to Register File
    // ---------------------------------------------------------
    // Result Source Mux
    assign result_w = (result_src_w == 2'b00) ? alu_result_w :
                      (result_src_w == 2'b01) ? read_data_w  :
                      (result_src_w == 2'b10) ? pc_plus4_w   : alu_result_w ;

endmodule