// 32X32 Multiplier FSM
module mult32x32_fsm (
    output wire valid,          // Product valid indication
    output reg  [1:0] a_sel,    // Select one byte from A
    output reg        b_sel,    // Select one 2-byte word from B
    output reg  [5:0] shift_val,// Shift value of 8-bit mult product
    output wire upd_prod,       // Update the product register
    output wire clr_prod,       // Clear the product register

    input wire start,           // Start signal
    input wire clk,             // Clock
    input wire rst              // rst
);

// Put your code here
// ------------------
// local parameter
	localparam Re=4'b0000;
	localparam A=4'b0001;
	localparam B=4'b0010;
	localparam C=4'b0011;
	localparam D=4'b0100;
	localparam E=4'b0101;
	localparam F=4'b0110;
	localparam G=4'b0111;
	localparam H=4'b1000;
	
// internal variables
	reg [3:0] nxt_st;
	reg [3:0] crt_st;
	reg valid_reg, upd_reg, clr_reg;

//reg - wire connections
	assign valid = valid_reg;
	assign upd_prod = upd_reg;
	assign clr_prod = clr_reg;

 always @(posedge clk , posedge rst)
	begin
		if(rst==1'b1)begin
			crt_st <= Re;
			nxt_st <= Re;
			valid_reg=1'b1;	
			end

		else 
			crt_st <= nxt_st;
	end

	always@(*)
	begin
		case(crt_st)
			Re: begin
				if (start == 1'b1)begin
					nxt_st=A;
					upd_reg=1'b0;
					clr_reg=1'b1;
					valid_reg=1'b0;	
				end
				
				else begin 
				nxt_st=Re;
				upd_reg=1'b0;

				end
				
				end // end Re
			A: begin
					nxt_st=B;
					a_sel=2'b00;
					b_sel=1'b0;
					shift_val=6'b000000; //shift 0 bit to left
					upd_reg=1'b1;
					clr_reg=1'b0;
					valid_reg=1'b0;
					end // end A
			B: begin
					nxt_st=C;
					a_sel=2'b00;
					b_sel=1'b1;
					shift_val=6'b010000; //shift 16 bit to left
					upd_reg=1'b1;
					clr_reg=1'b0;
					valid_reg=1'b0;
					end // end B
			C: begin
					nxt_st=D;
					a_sel=2'b01;
					b_sel=1'b0;
					shift_val=6'b001000; //shift 8 bit to left
					upd_reg=1'b1;
					clr_reg=1'b0;
					valid_reg=1'b0;
					end // end C
			D: begin
					nxt_st=E;
					a_sel=2'b01;
					b_sel=1'b1;
					shift_val=6'b011000; //shift 24 bit to left
					upd_reg=1'b1;
					clr_reg=1'b0;
					valid_reg=1'b0;
					end // end D			
			E: begin
					nxt_st=F;
					a_sel=2'b10;
					b_sel=1'b0;
					shift_val=6'b010000; //shift 16 bit to left
					upd_reg=1'b1;
					clr_reg=1'b0;
					valid_reg=1'b0;
					end // end E
			F: begin
					nxt_st=G;
					a_sel=2'b10;
					b_sel=1'b1;
					shift_val=6'b100000; //shift 32 bit to left
					upd_reg=1'b1;
					clr_reg=1'b0;
					valid_reg=1'b0;
					end // end F
			G: begin
					nxt_st=H;
					a_sel=2'b11;
					b_sel=1'b0;
					shift_val=6'b011000; //shift 24 bit to left
					upd_reg=1'b1;
					clr_reg=1'b0;
					valid_reg=1'b0;
					end // end G
			H: begin
					nxt_st=Re;
					a_sel=2'b11;
					b_sel=1'b1;
					shift_val=6'b101000; //shift 40 bit to left
					upd_reg=1'b1;
					clr_reg=1'b0;
					valid_reg=1'b1;
					end // end H
			endcase
	end //end always               
// End of your code

endmodule

