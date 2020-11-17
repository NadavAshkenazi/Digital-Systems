// 32X32 Iterative Multiplier template
module mult32x32 (
    input wire [31:0] a,        // Input a
    input wire [31:0] b,        // Input b
    input wire start,           // Start signal
    output wire [63:0] product, // Miltiplication product
    output wire valid,          // Product valid indication

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
wire  b_sel;

mult32x32_arith math(.product(product),.a(a),.b(b),.a_sel(a_sel),.b_sel(b_sel),.shift_val(shift_val),.upd_prod(upd_prod),.clr_prod(clr_prod),.clk(clk),.rst(reset));
mult32x32_fsm fsm(.valid(valid),.a_sel(a_sel),.b_sel(b_sel),.shift_val(shift_val),.upd_prod(upd_prod),.clr_prod(clr_prod),.start(start),.clk(clk),.rst(reset));


// End of your code

endmodule
