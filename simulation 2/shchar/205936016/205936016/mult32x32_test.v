// 32X32 Multiplier test template
module mult32x32_test;

    reg [31:0] a;        // Input a
    reg [31:0] b;        // Input b
    reg start;           // Start signal
    wire [63:0] product; // Miltiplication product
    wire valid;           // Operation valid indication

    reg clk;             // Clock
    reg reset;           // Reset

// Put your code here
// ------------------

reg [63:0] expected_product;

// Gate instantiations
mult32x32 uut (.a(a),.b(b),.start(start),.product(product),.valid(valid),.clk(clk),.reset(reset));

initial begin 
	clk=1'b1;
	start=1'b0;
	reset=1'b1;
	a=32'd205936016;
	b=32'd205989510;
	assign expected_product=a*b;
	repeat (1) @(posedge clk);  
	reset=1'b0;
	repeat (1) @(posedge clk);  
	start=1'b1;
	
$display ("%t ", $time);
	end
	
always begin
	#50 clk=~clk;

end



always @(*) begin

	if(product==expected_product)
			$display ("%t : SUCCESS: %d = %d * %d", $time, product , a , b);
end



// End of your code

endmodule
