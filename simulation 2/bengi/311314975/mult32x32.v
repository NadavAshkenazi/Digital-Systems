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

      // Product valid indication
wire  [1:0] a_sel;    // Select one byte from A
wire  b_sel;    // Select one 2-byte word from B
wire  [5:0] shift_val;// Shift value of 8-bit mult product
wire upd_prod;       // Update the product register
wire  clr_prod; 
 
mult32x32_fsm fs (valid,a_sel,b_sel,shift_val,upd_prod,clr_prod,start,clk,reset);

mult32x32_arith datapath(product,a,b,a_sel,b_sel,shift_val,upd_prod,clr_prod,clk,reset);

// End of your code

endmodule
