// Full Adder/Subtractor template
module fas (
    input wire a,           // Input bit a
    input wire b,           // Input bit b
    input wire cin,         // Carry in
    input wire a_ns,        // A_nS (add/not subtract) control
    output wire s,          // Output S
    output wire cout        // Carry out
);

// Put your code here
// ------------------
	
	//internal veriables 
		wire m1;
		wire m2;
		wire m3; 
		wire m4; 
		wire m5;
		wire m6;
		wire m7;
		
	
	
	// istantiate the first nand2
	NAND2 #(.Tpdlh(1), .Tpdhl(3)) 
		na1(.A(b),
		  .B(cin),
		  .Z(m3)
		);
		
	// istantiate the second nand2
	NAND2 #(.Tpdlh(1), .Tpdhl(3)) 
		na2(.A(m4),
		  .B(m5),
		  .Z(m6)
		);
		
	// istantiate the third nand2
	NAND2 #(.Tpdlh(1), .Tpdhl(3)) 
		na3(.A(m3),
		  .B(m6),
		  .Z(m7)
		);
		
	// instantiate the first xnor2
	XNOR2 #(.Tpdlh(6), .Tpdhl(8))
			xn1(.A(a),
			  .B(cin),
			  .Z(m1)
			);
			
	// instantiate the first xnor2
	XNOR2 #(.Tpdlh(6), .Tpdhl(8))
			xn2(.A(m1),
			  .B(b),
			  .Z(m2)
			);
			
	// instantiate the first xnor2
	XNOR2 #(.Tpdlh(6), .Tpdhl(8))
			xn3(.A(a),
			  .B(a_ns),
			  .Z(m5)
			);
			
	// instantiate the only or2
	OR2 #(.Tpdlh(3), .Tpdhl(2))
			or1(.A(b),
			  .B(cin),
			  .Z(m4)
			);
			
	//the fifth nand output is connected to the cout output
	assign cout = m7;

	//the second nand output is connected to the S output
	assign s = m2;
	
// End of your code

endmodule
