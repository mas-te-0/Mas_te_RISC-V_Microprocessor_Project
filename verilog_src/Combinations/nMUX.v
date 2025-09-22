module nMUX
#(parameter n=4 , m=4)(
    input [ (n * m)-1 : 0 ] w,
    input [ $clog2 (n)-1 : 0 ] s,
    output reg [m-1:0] f
);

always @(w,s) begin
        f = w[s*m +: m];
end

endmodule