module nDEMUX
#(parameter n=4 , m=4)(
    input [ $clog2 (n)-1 : 0 ] s,
    input [m-1:0] f,
    output reg [ (n * m)-1 : 0 ] w
);

always @(f,s) begin
        w = { (n*m){1'b0} };
        w[s*m +: m] = f;
end

endmodule