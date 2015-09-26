`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Tecnológico de Costa Rica
// Engineer: Kaleb Alfaro
//
// Create Date: may/2015
// Design Name:
// Module Name: FSM
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////

module fsm
(
	input wire clk,rst, //	Clock y reset
	input wire start,ready,done,// Banderas de entrada
	output reg enable_act,enable_tub,count// Salidas, definidas como reg
);

//*********************************************************

localparam [1:0] // Codificación de los estados o etiquetas
	idle = 2'b00,
	test = 2'b01,
	wait_flag = 2'b10,
	wait_done = 2'b11;

reg [2:0] state, state_next; // Reg, estado actual y siguiente




//*********************************************************

//Parte Secuencial

always@(posedge clk, posedge rst)
begin
	if(rst)
		state <= idle;
	else
		state <= state_next;
end


//*********************************************************

//Parte Combinacional
always@*
begin
	state_next = state;
	enable_act = 0;
	enable_tub = 0;
	count = 0;
	case(state)
		idle:

			if(start)
			begin
				state_next = test;
				enable_act = 1'b1;  //Salida activada en la transición 
			end		
		test:

			if(ready)
				state_next = wait_done;
			else
				state_next = wait_flag;
		wait_flag:

			if(ready)
				state_next = wait_done;
		wait_done:
			begin
				enable_tub = 1'b1; //Salida activada en el estado
			if(done)
			begin
				state_next = idle;
				count = 1;	//Salida activada en la transición 
			end
			end
	endcase
end

endmodule
