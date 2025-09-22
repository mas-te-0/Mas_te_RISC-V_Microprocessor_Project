module n_P_Register
#(parameter n=4 )(
    input  clk, reset,EN,
    input  [n-1:0] I,
    output [n-1:0]Q
);   
    reg [n-1:0] Q_reg;

    assign Q = Q_reg;

    always @(posedge clk or posedge reset) begin
        if(reset)
            Q_reg <= {n{1'b0}};
        else if(EN)
            Q_reg<= I;
    end

endmodule