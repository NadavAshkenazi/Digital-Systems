// 4->1 multiplexer template
module mux4 (
    input wire d0,          // Data input 0
    input wire d1,          // Data input 1
    input wire d2,          // Data input 2
    input wire d3,          // Data input 3
    input wire [1:0] s,   // Select input
    output wire z           // Output
);

// Put your code here
// ------------------

	// internal veriables
		wire m1;
		wire m2;
		
	// istantiate the first mux2	
	mux2 mx1(.d0(d0),
			 .d1(d1),
			 .s(s[0]),
			 .z(m1)
			);
			
	// istantiate the second mux2	
	mux2 mx2(.d0(d2),
			 .d1(d3),
			 .s(s[0]),
			 .z(m2)
			);
			
	// istantiate the third mux2	
	mux2 mx3(.d0(m1),
			 .d1(m2),
			 .s(s[1]),
			 .z(z)
			);
	

// End of your code

endmodule
