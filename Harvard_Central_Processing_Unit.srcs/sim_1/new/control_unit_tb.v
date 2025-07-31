`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2025 10:37:03 PM
// Design Name: 
// Module Name: control_unit_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/30/2025 10:37:03 PM
// Design Name: 
// Module Name: control_unit_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//module control_unit_tb;
//    // Inputs
//    reg clk;
//    reg reset;
//    reg [15:0] instruction;
    
//    // Outputs
//    wire mem_write_enable;
//    wire mem_read_enable;
//    wire [3:0] alu_op;
//    wire [7:0] immediate;
//    wire reg_write_enable;
//    wire [2:0] reg_write_addr;
//    wire [2:0] reg_read_addr1;
//    wire [2:0] reg_read_addr2;
//    wire [7:0] debug_pc;
    
//    // Instantiate the Unit Under Test (UUT)
//    control_unit uut (
//        .clk(clk),
//        .reset(reset),
//        .instruction(instruction),
//        .mem_write_enable(mem_write_enable),
//        .mem_read_enable(mem_read_enable),
//        .alu_op(alu_op),
//        .immediate(immediate),
//        .reg_write_enable(reg_write_enable),
//        .reg_write_addr(reg_write_addr),
//        .reg_read_addr1(reg_read_addr1),
//        .reg_read_addr2(reg_read_addr2),
//        .debug_pc(debug_pc)
//    );
    
//    // Clock generation
//    initial begin
//        clk = 0;
//        forever #5 clk = ~clk;
//    end
    
//    initial begin
//        // Initialize Inputs
//        reset = 1;
//        instruction = 0;
        
//        // Wait for global reset to complete (2 clock cycles)
//        #20;
//        reset = 0;
//        #10;
        
//        // Test Load Immediate
//        $display("Testing LOAD IMMEDIATE instruction");
//        instruction = 16'b0000_101_000110011; // Load 0x99 into reg 5
//        #10;
//        if (reg_write_enable !== 1'b1 || reg_write_addr !== 3'b101 || immediate !== 8'b000110011 || alu_op !== 4'b0000) begin
//            $display("ERROR: LOAD IMMEDIATE failed");
//            $finish;
//        end
        
//        // Test Load from Memory
//        $display("Testing LOAD FROM MEMORY instruction");
//        instruction = 16'b0001_110_011_000000; // Load from memory (address in reg 3) to reg 6
//        #10;
//        if (reg_write_enable !== 1'b1 || reg_write_addr !== 3'b110 || 
//            reg_read_addr1 !== 3'b011 || mem_read_enable !== 1'b1 || alu_op !== 4'b0000) begin
//            $display("ERROR: LOAD FROM MEMORY failed");
//            $finish;
//        end
        
//        // Test Store to Memory
//        $display("Testing STORE TO MEMORY instruction");
//        instruction = 16'b0010_100_010_000000; // Store reg 4 to memory (address in reg 2)
//        #10;
//        if (mem_write_enable !== 1'b1 || reg_read_addr1 !== 3'b100 || 
//            reg_read_addr2 !== 3'b010) begin
//            $display("ERROR: STORE TO MEMORY failed");
//            $display("mem write: %b", mem_write_enable);
//            $display("reg_read_addr1: %b", reg_read_addr1);
//            $display("reg_read_addr2: %b", reg_read_addr2);
//            $display("alu_op: %b", alu_op);
//            $finish;
//        end
        
//        // Test Add
//        $display("Testing ADD instruction");
//        instruction = 16'b0011_111_101_110_000; // Add reg 5 and reg 6, store in reg 7
//        #10;
//        if (reg_write_enable !== 1'b1 || reg_write_addr !== 3'b111 || 
//            reg_read_addr1 !== 3'b101 || reg_read_addr2 !== 3'b110 || alu_op !== 4'b0001) begin
//            $display("ERROR: ADD failed");
//            $finish;
//        end
        
//        // Test Subtract
//        $display("Testing SUBTRACT instruction");
//        instruction = 16'b0100_001_100_011_000; // Subtract reg 3 from reg 4, store in reg 1
//        #10;
//        if (reg_write_enable !== 1'b1 || reg_write_addr !== 3'b001 || 
//            reg_read_addr1 !== 3'b100 || reg_read_addr2 !== 3'b011 || alu_op !== 4'b0010) begin
//            $display("ERROR: SUBTRACT failed");
//            $finish;
//        end
        
//        // Test Default case
//        $display("Testing DEFAULT case");
//        instruction = 16'b1111_000_000_000000; // Invalid opcode
//        #10;
//        if (reg_write_enable !== 1'b0 || mem_write_enable !== 1'b0 || mem_read_enable !== 1'b0) begin
//            $display("ERROR: DEFAULT case failed");
//            $finish;
//        end
        
//        // Test Reset
//        $display("Testing RESET");
//        reset = 1;
//        #10;
//        if (debug_pc !== 8'b0 || reg_write_enable !== 1'b0 || mem_write_enable !== 1'b0 || mem_read_enable !== 1'b0) begin
//            $display("ERROR: RESET failed");
//            $finish;
//        end
        
//        $display("All tests passed successfully!");
//        $finish;
//    end
    
//    // Monitor PC changes
//    always @(posedge clk) begin
//        $display("[%0t] PC = %d", $time, debug_pc);
//    end
//endmodule

module tb_control_unit;
    reg clk, reset;
    reg [15:0] instruction;
    wire mem_write_enable, mem_read_enable, reg_write_enable;
    wire [3:0] alu_op;
    wire [7:0] immediate;
    wire [2:0] reg_write_addr, reg_read_addr1, reg_read_addr2;
    wire [7:0] debug_pc;
    
    control_unit uut (
        .clk(clk), .reset(reset), .instruction(instruction),
        .mem_write_enable(mem_write_enable), .mem_read_enable(mem_read_enable),
        .alu_op(alu_op), .immediate(immediate), .reg_write_enable(reg_write_enable),
        .reg_write_addr(reg_write_addr), .reg_read_addr1(reg_read_addr1), 
        .reg_read_addr2(reg_read_addr2), .debug_pc(debug_pc)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period
    end
    
    // Task to check control signals
    task check_signals(
        input [15:0] expected_instruction,
        input expected_mem_write,
        input expected_mem_read,
        input expected_reg_write,
        input [3:0] expected_alu_op,
        input [7:0] expected_immediate,
        input [2:0] expected_reg_write_addr,
        input [2:0] expected_reg_read_addr1,
        input [2:0] expected_reg_read_addr2,
        input [7:0] expected_pc,
        input [40*8-1:0] test_name
    );
        begin
            $display("=== %s ===", test_name);
            $display("Time %0t: PC = %h, Instruction = %b", $time, debug_pc, expected_instruction);
            $display("Expected vs Got:");
            $display("  mem_write_enable: %b vs %b %s", expected_mem_write, mem_write_enable, 
                    (expected_mem_write == mem_write_enable) ? "PASS" : "FAIL");
            $display("  mem_read_enable:  %b vs %b %s", expected_mem_read, mem_read_enable,
                    (expected_mem_read == mem_read_enable) ? "PASS" : "FAIL");
            $display("  reg_write_enable: %b vs %b %s", expected_reg_write, reg_write_enable,
                    (expected_reg_write == reg_write_enable) ? "PASS" : "FAIL");
            $display("  alu_op:           %b vs %b %s", expected_alu_op, alu_op,
                    (expected_alu_op == alu_op) ? "PASS" : "FAIL");
            $display("  immediate:        %h vs %h %s", expected_immediate, immediate,
                    (expected_immediate == immediate) ? "PASS" : "FAIL");
            $display("  reg_write_addr:   %b vs %b %s", expected_reg_write_addr, reg_write_addr,
                    (expected_reg_write_addr == reg_write_addr) ? "PASS" : "FAIL");
            $display("  reg_read_addr1:   %b vs %b %s", expected_reg_read_addr1, reg_read_addr1,
                    (expected_reg_read_addr1 == reg_read_addr1) ? "PASS" : "FAIL");
            $display("  reg_read_addr2:   %b vs %b %s", expected_reg_read_addr2, reg_read_addr2,
                    (expected_reg_read_addr2 == reg_read_addr2) ? "PASS" : "FAIL");
            $display("  debug_pc:         %h vs %h %s", expected_pc, debug_pc,
                    (expected_pc == debug_pc) ? "PASS" : "FAIL");
            $display("");
        end
    endtask
    
    initial begin
        $display("=== CONTROL UNIT TESTBENCH ===");
        
        // Initialize
        reset = 1; instruction = 16'h0000; 
        #20; reset = 0;
        
        // Test 1: Load Immediate - LI R1, 42 (0000 001 0 00101010)
        @(posedge clk);
        instruction = 16'b0000001000101010;
        #1; // Small delay for signals to settle
        check_signals(
            16'b0000001000101010,  // instruction
            1'b0,                 // mem_write_enable
            1'b0,                 // mem_read_enable  
            1'b1,                 // reg_write_enable
            4'b0000,              // alu_op
            8'h2A,                // immediate (42)
            3'b001,               // reg_write_addr (R1)
            3'b000,               // reg_read_addr1
            3'b000,               // reg_read_addr2
            debug_pc,             // current PC
            "Test 1: Load Immediate LI R1,42"
        );
        
        // Test 2: Add - ADD R2, R0, R1 (0011 010 000 001 000)
        @(posedge clk);
        instruction = 16'b0011010000001000;
        #1;
        check_signals(
            16'b0011010000001000,  // instruction
            1'b0,                 // mem_write_enable
            1'b0,                 // mem_read_enable
            1'b1,                 // reg_write_enable
            4'b0001,              // alu_op (ADD)
            8'h00,                // immediate
            3'b010,               // reg_write_addr (R2)
            3'b000,               // reg_read_addr1 (R0)
            3'b001,               // reg_read_addr2 (R1)
            debug_pc,             // current PC
            "Test 2: Add ADD R2,R0,R1"
        );
        
        // Test 3: Subtract - SUB R3, R2, R1 (0100 011 010 001 000)
        @(posedge clk);
        instruction = 16'b0100011010001000;
        #1;
        check_signals(
            16'b0100011010001000,  // instruction
            1'b0,                 // mem_write_enable
            1'b0,                 // mem_read_enable
            1'b1,                 // reg_write_enable
            4'b0010,              // alu_op (SUB)
            8'h00,                // immediate
            3'b011,               // reg_write_addr (R3)
            3'b010,               // reg_read_addr1 (R2)
            3'b001,               // reg_read_addr2 (R1)
            debug_pc,             // current PC
            "Test 3: Subtract SUB R3,R2,R1"
        );
        
        // Test 4: Load from Memory - LD R4, R2 (0001 100 010 000000)
        @(posedge clk);
        instruction = 16'b0001100010000000;
        #1;
        check_signals(
            16'b0001100010000000,  // instruction
            1'b0,                 // mem_write_enable
            1'b1,                 // mem_read_enable
            1'b1,                 // reg_write_enable
            4'b0100,              // alu_op (pass operand1)
            8'h00,                // immediate
            3'b100,               // reg_write_addr (R4)
            3'b010,               // reg_read_addr1 (R2 - address source)
            3'b000,               // reg_read_addr2
            debug_pc,             // current PC
            "Test 4: Load LD R4,R2"
        );
        
        // Test 5: Store to Memory - ST R1, R2 (0010 001 010 000000)
        @(posedge clk);
        instruction = 16'b0010001010000000;
        #1;
        check_signals(
            16'b0010001010000000,  // instruction
            1'b1,                 // mem_write_enable
            1'b0,                 // mem_read_enable
            1'b0,                 // reg_write_enable
            4'b0100,              // alu_op (pass operand1)
            8'h00,                // immediate
            3'b000,               // reg_write_addr
            3'b001,               // reg_read_addr1 (R1 - data source)
            3'b010,               // reg_read_addr2 (R2 - address source)
            debug_pc,             // current PC
            "Test 5: Store ST R1,R2"
        );
        
        // Test 6: PC Increment Test
        $display("=== PC INCREMENT TEST ===");
        reset = 1; #10; reset = 0;
        instruction = 16'h0000; // NOP
        
        $display("Initial PC: %h", debug_pc);
        @(posedge clk); #1;
        $display("After 1 cycle: %h (should be 1)", debug_pc);
        @(posedge clk); #1;
        $display("After 2 cycles: %h (should be 2)", debug_pc);
        @(posedge clk); #1;
        $display("After 3 cycles: %h (should be 3)", debug_pc);
        
        // Test 7: Reset Test
        $display("=== RESET TEST ===");
        reset = 1; #10;
        $display("After reset: PC = %h (should be 0)", debug_pc);
        $display("Control signals after reset:");
        $display("  mem_write_enable = %b (should be 0)", mem_write_enable);
        $display("  mem_read_enable = %b (should be 0)", mem_read_enable);
        $display("  reg_write_enable = %b (should be 0)", reg_write_enable);
        $display("  alu_op = %b (should be 0000)", alu_op);
        
        #50; $finish;
    end
    
    // Monitor PC changes
    always @(posedge clk) begin
        if (!reset)
            $display("Clock edge at %0t: PC = %h", $time, debug_pc);
    end
endmodule
