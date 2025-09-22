module MUX_5x1
#(parameter n=4)(
    input [(n-1):0] w1,
    input [(n-1):0] w2,
    input [(n-1):0] w3,
    input [(n-1):0] w4,
    input [(n-1):0] w5,
    input [2 : 0]   s,
    output reg [(n-1):0] f
);

always @(*) begin
        casex (s)
            3'b000:
                f=w1; 

            3'b001: 
                f=w2;

            3'b010: 
                f=w3;

            3'b011: 
                f=w4;
                
            3'b1xx: 
                f=w5;
        endcase
end

endmodule