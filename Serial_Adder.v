/*******************************************************
********************************************************
Filename: Serial_Adder.v
module name: Serial_Adder

Created By: Ard Aunario
Date Created: 9/12/19
Description: Top design of the serial adder. Adds two 8-bits in serial and 
	will have the output as a sum in 9-bits to include C_IN.

Revised:

********************************************************
*******************************************************/
`timescale 1 ns / 1 ps

module Serial_Adder(SUM, CLK, RST, START, A, B);
	parameter SIZE = 8;
	
	input CLK, RST, START;
	input [SIZE-1:0] A, B;
	output [SIZE:0] SUM;
	
	/* Wires */
	wire EN_OUT, LOAD, C_OUT, FA_SUM;
	wire [SIZE-1:0] A_REG_WIRE, B_REG_WIRE;
	
	/* Reg */
	reg C_IN;
	
	/* FSM Controller */
	FSM_Controller FSM_1(EN_OUT, LOAD, START, CLK, RST);
	
	/* Data A Shift Register */
	Shift_Reg A_REG(A_REG_WIRE, CLK, RST, EN_OUT, LOAD, 1'b0, A);
	
	/* Data B Shift Register */
	Shift_Reg B_REG(B_REG_WIRE, CLK, RST, EN_OUT, LOAD, 1'b0, B);
	
	/* Full Adder */
	assign {C_OUT, FA_SUM} = A_REG_WIRE[0] + B_REG_WIRE[0] + C_IN;
	
	/* D-Flip Flop */
	always@(posedge CLK or negedge RST) begin
		if (~RST)
			C_IN <= 1'b0;
		else
			C_IN <= C_OUT;
	end
	
	/* Sum Shift Register */
	Shift_Reg #(.SIZE(9)) SUM_REG(SUM, CLK, RST, EN_OUT, 1'b0, FA_SUM, 'b0);	
	
endmodule