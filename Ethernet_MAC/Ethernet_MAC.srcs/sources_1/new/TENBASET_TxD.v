`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2026 11:39:08 PM
// Design Name: 
// Module Name: TENBASET_TxD
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


module TENBASET_TxD(
  input logic i_clk20,
  output logic o_Ethernet_TDp,
  output logic o_Ethernet_TDm
  );
  
  // Source IP address 
  // Pick a random IP adress that is not currently used
  // Ping it that check
  parameter IPsource_1 = 192;
  parameter IPsource_2 = 168;
  parameter IPsource_3 = 1;
  parameter IPsource_4 = 67;
  
  // Destination IP address (my PC IP address)
  // Check using ipconfig /all
  parameter IPdestination_1 = 192;
  parameter IPdestination_2 = 168;
  parameter IPdestination_3 = 1;
  parameter IPdestination_4 = 35;  
  
  // Destination MAC address
  parameter MACdestination_1 = 8'h48;
  parameter MACdestination_2 = 8'hE7;
  parameter MACdestination_3 = 8'hDA;
  parameter MACdestination_4 = 8'hBC;
  parameter MACdestination_5 = 8'hB1;
  parameter MACdestination_6 = 8'hED;
  
  // Send a packet roughly every second
endmodule
