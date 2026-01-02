`timescale 1ns / 1ps

module register_file(
    input   wire            clk     ,

    // Read Port 1
    input   wire    [4:0]   rs1_addr    ,   // 32bit addr == 5bit
    output  wire    [31:0]  rs1_data    ,

    // Read Port 2
    input   wire    [4:0]   rs2_addr    ,
    output  wire    [31:0]  rs2_data    ,

    // Write Port
    input   wire    [4:0]   rd_addr     ,   // Destination Reg Addr
    input   wire    [31:0]  rd_data     ,
    input   wire            reg_wen         // Write Enable Signal
    );

    reg [31:0]  regs [0:31];

    integer i;

    // 1. Initialization (Simulation & FPGA Power-on)
    // Note: In Xilinx FPGAs, 'initial' blocks are synthesizable for power-on values.
    // We use this method instead of a hardware reset signal to:
    // 1. Allow Vivado to infer efficient Distributed RAM (LUTRAM) instead of Flip-Flops.
    // 2. Avoid 'X' (unknown) propagation during simulation startup.

    initial begin
        for (i = 0; i < 32; i = i + 1)
            regs[i] = 32'b0;
    end

    // 2. Asynchronous Read
    // x0's value is always 0
    assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : regs[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : regs[rs2_addr];

    // 3. Synchronous Write
    // Prevent writing to register x0 (Hardwired to 0)
    always @(posedge clk) begin
        if (reg_wen && (rd_addr != 5'b0)) begin
            regs[rd_addr] <= rd_data;
        end
    end

endmodule
