module adder_subber
#(parameter n=4)(
	input [(n-1):0] x,y_,
	input m,
	output [(n-1):0] s,
	output ovf
);
    wire [(n-1):0] y=y_^{n{m}} ;
    wire c; 
	assign ovf = x[n-1] & y[n-1] & ~c | ~x[n-1] & ~y[n-1] & c; 
    n_adder #(.n(n)) NA(
        .x(x),
        .y(y),
        .c_in(m),
        .s(s),
        .c_out(c)
    );
endmodule