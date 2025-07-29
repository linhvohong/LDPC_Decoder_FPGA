`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 10:27:52 PM
// Design Name: 
// Module Name: csr_reg
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


module csr_reg(
    input wire clk,
    input wire rst,
    input wire [6:0] csr_wr_addr,
    input wire [31:0] csr_data_in,
    input wire csr_wr_en,
    input wire csr_rd_en,
    input wire [6:0] csr_rd_addr,
    output reg [31:0] csr_data_out,

    output wire [9:0] Zc
    );

    assign Zc = csr_regs[0][9:0];
    // remain register for other CSR functionalities

    reg [31:0] csr_regs [0:127]; // CSR register array

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all CSR registers to zero
            csr_data_out <= 32'b0;
            csr_regs[0] <= 32'b0; // Reset Zc register
        end else begin
            if (csr_wr_en) begin
                // Write to CSR register
                csr_regs[csr_wr_addr] <= csr_data_in;
            end
            if (csr_rd_en) begin
                // Read from CSR register
                csr_data_out <= csr_regs[csr_rd_addr];
            end
        end
    end
endmodule

