// 4->1 multiplexer test bench template
module mux4_test;

// Put your code here
// ------------------

	//inputs
	reg D0;
	reg D1; 
	reg D2; 
	reg D3;
	reg [1:0]S; 
	
	//outputs
	wire Z;
	
	//instantiate the unit under test (UUT)
	mux4 uut (
		.d0(D0),
		.d1(D1),
		.d2(D2),
		.d3(D3),
		.s(S),
		.z(z)
	);
	
	
	//initialize all inputs
	initial begin
	D0 = 0;
	D1 = 0;
	D2 = 0;
	D3 = 0; 
	S[0] = 0;
	S[1] = 0;
	#200;
	D0 = 1; //end 1st test 200
	#200
	S[0] = 1;
	#200  //end 2nd test 400
	S[1] = 1;
	#200
	S[1] = 0;
	#200  //end 3rd test 800
	S[1] = 1;
	#200  //end 4th test  1000
	
	$finish;
	end
	


// End of your code

endmodule
