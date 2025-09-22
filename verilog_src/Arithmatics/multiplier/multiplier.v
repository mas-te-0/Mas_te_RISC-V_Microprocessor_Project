module multiplier #(parameter n=4) (
    input  [(n-1):0] x, y,
    output reg [(n-1):0] r
);
    always @(*) begin
        r= x * y;
    end
endmodule