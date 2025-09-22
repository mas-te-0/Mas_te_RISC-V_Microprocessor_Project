module Branch_unit (
    input zero , sign,ovf,
    input [1:0] BR_control,
    output reg Branch 
);
    always @(*) begin
        case (BR_control)
            2'b00: Branch <= zero;                   //  ==
            2'b01: Branch <=!zero;                   // != 
            2'b10: Branch <= sign ^ ovf;             // <
            2'b11: Branch <= !(sign ^ ovf);          // >=
            default: Branch <= 1'b0;
        endcase
    end
endmodule