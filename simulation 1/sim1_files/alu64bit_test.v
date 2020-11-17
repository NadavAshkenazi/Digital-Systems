// 64-bit ALU test bench template
module alu64bit_test;

// Put your code here
// ------------------
	
	// inputs
    reg  [63:0] a;
    reg  [63:0] b;
    reg  cin;
    reg  [1:0] op;
	
	// outputs
    wire [63:0] s;
	wire cout;

	
	// instantiate the unit under test (UUT)
	alu64bit uut (
			.a(a),
			.b(b),
			.cin(cin),
			.op(op),
			.s(s),
			.cout(cout)
	);
	
	// set all constant inputs for the s[63] output test
	initial begin
	a = 64'hFFFFFFFFFFFFFFFF;
	b = 64'hFFFFFFFFFFFFFFFF;
	cin = 2'b0;
	op = 2'b10;

	
	// change cin to 1
	#1500 cin = ~cin;
	#1500
	
	// set all constant inputs for the cout output test

		a = 64'h0000000000000000;
		b = 64'hFFFFFFFFFFFFFFFF;
		cin = 2'b0;
		op = 2'b10;
	
	// change cin to 1
	#1500 cin = ~cin;
	$finish;
	end
	
	
// End of your code

endmodule
