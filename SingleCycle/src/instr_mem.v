`timescale 1ns / 1ps

module instr_mem (
    input  wire [31:0] addr_i          , // PC address input
    output wire [31:0] instr_o           // Instruction output
);

    // 16KB Instruction Memory (4096 words x 32-bit)
    reg [31:0] mem_r [0:4095]          ;

    // Load program hex for simulation and implementation
    initial begin
        $readmemh("path/to/program.hex", mem_r);
    end

    // Word addressing: 
    // Since each instruction is 4 bytes, we use bits [13:2] to access 4096 words.
    assign instr_o = mem_r[addr_i[13:2]] ;

endmodule