module full_adder (
    input a, b, c_in,
    output s, c_out
);
    wire c1, s1, c2;
    half_adder ha1(a, b, s1, c1);
    half_adder ha2(c_in, s1, s, c2);
    assign c_out = c1 | c2;
endmodule
