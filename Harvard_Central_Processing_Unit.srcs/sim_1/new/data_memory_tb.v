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

module data_memory_tb();

    reg clk;
    reg [7:0] address;
    reg write_enable;
    reg read_enable;
    reg [7:0] data_in;
    wire [7:0] data_out;
    
    data_memory dut (
        .clk(clk),
        .address(address),
        .write_enable(write_enable),
        .read_enable(read_enable),
        .data_in(data_in),
        .data_out(data_out)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        write_enable = 0;
        read_enable = 0;
        address = 0;
        data_in = 0;
        
        #20;
        
        // Test case 1: Write data to memory
        @(negedge clk);
        write_enable = 1;
        read_enable = 0;
        address = 8'h20;
        data_in = 8'hA5;
        @(posedge clk);
        @(negedge clk);
        write_enable = 0;
        
        // Test case 2: Read data from memory
        read_enable = 1;
        @(posedge clk);
        @(negedge clk);
        if (data_out === 8'hA5)
            $display("Test case 1 passed: Read correct data 0xA5 from address 0x20");
        else
            $display("Test case 1 failed: Expected 0xA5, got %h", data_out);
        
        // Test case 3: Write to different address
        write_enable = 1;
        read_enable = 0;
        address = 8'h55;
        data_in = 8'h3C;
        @(posedge clk);
        @(negedge clk);
        write_enable = 0;
        
        // Test case 4: Read from second address
        read_enable = 1;
        @(posedge clk);
        @(negedge clk);
        if (data_out === 8'h3C)
            $display("Test case 2 passed: Read correct data 0x3C from address 0x55");
        else
            $display("Test case 2 failed: Expected 0x3C, got %h", data_out);
        
        // Test case 5: Read from first address again
        address = 8'h20;
        @(posedge clk);
        @(negedge clk);
        if (data_out === 8'hA5)
            $display("Test case 3 passed: First written data preserved");
        else
            $display("Test case 3 failed: Expected 0xA5, got %h", data_out);
        
        // Test case 6: Test read without read_enable
        read_enable = 0;
        address = 8'h55;
        @(posedge clk);
        @(negedge clk);
        if (data_out !== 8'h3C)
            $display("Test case 4 passed: Data not read when read_enable is low");
        else
            $display("Test case 4 failed: Data should not have updated");
        
        // Test case 7: Test write without write_enable
        write_enable = 0;
        address = 8'h20;
        data_in = 8'hFF;
        @(posedge clk);
        read_enable = 1;
        @(posedge clk);
        @(negedge clk);
        if (data_out === 8'hA5)
            $display("Test case 5 passed: Write ignored when write_enable is low");
        else
            $display("Test case 5 failed: Expected 0xA5, got %h", data_out);
        
        // End simulation
        #20;
        $display("Simulation completed");
        $finish;
    end
endmodule