`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 09:51:31 PM
// Design Name: 
// Module Name: app_ram
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


module app_ram (
    input wire clk,
    input wire [384*16-1:0] din,
    input wire wr_en,
    input wire [6:0] wr_addr,
    input wire rd_en,
    input wire [6:0] rd_addr,
    output wire [384*16-1:0] dout
);

  // Instantiate two block RAM modules for application RAM
  blk_mem_gen_0 app_ram_inst_0 (
      .clka (clk),              // Clock input for write port
      .ena  (wr_en),            // Enable signal for write port
      .wea  (wr_en),            // Write enable for write port
      .addra(wr_addr),          // Write address
      .dina (din[16*192-1:0]),  // Data input for write port
      .clkb (clk),              // Clock input for read port
      .enb  (rd_en),            // Enable signal for read port
      .addrb(rd_addr),          // Read address
      .doutb(dout[16*192-1:0])  // Data output for read port
  );

  blk_mem_gen_0 app_ram_inst_1 (
      .clka (clk),                   // Clock input for write port
      .ena  (wr_en),                 // Enable signal for write port
      .wea  (wr_en),                 // Write enable for write port
      .addra(wr_addr),               // Write address
      .dina (din[16*384-1:16*192]),  // Data input for write port
      .clkb (clk),                   // Clock input for read port
      .enb  (rd_en),                 // Enable signal for read port
      .addrb(rd_addr),               // Read address
      .doutb(dout[16*384-1:16*192])  // Data output for read port
  );
endmodule
