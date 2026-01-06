`timescale 1ns / 1ps

module tb_single_cycle_processor();

    // ---------------------------------------------------------
    // Signal Declaration
    // ---------------------------------------------------------
    reg         clk_r                  ;
    reg         rst_nr                 ;

    // ---------------------------------------------------------
    // Clock Generation (100MHz)
    // ---------------------------------------------------------
    always #5 clk_r = ~clk_r           ;

    // ---------------------------------------------------------
    // DUT Instantiation
    // ---------------------------------------------------------
    // 사용자가 만든 최상위 모듈 이름에 맞춰 SingleCycle_Top 또는 single_cycle_processor 사용
    single_cycle_processor u_dut (
        .clk_i  (clk_r                 ),
        .rst_ni (rst_nr                )
    );

    // ---------------------------------------------------------
    // Test Procedure
    // ---------------------------------------------------------
    initial begin
        // Initialize signals
        clk_r  = 0                     ;
        rst_nr = 0                     ; // Assert reset

        // Release reset after 20ns
        #22;
        rst_nr = 1                     ;

        $display("==================================================");
        $display("   Starting Single Cycle Processor Simulation      ");
        $display("==================================================");

        // 시뮬레이션 시간 동안 실행 (예: 200ns)
        #200;

        $display("==================================================");
        $display("   Simulation Finished                            ");
        $display("==================================================");
        $finish;
    end

    // ---------------------------------------------------------
    // Monitor Register values (Debugging)
    // ---------------------------------------------------------
    // 시뮬레이션 중에 특정 레지스터 값이 변할 때마다 출력하여 확인
    initial begin
        $monitor("Time: %0t | PC: %h | Instr: %h | x1: %h | x2: %h | x3: %h | x4: %h",
                 $time, u_dut.pc_w, u_dut.instr_w,
                 u_dut.u_register_file.regs_r[1],
                 u_dut.u_register_file.regs_r[2],
                 u_dut.u_register_file.regs_r[3],
                 u_dut.u_register_file.regs_r[4]);
    end

endmodule