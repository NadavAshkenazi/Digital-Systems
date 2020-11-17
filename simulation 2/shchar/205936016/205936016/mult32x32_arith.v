// 32X32 Multiplier arithmetic unit template
module mult32x32_arith (
    output reg [63:0] product, // Miltiplication product

    // Multiplier controls
    input wire [31:0] a,        // Input a
    input wire [31:0] b,        // Input b
    input wire [1:0] a_sel,     // Select one byte from A
    input wire       b_sel,     // Select one 2-byte word from B
    input wire [5:0] shift_val, // Shift value of 8-bit mult product
    input wire upd_prod,        // Update the product register
    input wire clr_prod,        // Clear the product register
    input wire clk,             // Clock
    input wire rst              // Reset
);

// Put your code here
// ------------------

//internal variables 
	reg [7:0] part_of_a;
	reg [15:0] part_of_b;
	reg [23:0] mult_res;
	reg [63:0] shifter_res;
	reg [63:0] prev_prod=64'b0;

always @(posedge clk)
begin
	if(upd_prod==1'b1)
	begin
		//mux 4>1
		case(a_sel) 
		  2'b00: part_of_a=a[7:0];
		  2'b01: part_of_a=a[15:8];
		  2'b10: part_of_a=a[23:16];
		  2'b11: part_of_a=a[31:24];
		endcase
		
		//mux 2>1
		case(b_sel) 
		  1'b0: part_of_b=b[15:0];
		  1'b1: part_of_b=b[31:16];
		endcase
		
		//multiplier
		mult_res=part_of_a*part_of_b;
		
		//shifter
		case(shift_val)
		  6'd0: shifter_res=mult_res;
		  6'd8: shifter_res=mult_res<<8;
		  6'd16: shifter_res=mult_res<<16;
		  6'd24: shifter_res=mult_res<<24;
		  6'd32: shifter_res=mult_res<<32;
		  6'd40: shifter_res=mult_res<<40;
		endcase
		
		//64 bit adder
		product=shifter_res+prev_prod;
		prev_prod=product;
		
	end //end if upd_prod
	
	else begin //in case upd_prod != 1
		prev_prod=64'd0;	
		
	    end
		
	if(clr_prod==1'b1) begin
		product=64'd0;
	end
		
end // end always

always @(posedge rst)
begin 
	part_of_a=8'd0;
	part_of_b=16'd0;
	mult_res=24'd0;
	shifter_res=64'd0;
	product=64'd0;
	prev_prod=64'd0;
end //end always

// End of your code

endmodule
