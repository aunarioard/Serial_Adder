/*******************************************************
********************************************************
Filename: FSM_Controller.v
module name: FSM_Controller

Created By: Ard Aunario
Date Created: 9/12/19
Description: FSM Controller that will control 3 shift register and 
	one DFF in a serial adder. This controller has 4 states. 
		Reset: Basically resets the controller and goes to the wait state
		Wait: Loads data to two of the shift register to be added in serial
				and to enable the 3 shift register and the DFF.
		Work: The data will be shifted one by one and will be added for 8 clock cycles
		End: The 2 data has been added and waiting for signal START to be LOW again.

Revised:

********************************************************
*******************************************************/
`timescale 1 ns / 1 ps
`define RESET 2'b00
`define WAIT 2'b01
`define WORK 2'b10
`define END 2'b11

module FSM_Controller(EN_OUT, LOAD, START, CLK, RST);
	input START, CLK, RST;
	output reg EN_OUT, LOAD;
	
	reg [1:0] CURRENT_STATE, NEXT_STATE;
	reg [3:0] COUNT;
	
	/* Nextstate Logic */
	always@(CURRENT_STATE or START or COUNT) begin
		case (CURRENT_STATE)
			`RESET:	
				NEXT_STATE = `WAIT;
			
			`WAIT:
				begin
					if (START)
						NEXT_STATE = `WORK;
					else
						NEXT_STATE = CURRENT_STATE;
				end
				
			`WORK:
				begin
				 if (COUNT == 4'd8) 
					NEXT_STATE = `END;
				 else 
					NEXT_STATE = CURRENT_STATE;
				end
				
			`END:
				begin
					if (~START) 
						NEXT_STATE = `WAIT;
					else
						NEXT_STATE = CURRENT_STATE;
				end
				
			default: 
				NEXT_STATE = 2'bxx;
				
		endcase
	end
	
	/* CurrentState Logic and COUNTER */
	always@(posedge CLK or negedge RST) begin
		if (~RST) begin
			CURRENT_STATE <= `RESET;
			COUNT <= 'b0;
		end
		else begin
			CURRENT_STATE <= NEXT_STATE;
			if (CURRENT_STATE == `WAIT) 
				COUNT <= 'b0;
			else if (CURRENT_STATE == `WORK)
				COUNT <= COUNT + 1'b1;
			else
				COUNT <= COUNT;
		end
	end
	
	/* Output */
	always@(CURRENT_STATE or COUNT) begin
		if (CURRENT_STATE == `WAIT) begin
			LOAD = 1'b1;
			EN_OUT = 1'b1;
		end
		else if (CURRENT_STATE == `WORK) begin
			LOAD = 1'b0;
			EN_OUT = 1'b1;
		end
		else if (CURRENT_STATE == `END) begin
			LOAD = 1'b0;
			EN_OUT = 1'b0;
		end
		else begin
			LOAD = 1'b0;
			EN_OUT = 1'b0;
		end
	end
		
			
endmodule