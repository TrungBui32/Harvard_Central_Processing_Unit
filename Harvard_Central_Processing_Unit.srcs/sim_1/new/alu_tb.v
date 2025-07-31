`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2024 10:13:15 PM
// Design Name: 
// Module Name: alu_tb
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


//module alu_tb;

//    // Inputs
//    reg clk;
//    reg reset;
//    reg [3:0] alu_op;
//    reg [7:0] operand1;
//    reg [7:0] operand2;
//    reg [7:0] immediate;

//    // Outputs
//    wire [7:0] result;
//    wire [7:0] debug_accumulator;

//    // Instantiate the Unit Under Test (UUT)
//    alu uut (
//        .clk(clk),
//        .reset(reset),
//        .alu_op(alu_op),
//        .operand1(operand1),
//        .operand2(operand2),
//        .immediate(immediate),
//        .result(result),
//        .debug_accumulator(debug_accumulator)
//    );

//    // Clock generation
//    always begin
//        #5 clk = ~clk;
//    end

//    initial begin
//        // Initialize Inputs
//        clk = 0;
//        reset = 0;
//        alu_op = 0;
//        operand1 = 0;
//        operand2 = 0;
//        immediate = 0;

//        // Wait for global reset
//        #10;
        
//        // Test 1: Reset test
//        $display("Test 1: Reset test");
//        reset = 1;
//        #10;
//        if (result !== 8'b0 || debug_accumulator !== 8'b0) begin
//            $display("Error: Reset failed");
//            $display("Result: %h, Debug: %h", result, debug_accumulator);
//            $finish;
//        end
//        reset = 0;
//        #10;
//        $display("Test 1 passed: Reset works correctly");
        
//        // Test 2: Load immediate
//        $display("\nTest 2: Load immediate");
//        alu_op = 4'b0000;
//        immediate = 8'hAA;
//        #10;
//        if (result !== 8'hAA) begin
//            $display("Error: Load immediate failed");
//            $display("Expected: AA, Got: %h", result);
//            $finish;
//        end
//        $display("Test 2 passed: Load immediate works");
        
//        // Test 3: Addition
//        $display("\nTest 3: Addition");
//        alu_op = 4'b0001;
//        operand1 = 8'h12;
//        operand2 = 8'h34;
//        #10;
//        if (result !== 8'h46) begin
//            $display("Error: Addition failed");
//            $display("Expected: 46, Got: %h", result);
//            $finish;
//        end
//        $display("Test 3 passed: Addition works");
        
//        // Test 4: Subtraction
//        $display("\nTest 4: Subtraction");
//        alu_op = 4'b0010;
//        operand1 = 8'h55;
//        operand2 = 8'h33;
//        #10;
//        if (result !== 8'h22) begin
//            $display("Error: Subtraction failed");
//            $display("Expected: 22, Got: %h", result);
//            $finish;
//        end
//        $display("Test 4 passed: Subtraction works");
        
//        // Test 5: AND operation
//        $display("\nTest 5: AND operation");
//        alu_op = 4'b0011;
//        operand1 = 8'b10101010;
//        operand2 = 8'b11001100;
//        #10;
//        if (result !== 8'b10001000) begin
//            $display("Error: AND operation failed");
//            $display("Expected: 88, Got: %h", result);
//            $finish;
//        end
//        $display("Test 5 passed: AND operation works");
        
//        // Test 6: Pass operand1
//        $display("\nTest 6: Pass operand1");
//        alu_op = 4'b0100;
//        operand1 = 8'hDE;
//        operand2 = 8'hAD;
//        #10;
//        if (result !== 8'hDE) begin
//            $display("Error: Pass operand1 failed");
//            $display("Expected: DE, Got: %h", result);
//            $finish;
//        end
//        $display("Test 6 passed: Pass operand1 works");
        
//        // Test 7: Pass operand2
//        $display("\nTest 7: Pass operand2");
//        alu_op = 4'b0101;
//        operand1 = 8'hBE;
//        operand2 = 8'hEF;
//        #10;
//        if (result !== 8'hEF) begin
//            $display("Error: Pass operand2 failed");
//            $display("Expected: EF, Got: %h", result);
//            $finish;
//        end
//        $display("Test 7 passed: Pass operand2 works");
        
//        // Test 8: Default operation
//        $display("\nTest 8: Default operation");
//        alu_op = 4'b1111; // Undefined operation
//        operand1 = 8'h11;
//        operand2 = 8'h22;
//        #10;
//        if (result !== 8'h11) begin
//            $display("Error: Default operation failed");
//            $display("Expected: 11, Got: %h", result);
//            $finish;
//        end
//        $display("Test 8 passed: Default operation works");
        
//        // Test 9: Debug accumulator check
//        $display("\nTest 9: Debug accumulator check");
//        alu_op = 4'b0000;
//        immediate = 8'h55;
//        #10; // First clock - result = 55
//        if (debug_accumulator !== 8'h11) begin
//            $display("Error: Debug accumulator not capturing previous result");
//            $display("Expected: 11, Got: %h", debug_accumulator);
//            $finish;
//        end
//        #10; // Second clock - debug should capture previous result (55)
//        if (debug_accumulator !== 8'h55) begin
//            $display("Error: Debug accumulator not updated correctly");
//            $display("Expected: 55, Got: %h", debug_accumulator);
//            $finish;
//        end
//        $display("Test 9 passed: Debug accumulator works");
        
//        $display("\nAll ALU tests passed successfully!");
//        $finish;
//    end

//endmodule

module alu_tb;
    reg clk, reset;
    reg [3:0] alu_op;
    reg [7:0] operand1, operand2, immediate;
    wire [7:0] result, debug_accumulator;
    
    alu uut (
        .clk(clk), .reset(reset), .alu_op(alu_op),
        .operand1(operand1), .operand2(operand2), .immediate(immediate),
        .result(result), .debug_accumulator(debug_accumulator)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        $display("=== ALU TESTBENCH ===");
        reset = 1; #10; reset = 0; #10;
        
        // Test Load Immediate (should be immediate)
        alu_op = 4'b0000; immediate = 8'h42; operand1 = 8'h00; operand2 = 8'h00;
        #1; // Wait 1ns (much less than clock period)
        $display("Time %0t: LI test - Expected: 42, Got: %h %s", 
                 $time, result, (result == 8'h42) ? "PASS" : "FAIL");
        
        // Test ADD (should be immediate)
        alu_op = 4'b0001; operand1 = 8'h05; operand2 = 8'h03; immediate = 8'h00;
        #1;
        $display("Time %0t: ADD test - Expected: 08, Got: %h %s", 
                 $time, result, (result == 8'h08) ? "PASS" : "FAIL");
        
        // Test SUB (should be immediate)
        alu_op = 4'b0010; operand1 = 8'h0A; operand2 = 8'h04;
        #1;
        $display("Time %0t: SUB test - Expected: 06, Got: %h %s", 
                 $time, result, (result == 8'h06) ? "PASS" : "FAIL");
        
        #20; $finish;
    end
endmodule