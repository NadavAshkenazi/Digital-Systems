// 1-bit ALU template
module alu1bit (
    input wire a,           // Input bit a
    input wire b,           // Input bit b
    input wire cin,         // Carry in
    input wire [1:0] op,    // Operation
    output wire s,          // Output S
    output wire cout        // Carry out
);

// Put your code here
// ------------------

// internal veriables
	wire m1;
	wire m2;
	wire m3;
	wire m4;
	wire m5; 
	wire m6;

// istantiate the first mux2	
	mux2 mx1(.d0(m2),
			 .d1(m1),
			 .s(op[0]),
			 .z(m3)
			);
			
// istantiate the second mux2	
	mux2 mx2(.d0(m3),
			 .d1(m4),
			 .s(op[1]),
			 .z(m5)
			);
			
// istantiate the only fas	
	fas fas1(.a(a),
			 .b(a),
			 .cin(cin),
			 .a_ns(op[0]),
			 .s(m4),
			 .cout(m6)
			);
			
// istantiate the only nand2
	NAND2 #(.Tpdlh(1), .Tpdhl(3)) 
		na2(.A(m1),
		  .B(m1),
		  .Z(m2)
		);
		
// instantiate the only xnor2
	XNOR2 #(.Tpdlh(6), .Tpdhl(8))
			xn1(.A(a),
			  .B(b),
			  .Z(m1)
			);			

//the second mux2 output is connected to the s output
	assign s = m5;

//the  fas output is connected to the cout output
	assign cout = m6;
	
// End of your code

endmodule
