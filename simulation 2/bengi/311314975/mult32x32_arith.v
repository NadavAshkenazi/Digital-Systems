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

reg [63:0]mult_t;
reg  [7:0] muxa;
reg [15:0] muxb;
reg [23:0] mult;
reg [63:0] shifter;
reg [63:0] adder;
always @(posedge clk)
begin: save_product
	if(clr_prod == 1)begin
		product[63:0] = 0;
	end
	if(upd_prod == 1)begin
		product[63:0] = adder[63:0]; 
	end	
	
end


always @(*)
begin: datapath
//-------------- mux a---------------//
	if(a_sel == 2'b00) begin
		  muxa = a[7:0];
	end
	if(a_sel == 2'b01) begin
		  muxa = a[15:8];
	end
	if(a_sel == 2'b10) begin
		  muxa = a[23:16];
	end
	if(a_sel == 2'b11) begin
		  muxa = a[31:24];
	end
//-------------- mux b---------------//
	if(b_sel == 1'b0)begin
		muxb = b[15:0];
	end
	if(b_sel == 1'b1) begin
		muxb = b[31:16];
	end

// ------------- multiplier ---------//

	assign mult_t = muxa*muxb;
	
//--------------- shifter -----------//
	
 	shifter = mult_t << shift_val;
	
//--------------- Adder ------------//
	adder = product + shifter;
	$display("%t : adder: %d = %d + %d", $time,adder, product, shifter);

end



// Put your code here
// ------------------


// End of your code

endmodule
