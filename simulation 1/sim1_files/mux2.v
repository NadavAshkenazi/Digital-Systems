// 2->1 multiplexer template
module mux2 (
    input wire d0,          // Data input 0
    input wire d1,          // Data input 1
    input wire s,         // Select input
    output wire z           // Output
);
	
// Put your code here
// ------------------

	// internal veriables
	wire n1;
	wire n2;
	wire n3;

	
	// istantiate the first nand2
	NAND2 #(.Tpdlh(3), .Tpdhl(1)) 
			na1(.A(d1),
			  .B(s),
			  .Z(n1)
			);
			
	// istantiate the second nand2
	NAND2 #(.Tpdlh(3), .Tpdhl(1)) 
			na2(.A(s),
			  .B(s),
			  .Z(n2)
			);	
			
	// istantiate the third nand2
	NAND2 #(.Tpdlh(3), .Tpdhl(1)) 
			na3(.A(n2),
			  .B(d0),
			  .Z(n3)
			);
			
	// istantiate the fourth nand2
	NAND2	 #(.Tpdlh(3), .Tpdhl(1)) 
			na4(.A(n1),
			  .B(n3),
			  .Z(z)
			);
			
// End of your code

endmodule
