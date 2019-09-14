/*******************************************************
********************************************************
Filename: tb_Serial_Adder.v
module name: tb_Serial_Adder

Created By: Ard Aunario
Date Created: 9/13/19
Description: Testbench for Serial_Adder

Revised:

********************************************************
*******************************************************/
`timescale 1 ns / 1 ps
`define CLK_PER 10

module tb_Serial_Adder();
	parameter SIZE = 8;

	reg CLK, RST, START;
	reg [SIZE-1:0] A, B;
	wire [SIZE:0] SUM;

	/* UUT - Serial Adder */
	Serial_Adder UUT(SUM, CLK, RST, START, A, B);

	/* Clock */
	initial begin
		CLK = 1'b0;
		forever #(`CLK_PER/2) CLK = ~CLK;
	end

	/* Monitor */
	initial
		$monitor("RST = %b START = %b A = %d B = %d CURRENT_STATE = %b --- SUM = %d",
			RST,
			START,
			A,
			B,
			UUT.FSM_1.CURRENT_STATE,
			SUM
		);

	/* Initial */
	initial begin
		RST = 0; START = 0; A = 'd143; B = 'd57;
		#(`CLK_PER) RST = 1; START = 1;
		#(`CLK_PER * 10) START = 0; A = 'd67; B = 'd33;
		#(`CLK_PER * 2) START = 1;
		#(`CLK_PER * 12);
	end
endmodule