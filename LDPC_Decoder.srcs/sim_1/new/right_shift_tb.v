`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2025 09:00:01 PM
// Design Name: 
// Module Name: right_shift_tb
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


module right_shift_tb();

    reg clk;
    reg rst;
    reg [9:0] shift_amount;
    reg  [16*384-1:0] in_data;
    wire [16*384-1:0] out_data;

    // Instantiate the right_shift module
    right_shift uut (
        .shift_amount(shift_amount),
        .in_data(in_data),
        .out_data(out_data)
    );

    integer i;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst = 1;
        shift_amount = 0;
        // Assign each 16-bit segment of in_data
        for (i = 0; i < 384; i = i + 1)
            in_data[i*16 +: 16] = i;
        #12;
        rst = 0;

        // Test case 1: shift_amount = 0
        shift_amount = 0;
        #10;
        $display("shift_amount=%d", shift_amount);
        for (i = 0; i < 384; i = i + 1)
            $display("out_data[%0d]=%d", i, out_data[i*16 +: 16]);

        // Test case 2: shift_amount = 3
        shift_amount = 3;
        #10;
        $display("shift_amount=%d", shift_amount);
        for (i = 0; i < 384; i = i + 1)
            $display("out_data[%0d]=%d", i, out_data[i*16 +: 16]);

        // Test case 3: shift_amount = 6
        shift_amount = 6;
        #10;
        $display("shift_amount=%d", shift_amount);
        for (i = 0; i < 384; i = i + 1)
            $display("out_data[%0d]=%d", i, out_data[i*16 +: 16]);

        // Test case 4: shift_amount = 7
        shift_amount = 7;
        #10;
        $display("shift_amount=%d", shift_amount);
        for (i = 0; i < 384; i = i + 1)
            $display("out_data[%0d]=%d", i, out_data[i*16 +: 16]);

        $finish;
    end
endmodule

