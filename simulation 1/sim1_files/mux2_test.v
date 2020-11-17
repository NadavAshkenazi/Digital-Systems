// 4->1 multiplexer test bench template
module mux4_test;

// Put your code here
// ------------------

	//inputs
	reg D0;
	reg D1; 
	reg S; 
	
	//outputs
	wire Z;
	
	//instantiate the unit under test (UUT)
	mux2 uut (
		.d0(D0),
		.d1(D1),
		.s(S),
		.z(z)
	);
	
	
	//initialize all inputs
	initial begin
	D0 = 0;
	D1 = 0; 
	S = 0;
	#200;
	D0 = 1;  //end of 1st test 200
	#200  
	D0 = 0;  //end of 2nd test 400 
	#200
	S = 1;
	#200
	D1 = 1;  //end of 3rd test 800
	#200 
	D1 = 0;  //end of 4rh test 1000
	#200
	D0 = 1;
	#200
	S = 0;  //end of 5th test 1400
	#200 
	S = 1;  //end of 6th test 1600
	#200
	
	$finish;
	end
	


// End of your code

endmodule
