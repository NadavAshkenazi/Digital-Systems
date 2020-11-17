// 32X32 Multiplier test template
module mult32x32_fast_test;

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
mult32x32_fast uut (.a(a),.b(b),.start(start),.product(product),.valid(valid),.clk(clk),.reset(reset));


initial begin 
	assign expected_product=a*b;
	clk=1'b1;
	start=1'b0;
	reset=1'b1;
	a=32'd205936016;
	b=32'd205989510;
	repeat (1) @(posedge clk);  
	reset=1'b0;
	repeat (1) @(posedge clk);  
	$display ("%t : a_msb_is_0=0, b_sw_is_0=0", $time);
	start=1'b1;	
	
	repeat (10) @(posedge clk);  
	reset=1'b1;
	start=1'b0;
	a=32'b00000000010001100101010110010000;
	b=32'b00000000000000000010011010000110;
	repeat (1) @(posedge clk);  
	reset=1'b0;
	repeat (1) @(posedge clk);  	
	$display ("%t : a_msb_is_0=1, b_sw_is_0=1", $time);
	start=1'b1;
	
	
	// extra tests
	
	repeat (5) @(posedge clk);  
	reset=1'b1;
	start=1'b0;
	a=32'b00000000010001100101010110010000;
	b=32'd205989510;
	repeat (1) @(posedge clk);  
	reset=1'b0;
	repeat (1) @(posedge clk);  	
	$display ("%t : a_msb_is_0=1, b_sw_is_0=0", $time);
	start=1'b1;
	
	repeat (8) @(posedge clk);  
	reset=1'b1;
	start=1'b0;
	a=32'd205936016;
	b=32'b00000000000000000010011010000110;
	repeat (1) @(posedge clk);  
	reset=1'b0;
	repeat (1) @(posedge clk);  	
	$display ("%t : a_msb_is_0=0, b_sw_is_0=1", $time);
	start=1'b1;
	
	end
	
always begin
	#50 clk=~clk;

end



always @(product) begin

	if(product==expected_product)
			$display ("%t : SUCCESS: %d = %d * %d", $time, product , a , b);
end


// End of your code

endmodule
