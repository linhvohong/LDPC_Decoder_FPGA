`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/28/2025 09:37:14 PM
// Design Name: 
// Module Name: circular_shift
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


module circular_shift (
    input wire [16*384-1:0] data_in,
    input wire [9:0] shift_amount,
    input wire [9:0] Zc,
    output wire [16*384-1:0] data_out
);

  parameter Zc_MAX = 384;
  wire [9:0] shift_amount_right = shift_amount;
  wire [9:0] shift_amount_left =  shift_amount != 0 ? Zc_MAX - Zc + shift_amount : 0 ;


  wire [384-1:0] bitmask_left = (1 << shift_amount) - 1;
  wire [384-1:0] bitmask_right = (~bitmask_left) & ((1 << Zc) - 1);

  wire [16*384-1:0] shifted_right_tmp;
  wire [16*384-1:0] shifted_left_tmp;
  wire [16*384-1:0] shifted_right;
  wire [16*384-1:0] shifted_left; 


  right_shift u_right (
      .in_data(data_in),
      .shift_amount(shift_amount_right),
      .out_data(shifted_right_tmp)
  );

  right_shift u_left (
      .in_data(data_in),
      .shift_amount(shift_amount_left),
      .out_data(shifted_left_tmp)
  );

  generate
    genvar i;
    for (i = 0; i < 384; i = i + 1) begin : shift
      assign shifted_right[i*16+15:i*16] = bitmask_right[i] ? shifted_right_tmp[i*16+15:i*16] : 0;
    end
    for (i = 0; i < 384; i = i + 1) begin : shift_left
      assign shifted_left[i*16+15:i*16] = bitmask_left[i] ? shifted_left_tmp[i*16+15:i*16] : 0;
    end
  endgenerate

  assign data_out = shifted_right | shifted_left;

endmodule
