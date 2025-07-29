`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 10:22:27 PM
// Design Name: 
// Module Name: LDPC_Decode_top
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


module LDPC_Decode_top(
    input wire clk,
    input wire rst,

    // External interface signals to write llr values
    input wire ext_sel,
    input wire [6:0] ext_wr_addr,
    input wire [16*384-1:0] ext_data_in,
    input wire ext_wr_en,
    input wire [6:0] ext_rd_addr,
    output wire [16*384-1:0] ext_data_out,
    input wire ext_rd_en,

    // External interface signals to write CSR
    input wire [6:0] csr_wr_addr,
    input wire [31:0] csr_data_in,
    input wire csr_wr_en,
    input wire csr_rd_en,
    input wire [6:0] csr_rd_addr,
    output wire [31:0] csr_data_out
);


    // decoder instantiation
    wire [8:0] Zc;
    // Internal interface signals between app_controller and decoder
    wire int_sel;
    wire [6:0] int_wr_addr;
    wire [16*384-1:0] int_data_in;
    wire int_wr_en;
    wire [6:0] int_rd_addr;
    wire [16*384-1:0] int_data_out;
    wire int_rd_en;

    csr_reg csr_reg_inst (
        .clk(clk),
        .rst(rst),
        .csr_wr_addr(csr_wr_addr),
        .csr_data_in(csr_data_in),
        .csr_wr_en(csr_wr_en),
        .csr_rd_en(csr_rd_en),
        .csr_rd_addr(csr_rd_addr),
        .csr_data_out(csr_data_out),
        .Zc(Zc)
    );

    // app_controller instantiation
    app_controller app_controller_inst (
        .clk(clk),
        .ext_sel(ext_sel),
        .ext_wr_addr(ext_wr_addr),
        .ext_data_in(ext_data_in),
        .ext_wr_en(ext_wr_en),
        .ext_rd_addr(ext_rd_addr),
        .ext_data_out(ext_data_out),
        .ext_rd_en(ext_rd_en),
        .int_sel(int_sel),
        .int_wr_addr(int_wr_addr),
        .int_data_in(int_data_in),
        .int_wr_en(int_wr_en),
        .int_rd_addr(int_rd_addr),
        .int_data_out(int_data_out),
        .int_rd_en(int_rd_en)
    );

endmodule
