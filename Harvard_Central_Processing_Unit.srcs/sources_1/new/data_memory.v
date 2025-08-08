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
        $readmemh("data_memory.hex", mem);
    end

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
endmodule
