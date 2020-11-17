// Full Adder/Subtractor test bench template
module fas_test;

// Put your code here
// ------------------
	
	//inputes 
		reg A;
		reg B; 
		reg CIN;
		reg A_NS;
		
	//outputs
		wire S;
		wire COUT;
		
	//instantiate the unit under test (UUT)
	fas uut (
		.a(A),
		.b(B),
		.cin(CIN),
		.a_ns(A_NS),
		.s(S),
		.cout(COUT)
	);
	
	
	//change A every 100ns
	always begin 
	#100 A = ~A;
	end
	
	//initialize all inputs. change A_NS after 800ns
	initial begin
	A = 0;
	B = 0;
	CIN = 0;
	A_NS = 0; 
	#800;
	A_NS = 1;
	#800;
	$finish;
	end
	
	//change B every 200ns
	always begin
	#200 B = ~B;
	end
	
	//change CIN every 400ns
	always begin
	#400 CIN = ~CIN;
	end

// End of your code

endmodule
