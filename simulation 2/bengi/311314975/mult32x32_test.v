// 32X32 Multiplier test template
module mult32x32_test;

    reg [31:0] a;        // Input a
    reg [31:0] b;        // Input b
    reg start;           // Start signal
    wire [63:0] product; // Miltiplication product
    wire valid;           // Operation valid indication

    reg clk;             // Clock
    reg reset;           // Reset
    wire [63:0] expected_product = 311314975*302361571;	

// Put your code here
//00000000000000100001000000000001
// ------------------
   initial begin 
	clk=0;
	start = 1'b0;
	a = 313326811;
	b = 205361199;
	reset = 1'b0;
	#10 reset = 1'b1;
	#5 reset = 1'b0;
	#35 start = 1'b1;
	//#100 start = 1'b0;
	
   end
   
   always begin 
	#50 clk = ~clk;
   end

mult32x32 uut(a,b,start,product,valid,clk,reset);
always @*
begin
if(expected_product == product)begin
	
	$display ("SUCCESS : %d = %d * %d ",product,a,b);
end
end


 
	
	
// End of your code

endmodule
