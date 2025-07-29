`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 10:32:41 PM
// Design Name: 
// Module Name: LDPC_Decode_top_tb
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


module LDPC_Decode_top_tb();


// Testbench signals
reg clk;
reg rst;
reg ext_sel;
reg [6:0] ext_wr_addr;
reg [16*384-1:0] ext_data_in;
reg ext_wr_en;
reg [6:0] ext_rd_addr;
wire [16*384-1:0] ext_data_out;
reg ext_rd_en;

reg [6:0] csr_wr_addr;
reg [31:0] csr_data_in;
reg csr_wr_en;
reg csr_rd_en;
reg [6:0] csr_rd_addr;
wire [31:0] csr_data_out;
integer Zc;
integer data_file;
integer status;

// Instantiate DUT
LDPC_Decode_top dut (
    .clk(clk),
    .rst(rst),
    .ext_sel(ext_sel),
    .ext_wr_addr(ext_wr_addr),
    .ext_data_in(ext_data_in),
    .ext_wr_en(ext_wr_en),
    .ext_rd_addr(ext_rd_addr),
    .ext_data_out(ext_data_out),
    .ext_rd_en(ext_rd_en),
    .csr_wr_addr(csr_wr_addr),
    .csr_data_in(csr_data_in),
    .csr_wr_en(csr_wr_en),
    .csr_rd_en(csr_rd_en),
    .csr_rd_addr(csr_rd_addr),
    .csr_data_out(csr_data_out)
);

// Clock generation
initial clk = 0;
always #5 clk = ~clk;

// Test sequence
initial begin
    // Initialize signals
    ext_wr_en = 0;
    ext_rd_en = 0;
    ext_data_in = 0;
    ext_wr_addr = 0;
    ext_rd_addr = 0;
    csr_wr_en = 0;
    csr_rd_en = 0;
    csr_wr_addr = 0;
    csr_data_in = 0;
    csr_rd_addr = 0;
    ext_sel = 0;
    Zc = 32;

    // Reset DUT
    rst = 1;
    #10000;
    rst = 0;


    // Write Zc value to CSR register
    @(posedge clk);
    csr_wr_en = 1;
    csr_wr_addr = 7'd0;
    csr_data_in = Zc;
    @(posedge clk);
    csr_wr_en = 0;

    // Open data file
    data_file = $fopen("/home/linh/WORK/SOCONE/Repository/BACKUP/C/data/llr.txt", "r");
    if (data_file == 0) begin
        $display("ERROR: Could not open llr.txt");
        $finish;
    end

    ext_sel = 1;
    // Write data to RAM
    for (integer i = 0; i < 68; i = i + 1) begin
        @(posedge clk);
        ext_wr_en = 1;
        ext_wr_addr = i;
        if (i == 0 || i == 1) begin
            for (integer j = 0; j < Zc; j = j + 1) begin
                ext_data_in[j*16 +: 16] = -128;
            end
        end else begin
            for (integer j = 0; j < Zc; j = j + 1) begin
                status = $fscanf(data_file, "%d", ext_data_in[j*16 +: 16]);
                if (status != 1) begin
                    $display("ERROR: Could not read data from llr.txt");
                    $finish;
                end
            end
        end
        $display("Read data for node %0d: %h", i, ext_data_in);
        @(posedge clk);
        ext_wr_en = 0;
    end
    $fclose(data_file);

    #1000;
    // Read data back from the RAM
    for (integer i = 0; i < 68; i = i + 1) begin
        @(posedge clk);
        ext_rd_en = 1;
        ext_rd_addr = i;
        @(posedge clk);
        ext_rd_en = 0;
        @(posedge clk);
        $display("Read data from RAM for node %0d: %h", i, ext_data_out);
    end
    $finish;
end
endmodule
