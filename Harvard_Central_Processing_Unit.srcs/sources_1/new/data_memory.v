`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2024 12:09:34 PM
// Design Name: 
// Module Name: data_memory
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


module data_memory (
    input wire clk,
    input wire [7:0] address,
    input wire write_enable,
    input wire read_enable,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

    reg [7:0] mem [0:255];

    integer i;

    initial begin
        // Initialize memory with some values
        for (i = 0; i < 256; i = i + 1) begin
            mem[i] = 8'd0;
        end
    end


//    always @(posedge clk) begin
//        // Read first (sees old value)
//        if (read_enable) begin
//            data_out = mem[address];  // Blocking assignment - happens immediately
//        end else begin
//            data_out = 8'd0;
//        end
//        // Write second (updates for next cycle)
//        if (write_enable) begin
//            mem[address] = data_in;   // Blocking assignment - happens after read
//        end
//    end
   always @(*) begin
     if (read_enable) begin
         data_out = mem[address];
     end else begin
         data_out = 8'd0;
     end
 end
 
 // Sequential write (on clock edge)
 always @(posedge clk) begin
     if (write_enable) begin
         mem[address] <= data_in;
     end
 end
    
    
//    always @(posedge clk) begin
//        if (write_enable) begin
//            mem[address] <= data_in;
//        end else         if (read_enable) begin
//                data_out <= mem[address];
//            end else begin
//                data_out <= 8'b0; 
//            end
//    end
    
//    always @* begin
//        if (read_enable) begin
//            data_out <= mem[address];
//        end else begin
//            data_out <= 8'b0; 
//        end
//    end

endmodule
