module PC(
    input  clk, reset,PC_EN,
    input  [31:0] branch_offset, Q_next,
    output [31:0] address, next_address, imm_address
);

    wire cout1, cout2;

    n_P_Register #(.n(32)) PC_reg(
        .clk(clk),
        .reset(reset),
        .EN(PC_EN),
        .I(Q_next),
        .Q(address)
    );   
    
    n_adder #(.n(32)) Adder2(
        .x(address), 
        .y(32'd4),
        .c_in(1'b0),
        .s(next_address),
        .c_out(cout1)
    );

    n_adder #(.n(32)) Adder1(
        .x(address), 
        .y(branch_offset << 1),
        .c_in(1'b0),
        .s(imm_address),
        .c_out(cout2)
    );

endmodule
