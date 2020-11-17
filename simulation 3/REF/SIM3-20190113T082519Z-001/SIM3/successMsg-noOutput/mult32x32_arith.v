// 32X32 Multiplier arithmetic unit template
module mult32x32_arith (
    output reg [31:0] product, // Miltiplication product

    input wire [31:0] a,        // Input a
    input wire [31:0] b,        // Input b
    input wire [1:0] a_sel,     // Select one byte from A
    input wire [1:0] b_sel,     // Select one byte from B
    input wire [4:0] shift_val, // Shift value of 8-bit mult product
    input wire upd_prod,        // Update the product register
    input wire clr_prod,        // Clear the product register
    input wire clk,             // Clock
    input wire rst              // Reset
);

// Put your code here
// ------------------

//internal variables 
	reg [7:0] choosen_a;
	reg [7:0] choosen_b;
	reg [15:0] mult_res;
	reg [31:0] shift_res; //64->32

always @(posedge clk)
begin
	if(upd_prod==1'b1)
	begin
		//mux 
		case(a_sel) 
			2'b00: choosen_a=a[7:0];
			2'b01: choosen_a=a[15:8];
			2'b10: choosen_a=a[23:16];
			2'b11: choosen_a=a[31:24];
		endcase

		case(b_sel) 
			2'b00: choosen_b=b[7:0];
			2'b01: choosen_b=b[15:8];
			2'b10: choosen_b=b[23:16];
			2'b11: choosen_b=b[31:24];
		endcase
		
		mult_res=choosen_a*choosen_b;

		case(shift_val)
			5'd0: shift_res=mult_res;
			5'd8: shift_res=mult_res<<8;
			5'd16: shift_res=mult_res<<16;
			5'd24: shift_res=mult_res<<24;
/*			6'd32: shift_res=mult_res<<32;
			6'd40: shift_res=mult_res<<40;
			6'd48: shift_res=mult_res<<48;*/
		endcase
		
		product=shift_res+product;
		if(clr_prod==1'b1)
			product=32'd0; //64->32
	end //end if (upd_prod)
	else 
		product=32'd0; //64->32
end // end always

always @(posedge rst)
begin 
	choosen_a<=8'd0;
	choosen_b<=8'd0;
	mult_res<=16'd0;
	shift_res<=32'd0; //64->32
	product<=32'd0;	//64->32
end //end always
// End of your code

endmodule
