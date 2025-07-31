`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2024 12:09:34 PM
// Design Name: 
// Module Name: register_file
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


module register_file (
    input wire clk,
    input wire reset,
    input wire write_enable,
    input wire [2:0] write_addr,
    input wire [7:0] write_data,
    input wire [2:0] read_addr1,
    input wire [2:0] read_addr2,
    output wire [7:0] read_data1,
    output wire [7:0] read_data2
);

    reg [7:0] registers [0:7];

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 8; i = i + 1) begin
                registers[i] <= 8'b0;
            end
        end else if (write_enable) begin
            registers[write_addr] <= write_data;
        end
    end
    
//    always @* begin
//        if(write_enable) begin
//            registers[write_addr] <= write_data;
//        end
//    end

//    always @* begin
//        read_data1 = registers[read_addr1];
//        read_data2 = registers[read_addr2];
//    end

    assign read_data1 = registers[read_addr1];
    assign read_data2 = registers[read_addr2];

//always @(read_addr1, read_addr2, registers[0], registers[1], registers[2], 
//         registers[3], registers[4], registers[5], registers[6], registers[7]) begin
//    read_data1 = registers[read_addr1];
//    read_data2 = registers[read_addr2];
//end

endmodule
