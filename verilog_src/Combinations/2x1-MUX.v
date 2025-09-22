module MUX_2x1
#(parameter n=4)(
    input [(n-1):0] w1,
    input [(n-1):0] w2,
    input s,
    output reg [(n-1):0] f
);

always @(*) begin
        case (s)
            1'b0:
                f=w1; 
            1'b1: 
                f=w2;
        endcase
end

endmodule