`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 10:32:06 PM
// Design Name: 
// Module Name: app_controller
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


module app_controller(
    input wire clk,

    // PORT 1 External interface signals to write llr values
    input wire ext_sel,
    input wire [6:0] ext_wr_addr,
    input wire [16*384-1:0] ext_data_in,
    input wire ext_wr_en,
    input wire [6:0] ext_rd_addr,
    output wire [16*384-1:0] ext_data_out,
    output wire ext_rd_en,

    // PORT 2 Internal interface signals to write llr values
    input wire int_sel,
    input wire [6:0] int_wr_addr,
    input wire [16*384-1:0] int_data_in,
    input wire int_wr_en,
    input wire [6:0] int_rd_addr,
    output wire [16*384-1:0] int_data_out,
    output wire int_rd_en
    );

    // Internal signals
    wire [16*384-1:0] din_int;
    wire wr_en_int;
    wire [6:0] wr_addr_int;
    wire rd_en_int;
    wire [6:0] rd_addr_int;
    wire [16*384-1:0] data_out;

    assign din_int = ext_sel ? ext_data_in : int_data_in;
    assign wr_en_int = ext_sel ? ext_wr_en : int_wr_en;
    assign wr_addr_int = ext_sel ? ext_wr_addr : int_wr_addr;
    assign rd_en_int = ext_sel ? ext_rd_en : int_rd_en;
    assign rd_addr_int = ext_sel ? ext_rd_addr : int_rd_addr;

    // Instantiate app_ram for shared memory access
    app_ram u_app_ram (
        .clk(clk),
        .din(din_int),
        .wr_en(wr_en_int),
        .wr_addr(wr_addr_int),
        .rd_en(rd_en_int),
        .rd_addr(rd_addr_int),
        .dout(data_out)
    );

    // Assign outputs for external and internal ports
    assign ext_data_out = data_out;
    assign int_data_out = data_out;


endmodule
