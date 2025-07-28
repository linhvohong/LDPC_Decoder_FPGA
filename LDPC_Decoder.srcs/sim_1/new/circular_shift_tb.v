`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2025 09:51:42 PM
// Design Name: 
// Module Name: circular_shift_tb
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


module circular_shift_tb(

    );

    // Testbench for circular_shift module

    reg [16*384:0] data_in;
    reg [9:0] shift_amount;
    reg [9:0] Zc;
    wire [16*384:0] data_out;

    // Instantiate the circular_shift module
    circular_shift uut (
        .data_in(data_in),
        .shift_amount(shift_amount),
        .Zc(Zc),
        .data_out(data_out)
    );

    initial begin
        for (integer i = 0; i < 384; i = i + 1) begin
            data_in[i*16 +: 16] = i;
        end

        // Test case 1: Shift by 0
        shift_amount = 0;
        Zc = 32;
        #10;
        $display("Test case 1: Shift by 0");
        $display("data_out: %h", data_out);     

        // Test case 2: Shift by 5
        shift_amount = 5;
        Zc = 32;
        #10;
        $display("Test case 2: Shift by 5");
        $display("data_out: %h", data_out);
        // Finish simulation
        $finish;
    end
endmodule
