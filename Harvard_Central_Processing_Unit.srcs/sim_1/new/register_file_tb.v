`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2024 10:38:56 PM
// Design Name: 
// Module Name: register_file_tb
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


//module register_file_tb;

//    // Inputs
//    reg clk;
//    reg reset;
//    reg write_enable;
//    reg [2:0] write_addr;
//    reg [7:0] write_data;
//    reg [2:0] read_addr1;
//    reg [2:0] read_addr2;

//    // Outputs
//    wire [7:0] read_data1;
//    wire [7:0] read_data2;

//    // Instantiate the Unit Under Test (UUT)
//    register_file uut (
//        .clk(clk),
//        .reset(reset),
//        .write_enable(write_enable),
//        .write_addr(write_addr),
//        .write_data(write_data),
//        .read_addr1(read_addr1),
//        .read_addr2(read_addr2),
//        .read_data1(read_data1),
//        .read_data2(read_data2)
//    );

//    // Clock generation
//    always begin
//        #5 clk = ~clk;
//    end

//    initial begin
//        // Initialize Inputs
//        clk = 0;
//        reset = 0;
//        write_enable = 0;
//        write_addr = 0;
//        write_data = 0;
//        read_addr1 = 0;
//        read_addr2 = 0;

//        // Wait for global reset
//        #10;
        
//        // Test 1: Reset test
//        reset = 1;
//        #10;
//        reset = 0;
//        #10;
        
//        // Verify all registers are zero after reset
//        for (integer i = 0; i < 8; i = i + 1) begin
//            read_addr1 = i;
//            #1;
//            if (read_data1 !== 8'b0) begin
//                $display("Error: Register %0d not reset to 0", i);
//                $finish;
//            end
//        end
//        $display("Reset test passed");
        
//        // Test 2: Write and read test
//        write_enable = 1;
//        for (integer i = 0; i < 8; i = i + 1) begin
//            write_addr = i;
//            write_data = 8'h55 + i;
//            #10; // Wait for clock edge
            
//            // Read back immediately
//            read_addr1 = i;
//            #1;
//            if (read_data1 !== (8'h55 + i)) begin
//                $display("Error: Register %0d write/read mismatch", i);
//                $finish;
//            end
//        end
//        $display("Write and read test passed");
        
//        // Test 3: Read two different registers simultaneously
//        read_addr1 = 1;
//        read_addr2 = 2;
//        #1;
//        if (read_data1 !== 8'h56 || read_data2 !== 8'h57) begin
//            $display("Error: Simultaneous read test failed");
//            $finish;
//        end
//        $display("Simultaneous read test passed");
        
//        // Test 4: Write disable test
//        write_enable = 0;
//        write_addr = 3;
//        write_data = 8'hFF;
//        #10;
//        read_addr1 = 3;
//        #1;
//        if (read_data1 === 8'hFF) begin
//            $display("Error: Write disabled but register updated");
//            $finish;
//        end
//        $display("Write disable test passed");
        
//        // Test 5: Write to register and read from another
//        write_enable = 1;
//        write_addr = 4;
//        write_data = 8'hAA;
//        read_addr1 = 5;
//        #10;
//        #1;
//        if (read_data1 !== 8'h5A) begin
//            $display("Error: Read address affected by write address");
//            $finish;
//        end
//        $display("Independent write/read test passed");
        
//        $display("All tests passed successfully");
//        $finish;
//    end

//endmodule

module register_file_tb;
 reg clk, reset, write_enable;
   reg [2:0] write_addr, read_addr1, read_addr2;
   reg [7:0] write_data;
   wire [7:0] read_data1, read_data2;
   
   register_file uut (
       .clk(clk), .reset(reset), .write_enable(write_enable),
       .write_addr(write_addr), .write_data(write_data),
       .read_addr1(read_addr1), .read_addr2(read_addr2),
       .read_data1(read_data1), .read_data2(read_data2)
   );
   
   initial begin
       clk = 0;
       forever #5 clk = ~clk;
   end
   
   // Monitor all changes
   always @* begin
       $display("Time %0t: write_en=%b, write_addr=%b, write_data=%h, read_addr1=%b, read_data1=%h, read_addr2=%b, read_data2=%h", 
                $time, write_enable, write_addr, write_data, read_addr1, read_data1, read_addr2, read_data2);
   end
   
   // Display register contents at each clock edge
   always @(posedge clk) begin
       $display("Clock %0t: R0=%h R1=%h R2=%h R3=%h R4=%h R5=%h R6=%h R7=%h", 
                $time, uut.registers[0], uut.registers[1], uut.registers[2], uut.registers[3],
                uut.registers[4], uut.registers[5], uut.registers[6], uut.registers[7]);
   end
   
   initial begin
       $display("=== DEBUG REGISTER FILE TESTBENCH ===");
       
       // Initialize
       reset = 1; write_enable = 0; read_addr1 = 0; read_addr2 = 0; 
       write_addr = 0; write_data = 0;
       #20; 
       reset = 0;
       #10;
       
       $display("\n--- TEST 1: Write 0x42 to R1 ---");
       @(posedge clk);
       write_enable = 1; 
       write_addr = 3'b001; 
       write_data = 8'h42;
       read_addr1 = 3'b001;  // Point to R1
       
       $display("Before clock edge: R1 should be 00, read_data1 = %h", read_data1);
       @(posedge clk);
       $display("After clock edge: R1 should be 42, read_data1 = %h", read_data1);
       
       $display("\n--- TEST 2: Write 0x99 to R2 ---");
       write_addr = 3'b010; 
       write_data = 8'h99;
       @(posedge clk);
       write_enable = 0;  // Disable write
       
       $display("After writing 99 to R2:");
       $display("R2 content from array: %h", uut.registers[2]);
       
       $display("\n--- TEST 3: Read R2 immediately ---");
       read_addr1 = 3'b010;  // Point to R2
       #1;  // Wait 1ns
       $display("Reading R2 immediately: read_data1 = %h (should be 99)", read_data1);
       $display("R2 content from array: %h", uut.registers[2]);
       
       // Test different addresses
       $display("\n--- TEST 4: Read different registers ---");
       read_addr1 = 3'b001; #1; // R1
       $display("Reading R1: read_data1 = %h (should be 42)", read_data1);
       
       read_addr1 = 3'b000; #1; // R0  
       $display("Reading R0: read_data1 = %h (should be 00)", read_data1);
       
       read_addr1 = 3'b010; #1; // R2
       $display("Reading R2: read_data1 = %h (should be 99)", read_data1);
       
       #20; 
       $finish;
   end
endmodule