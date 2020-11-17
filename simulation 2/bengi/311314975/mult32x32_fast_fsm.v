// 32X32 Multiplier FSM
module mult32x32_fast_fsm (
    output wire valid,          // Operation valid indication
    output reg  [1:0] a_sel,    // Select one byte from A
    output reg        b_sel,    // Select one 2-byte word from B
    output reg  [5:0] shift_val,// Shift value of 8-bit mult product
    output wire upd_prod,       // Update the product register
    output wire clr_prod,       // Clear the product register

    input wire start,           // Start signal
    input wire a_msb_is_0,      // Indicates MSB of operand A is 0
    input wire b_msw_is_0,      // Indicates MSB of operand B is 0
    input wire clk,             // Clock
    input wire rst              // Reset
);

reg clr_reg;
reg upd_p_reg;
reg valid_reg;
//reg a_msb_reg;
//reg b_msw_reg;

assign upd_prod=upd_p_reg;
assign clr_prod=clr_reg;
assign valid=valid_reg;
//assign a_msb_is_0=a_msb_reg;
//assign b_msw_is_0=b_msw_reg;


localparam A = 4'b0000; 
localparam B = 4'b0001;
localparam C = 4'b0010;
localparam D = 4'b0011;
localparam E = 4'b0100;
localparam F = 4'b0101;
localparam G = 4'b0110;
localparam H = 4'b0111;
localparam I = 4'b1000;
reg[0:3] current_state;
reg[0:3] next_state;


always @(posedge rst)
begin: asynch

	if(rst == 1'b1) begin
	
		current_state = A;
	end
end
always @(posedge clk)
begin: sync
	case(current_state)
		A:begin
			if(start == 0)begin
				next_state = A;
				a_sel=2'b00;
				b_sel=1'b0;
				shift_val=6'b000000;
				upd_p_reg=1'b0;
				clr_reg=1'b0;
				valid_reg=1'b1;
				current_state=next_state;
			end

			if(start == 1)begin
				next_state = B;
				a_sel=2'b00;
				b_sel=1'b0;
				shift_val=6'b000000;
				upd_p_reg=1'b0;
				clr_reg=1'b1;
				valid_reg=1'b1;
				current_state=next_state;
			end

		end
		B:begin
				next_state = C;
				a_sel=2'b00;
				b_sel=1'b0;
				shift_val=6'b000000;
				upd_p_reg=1'b1;
				clr_reg=1'b0;
				valid_reg=1'b0;
				current_state=next_state;
			end
		C:begin
				next_state = D;
				a_sel=2'b01;
				b_sel=1'b0;
				shift_val=6'b001000;
				upd_p_reg=1'b1;
				clr_reg=1'b0;
				valid_reg=1'b0;
				current_state=next_state;
			end
		D:begin
			 if((a_msb_is_0 == 0) && (b_msw_is_0 == 0)) begin
				next_state = A;
				a_sel=2'b10;
				b_sel=1'b0;
				shift_val=6'b010000;
				upd_p_reg=1'b1;
				clr_reg=1'b0;
				valid_reg=1'b0;
				current_state=next_state;
			     end

			
		


		
			 if((a_msb_is_0== 0) && (b_msw_is_0 == 1)) begin
				next_state = F;
				a_sel=2'b10;
				b_sel=1'b0;
				shift_val=6'b010000;
				upd_p_reg=1'b1;
				clr_reg=1'b0;
				valid_reg=1'b0;
				current_state=next_state;
			     end

			


		
			 if(a_msb_is_0== 1) begin
				next_state = E;
				a_sel=2'b10;
				b_sel=1'b0;
				shift_val=6'b010000;
				upd_p_reg=1'b1;
				clr_reg=1'b0;
				valid_reg=1'b0;
				current_state=next_state;
			     end

			end






		E:begin
			if(b_msw_is_0== 0)begin
				next_state = A;
				a_sel=2'b11;
				b_sel=1'b0;
				shift_val=6'b011000;
				upd_p_reg=1'b1;
				clr_reg=1'b0;
				valid_reg=1'b0;
				current_state=next_state;
                             end 			
			
			

		
			if(b_msw_is_0 == 1)begin
				next_state = F;
				a_sel=2'b11;
				b_sel=1'b0;
				shift_val=6'b011000;
				upd_p_reg=1'b1;
				clr_reg=1'b0;
				valid_reg=1'b0;
				current_state=next_state;
                             end 			
			
			end

		F:begin
				next_state = G;
				a_sel=2'b00;
				b_sel=1'b1;
				shift_val=6'b010000;
				upd_p_reg=1'b1;
				clr_reg=1'b0;
				valid_reg=1'b0;
				current_state=next_state;
			end

		G:begin
				next_state = H;
				a_sel=2'b01;
				b_sel=1'b1;
				shift_val=6'b011000;
				upd_p_reg=1'b1;
				clr_reg=1'b0;
				valid_reg=1'b0;
				current_state=next_state;
			end


		H:begin
			if(a_msb_is_0 == 0) 
				begin	
				next_state = A;
				a_sel=2'b10;
				b_sel=1'b1;
				shift_val=6'b100000;
				upd_p_reg=1'b1;
				clr_reg=1'b0;
				valid_reg=1'b0;
				current_state=next_state;
			end
		

	
		
			if((a_msb_is_0 == 1) && (b_msw_is_0 == 1)) 
				begin
				next_state = I;
				a_sel=2'b10;
				b_sel=1'b1;
				shift_val=6'b100000;
				upd_p_reg=1'b1;
				clr_reg=1'b0;
				valid_reg=1'b0;
				current_state=next_state;
			end
		end

		I:begin
				next_state = A;
				a_sel=2'b11;
				b_sel=1'b1;
				shift_val=6'b101000;
				upd_p_reg=1'b1;
				clr_reg=1'b0;
				valid_reg=1'b0;
				current_state=next_state;
			end
	
	endcase
	
			
end

// Put your code here
// ------------------
                
// End of your code

endmodule


