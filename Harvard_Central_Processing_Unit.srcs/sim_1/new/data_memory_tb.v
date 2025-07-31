`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2024 09:45:48 PM
// Design Name: 
// Module Name: data_memory_tb
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

module data_memory_tb;

    // Inputs
    reg clk;
    reg [7:0] address;
    reg write_enable;
    reg read_enable;
    reg [7:0] data_in;

    // Outputs
    wire [7:0] data_out;

    // Instantiate the Unit Under Test (UUT)
    data_memory uut (
        .clk(clk),
        .address(address),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    initial begin
        // Initialize Inputs
        clk = 0;
        address = 0;
        write_enable = 0;
        read_enable = 0;
        data_in = 0;

        // Wait for global reset
        #10;
        
        // Test 1: Initial memory check (all zeros)
        $display("Test 1: Initial memory check");
        for (integer i = 0; i < 16; i = i + 1) begin
            address = i;
            read_enable = 1;
            #10;
            if (data_out !== 8'd0) begin
                $display("Error: Memory location %0d not initialized to 0", i);
                $finish;
            end
        end
        read_enable = 0;
        $display("Test 1 passed: All memory locations initialized to 0");
        
        // Test 2: Write and read test
        $display("\nTest 2: Write and read test");
        for (integer i = 0; i < 16; i = i + 1) begin
            address = i;
            data_in = 8'h55 + i;
            write_enable = 1;
            #10; // Write on posedge
            
            write_enable = 0;
            read_enable = 1;
            #10; // Read on next posedge
            
            if (data_out !== (8'h55 + i)) begin
                $display("Error: Write/read mismatch at address %0d", i);
                $display("Expected: %h, Got: %h", (8'h55 + i), data_out);
                $finish;
            end
        end
        read_enable = 0;
        $display("Test 2 passed: Write and read operations work correctly");
        
        // Test 3: Simultaneous write and read (should read old value)
        $display("\nTest 3: Simultaneous write and read");
        address = 8'h10;
        data_in = 8'hAA;
        write_enable = 1;
        read_enable = 1;
        #10;
        
        if (data_out !== 8'd0) begin
            $display("Error: Should read old value during simultaneous write");
            $display("Expected: 00, Got: %h", data_out);
            $finish;
        end
        
        // Check new value was written
        write_enable = 0;
        #10;
        if (data_out !== 8'hAA) begin
            $display("Error: New value not written properly");
            $display("Expected: AA, Got: %h", data_out);
            $finish;
        end
        read_enable = 0;
        $display("Test 3 passed: Simultaneous write/read behavior correct");
        
        // Test 4: Write without read enable
        $display("\nTest 4: Write without read enable");
        address = 8'h20;
        data_in = 8'hBB;
        write_enable = 1;
        read_enable = 0;
        #10;
        
        // Verify write occurred
        write_enable = 0;
        read_enable = 1;
        #10;
        if (data_out !== 8'hBB) begin
            $display("Error: Write without read enable failed");
            $display("Expected: BB, Got: %h", data_out);
            $finish;
        end
        read_enable = 0;
        $display("Test 4 passed: Write without read enable works");
        
        // Test 5: Read without write enable
        $display("\nTest 5: Read without write enable");
        address = 8'h10; // Should contain AA from Test 3
        write_enable = 0;
        read_enable = 1;
        #10;
        
        if (data_out !== 8'hAA) begin
            $display("Error: Read without write enable failed");
            $display("Expected: AA, Got: %h", data_out);
            $finish;
        end
        read_enable = 0;
        $display("Test 5 passed: Read without write enable works");
        
        // Test 6: No operation (both enables low)
        $display("\nTest 6: No operation test");
        address = 8'h10; // Contains AA
        write_enable = 0;
        read_enable = 0;
        #10;
        
        if (data_out !== 8'h00) begin
            $display("Error: Output should be high-Z when not reading");
            $display("Expected: 00, Got: %h", data_out);
            $finish;
        end
        $display("Test 6 passed: Output 0 when not reading");
        
        $display("\nAll data memory tests passed successfully");
        $finish;
    end

endmodule

//module data_memory_tb;
//    reg clk, write_enable, read_enable;
//    reg [7:0] address, data_in;
//    wire [7:0] data_out;
    
//    data_memory uut (
//        .clk(clk), .address(address), .write_enable(write_enable),
//        .read_enable(read_enable), .data_in(data_in), .data_out(data_out)
//    );
    
//    initial begin
//        clk = 0;
//        forever #5 clk = ~clk; // 10ns period
//    end
    
//    initial begin
//        $display("=== DATA MEMORY TESTBENCH ===");
        
//        // Initialize
//        write_enable = 0; read_enable = 0; address = 0; data_in = 0;
//        #20;
        
//        // Test 1: Initial memory check
//        $display("Test 1: Initial memory check");
//        address = 8'h10; read_enable = 1; #1;
//        if (data_out == 8'h00) 
//            $display("Test 1 passed: All memory locations initialized to 0");
//        else 
//            $display("Test 1 failed: Memory not initialized properly. Got: %h", data_out);
        
//        read_enable = 0; #10;
        
//        // Test 2: Write and read test
//        $display("Test 2: Write and read test");
        
//        // Write 0xAA to address 0x20
//        @(posedge clk);
//        address = 8'h20; data_in = 8'hAA; write_enable = 1;
//        @(posedge clk);
//        write_enable = 0;
        
//        // Read back from address 0x20
//        address = 8'h20; read_enable = 1; #1;
//        if (data_out == 8'hAA)
//            $display("Test 2 passed: Write and read operations work correctly");
//        else
//            $display("Test 2 failed: Expected AA, got %h", data_out);
        
//        read_enable = 0; #10;
        
//        // Test 3: Multiple locations
//        $display("Test 3: Multiple location test");
        
//        // Write to multiple locations
//        @(posedge clk);
//        address = 8'h30; data_in = 8'h11; write_enable = 1;
//        @(posedge clk);
//        address = 8'h31; data_in = 8'h22;
//        @(posedge clk);
//        address = 8'h32; data_in = 8'h33;
//        @(posedge clk);
//        write_enable = 0;
        
//        // Read back all locations
//        address = 8'h30; read_enable = 1; #1;
//        $display("Address 30: Expected 11, Got %h %s", data_out, 
//                (data_out == 8'h11) ? "PASS" : "FAIL");
        
//        address = 8'h31; #1;
//        $display("Address 31: Expected 22, Got %h %s", data_out,
//                (data_out == 8'h22) ? "PASS" : "FAIL");
        
//        address = 8'h32; #1;
//        $display("Address 32: Expected 33, Got %h %s", data_out,
//                (data_out == 8'h33) ? "PASS" : "FAIL");
        
//        read_enable = 0; #10;
        
//        // Test 4: Simultaneous write and read (critical timing test)
//        $display("Test 4: Simultaneous write and read");
        
//        // First, write a known value to address 0x40
//        @(posedge clk);
//        address = 8'h40; data_in = 8'h55; write_enable = 1;
//        @(posedge clk);
//        write_enable = 0;
        
//        // Verify it was written
//        address = 8'h40; read_enable = 1; #1;
//        $display("Pre-test: Address 40 contains %h (should be 55)", data_out);
        
//        // Now the critical test: simultaneous write and read
//        @(posedge clk);
//        $display("Before simultaneous operation: data_out = %h", data_out);
        
//        // On the same clock edge: try to write new value AND read
//        address = 8'h40; data_in = 8'h99; write_enable = 1; read_enable = 1;
        
//        // Check immediately (should see OLD value)
//        #1;
//        $display("During simultaneous write/read: data_out = %h", data_out);
//        if (data_out == 8'h55)
//            $display("Test 4 passed: Read returns old value during simultaneous write");
//        else
//            $display("Test 4 failed: Should read old value (55) during simultaneous write, got %h", data_out);
        
//        @(posedge clk);
//        write_enable = 0;
        
//        // Verify new value was written
//        #1;
//        $display("After write cycle: data_out = %h (should be 99)", data_out);
        
//        read_enable = 0; #10;
        
//        // Test 5: Read enable functionality
//        $display("Test 5: Read enable functionality");
        
//        // Write a value
//        @(posedge clk);
//        address = 8'h50; data_in = 8'hDD; write_enable = 1;
//        @(posedge clk);
//        write_enable = 0;
        
//        // Test with read_enable = 0
//        address = 8'h50; read_enable = 0; #1;
//        $display("With read_enable=0: data_out = %h (should be 00)", data_out);
//        if (data_out == 8'h00)
//            $display("Read disable works correctly");
//        else
//            $display("Read disable failed: Expected 00, got %h", data_out);
        
//        // Test with read_enable = 1
//        read_enable = 1; #1;
//        $display("With read_enable=1: data_out = %h (should be DD)", data_out);
//        if (data_out == 8'hDD)
//            $display("Read enable works correctly");
//        else
//            $display("Read enable failed: Expected DD, got %h", data_out);
        
//        read_enable = 0; #10;
        
//        // Test 6: Address range test
//        $display("Test 6: Address range test");
        
//        // Test boundary addresses
//        @(posedge clk);
//        address = 8'h00; data_in = 8'hF0; write_enable = 1;  // Address 0
//        @(posedge clk);
//        address = 8'hFF; data_in = 8'hF1;                    // Address 255
//        @(posedge clk);
//        write_enable = 0;
        
//        // Read back
//        address = 8'h00; read_enable = 1; #1;
//        $display("Address 00: Expected F0, Got %h %s", data_out,
//                (data_out == 8'hF0) ? "PASS" : "FAIL");
        
//        address = 8'hFF; #1;
//        $display("Address FF: Expected F1, Got %h %s", data_out,
//                (data_out == 8'hF1) ? "PASS" : "FAIL");
        
//        read_enable = 0;
        
//        $display("=== DATA MEMORY TEST COMPLETE ===");
//        #50; $finish;
//    end
    
//    // Monitor for debugging
//    always @(posedge clk) begin
//        if (write_enable || read_enable)
//            $display("Clock %0t: addr=%h, write=%b, read=%b, data_in=%h, data_out=%h",
//                    $time, address, write_enable, read_enable, data_in, data_out);
//    end
//endmodule
