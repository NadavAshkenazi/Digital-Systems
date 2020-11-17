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


wire [1:0] a_sel;
wire b_sel;
wire [5:0]shift_val;
wire upd_prod;
wire clr_prod;

wire a_msb_is_0;
wire b_msw_is_0;


//reg [31:0] zero = 0;


assign a_msb_is_0 =(a[31:24]==8'b00000000)? 0:1;
assign b_msw_is_0 = (b[31:16]==16'b0000000000000000)? 0:1;




mult32x32_fast_fsm ffs (valid,a_sel,b_sel,shift_val,upd_prod,clr_prod,start,a_msb_is_0,b_msw_is_0,clk,reset);
mult32x32_arith datapath(product,a,b,a_sel,b_sel,shift_val,upd_prod,clr_prod,clk,reset);

// End of your code

endmodule
