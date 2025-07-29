`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2025 09:58:05 PM
// Design Name: 
// Module Name: app_ram_
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


module app_ram_tb();

// Parameters
localparam DATA_WIDTH = 384*16;
localparam ADDR_WIDTH = 7;

// Testbench signals
reg clk;
reg [DATA_WIDTH-1:0] din;
reg wr_en;
reg [ADDR_WIDTH-1:0] wr_addr;
reg rd_en;
reg [ADDR_WIDTH-1:0] rd_addr;
wire [DATA_WIDTH-1:0] dout;

// Instantiate the DUT
app_ram uut (
    .clk(clk),
    .din(din),
    .wr_en(wr_en),
    .wr_addr(wr_addr),
    .rd_en(rd_en),
    .rd_addr(rd_addr),
    .dout(dout)
);

// Clock generation
initial clk = 0;
always #5 clk = ~clk;

// Read data from llr.txt and apply to din
integer data_file, status;
integer i;
integer Zc;
reg [DATA_WIDTH-1:0] data_mem [0:(1<<ADDR_WIDTH)-1];

// Initialize signals and read data
initial begin
    wr_en = 0;
    rd_en = 0;
    din = 0;
    wr_addr = 0;
    rd_addr = 0;
    Zc = 32;

    // Open data file
    data_file = $fopen("/home/linh/WORK/SOCONE/Repository/BACKUP/C/data/llr.txt", "r");
    if (data_file == 0) begin
        $display("ERROR: Could not open llr.txt");
        $finish;
    end

    // Write data to RAM
    for (integer i = 0; i < 68; i = i + 1) begin
        @ (posedge clk);
        wr_en = 1;
        wr_addr = i;
        if (i == 0 || i== 1) begin
            for (integer j = 0; j < Zc; j = j + 1) begin
                din[j*16 +: 16] = -128;
            end
        end
        else begin
            for (integer j = 0; j < Zc; j = j + 1) begin
                status = $fscanf(data_file, "%d", din[j*16 +: 16]);
                if (status != 1) begin
                    $display("ERROR: Could not read data from llr.txt");
                    $finish;
                end
            end
        end
        $display("Read data for node %0d: %h", i, din);
        @ (posedge clk);
        wr_en = 0;
    end
    $fclose(data_file);


    #1000;
    // Read data back from the RAM
    for (integer i = 0; i < 68; i = i + 1) begin
        @ (posedge clk);
        rd_en = 1;
        rd_addr = i;
        @ (posedge clk);
        rd_en = 0;
        @ (posedge clk);
        $display("Read data from RAM for node %0d: %h", i, dout);
    end


    // Finish simulation
    #20;
    $finish;
end

endmodule
