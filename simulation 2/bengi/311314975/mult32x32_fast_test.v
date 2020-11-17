// 32X32 Multiplier test template
module mult32x32_fast_test;

    reg [31:0] a;        // Input a
    reg [31:0] b;        // Input b
    reg start;           // Start signal
    wire [63:0] product; // Miltiplication product
    wire valid;           // Operation valid indication

    reg clk;             // Clock
    reg reset;           // Reset
    wire [63:0] expected_product = 9325087*371683;		

// Put your code here
// ------------------
 initial begin 
	clk=0;
	start = 1'b0;
	a = 32'b00000000100011100100101000011111;
	b = 32'b00000000000001011010101111100011;
	reset = 1'b1;
	#10 reset = 1'b0;
	#40 start = 1'b1;
	//#10 start =1'b0;
	//#100 start = 1'b0;
	
   end
   
   always begin 
	#50 clk = ~clk;
   end

mult32x32_fast uut(a,b,start,product,valid,clk,reset);




always @*
begin
if(expected_product == product)begin
	
	$display ("SUCCESS : %d = %d * %d ",product,a,b);
end
end

 
// End of your code

endmodule
