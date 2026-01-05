`timescale 1ns / 1ps

module register_file (
    input  wire        clk_i           , // Clock input

    // Read Port 1
    input  wire [4:0]  rs1_addr_i      , // Source register 1 address
    output wire [31:0] rs1_data_o      , // Source register 1 data

    // Read Port 2
    input  wire [4:0]  rs2_addr_i      , // Source register 2 address
    output wire [31:0] rs2_data_o      , // Source register 2 data

    // Write Port
    input  wire [4:0]  rd_addr_i       , // Destination register address
    input  wire [31:0] rd_data_i       , // Write data
    input  wire        reg_wen_i         // Write enable
);

    reg [31:0] regs_r [0:31]           ; // 32 registers
    integer    i                       ;

    // Initialization
    initial begin
        for (i = 0; i < 32; i = i + 1)
            regs_r[i] = 32'b0          ;
    end

    // Asynchronous Read (x0 is hardwired to 0)
    assign rs1_data_o = (rs1_addr_i == 5'b0) ? 32'b0 : regs_r[rs1_addr_i] ;
    assign rs2_data_o = (rs2_addr_i == 5'b0) ? 32'b0 : regs_r[rs2_addr_i] ;

    // Synchronous Write (Prevent writing to x0)
    always @(posedge clk_i) begin
        if (reg_wen_i && (rd_addr_i != 5'b0)) begin
            regs_r[rd_addr_i] <= rd_data_i ;
        end
    end

endmodule