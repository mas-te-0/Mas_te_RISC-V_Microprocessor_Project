module MUX_3x1
#(parameter n=4)(
    input [(n-1):0] w1,
    input [(n-1):0] w2,
    input [(n-1):0] w3,
    input [1 : 0]   s,
    output reg [(n-1):0] f
);

always @(*) begin
        casex (s)
            2'b11:
                f=w1; 
            2'b10:
                f=w2; 
            2'b01: 
                f=w2;
            2'b00: 
                f=w3;
        endcase
end

endmodule