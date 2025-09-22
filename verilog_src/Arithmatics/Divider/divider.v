module divider #(parameter n=4) (
    input  [(n-1):0] x, y,
    output reg [(n-1):0] r, rem
);
    always @(*) begin
        r= x / y;
        rem = x%y;
    end
endmodule