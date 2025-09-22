module n_adder
#(parameter n=4)(
	input [(n-1):0] x,y,
	input c_in,
	output [(n-1):0] s,
	output c_out
);
	wire [n:0]c;
	assign c[0]=c_in;
	assign c_out = c[n];
	generate
		genvar k;
		for (k = 0;k < n;k=k+1) begin:stage
			full_adder FA(
				.a(x[k]),
				.b(y[k]),
				.c_in(c[k]),
				.s(s[k]),
				.c_out(c[k+1])
			);
		end
	endgenerate
endmodule
