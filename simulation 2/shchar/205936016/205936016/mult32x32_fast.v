// 32X32 Iterative Multiplier template
module mult32x32_fast (
    input wire [31:0] a,        // Input a
    input wire [31:0] b,        // Input b
    input wire start,           // Start signal
    output wire [63:0] product, // Miltiplication product
    output wire valid,          // Operation valid indication

    input wire clk,             // Clock
    input wire reset            // Reset
);

// Put your code here
// ------------------
// internal variables
wire [5:0] shift_val; 
wire upd_prod;
wire clr_prod;
wire [1:0] a_sel;
wire b_sel;
reg  a_msb_is_0;    
reg b_msw_is_0;   

	always @(posedge clk) 
	begin
		if (a[31:24] == 8'b0) //checks if a_msb is zero
			a_msb_is_0 = 1'b1;

		else
			a_msb_is_0 = 1'b0;
			
			
		if (b[31:16] == 16'b0)//checks if b_msw is zero
			b_msw_is_0 = 1'b1;
		else
			b_msw_is_0 = 1'b0;
			
	end
	
mult32x32_arith math(.product(product),.a(a),.b(b),.a_sel(a_sel),.b_sel(b_sel),.shift_val(shift_val),.upd_prod(upd_prod),.clr_prod(clr_prod),.clk(clk),.rst(reset));
mult32x32_fast_fsm fast_fsm(.valid(valid),.a_sel(a_sel),.b_sel(b_sel),.a_msb_is_0(a_msb_is_0),.b_msw_is_0(b_msw_is_0),.shift_val(shift_val),.upd_prod(upd_prod),.clr_prod(clr_prod),.start(start),.clk(clk),.rst(reset));
// End of your code

endmodule
