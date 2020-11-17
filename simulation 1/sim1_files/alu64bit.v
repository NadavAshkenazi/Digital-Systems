// 64-bit ALU template
module alu64bit (
    input wire [63:0] a,    // Input bit a
    input wire [63:0] b,    // Input bit b
    input wire cin,         // Carry in
    input wire [1:0] op,    // Operation
    output wire [63:0] s,   // Output S
    output wire cout        // Carry out
);

// Put your code here
// ------------------

	//internal veriables 
		wire [63:0] m;
		
	//the first internal wire m[0] is connested to cin input
		assign cin = m[0];
		
	// instantiate the first ALU 
		alu1bit alu0(.a(a[0]),
					 .b(b[0]),
					 .cin(m[0]),
					 .op(op),
					 .s(s[0]),
					 .cout(m[1])
					 );
				 
	//the instaniation of the middle 62 ALUs
		genvar i;
		generate 
		for(i = 1; i < 63; i = i+1) begin
			alu1bit alui(.a(a[i]),
					 .b(b[i]),
					 .cin(m[i]),
					 .op(op),
					 .s(s[i]),
					 .cout(m[i+1])
					 );
		end		 
		endgenerate
		
	// intantiate the 63rd ALU
		alu1bit alu63(.a(a[63]),
				 .b(b[63]),
				 .cin(m[63]),
				 .op(op),
				 .s(s[63]),
				 .cout(cout)
				 );
		
// End of your code

endmodule
