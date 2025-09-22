module imm_gen (
    input  [31:0] instructions,
    output reg [31:0] immediate
);
    wire [6:0] OP;
    assign OP = instructions [6:0];

    always @(*) begin

        immediate = 32'b0;
        case (OP)
            7'b0010011,7'b0000011:begin // I-type:
                immediate[11:0] = instructions [31:20];
                immediate[31:12] = {20{immediate[11]}};
            end

            7'b0100011:begin // S-type:
                immediate[11:0] = {instructions [31:25],instructions [11:7]};
                immediate[31:12] = {20{immediate[11]}};
            end

            7'b1100011:begin // B-type:
                immediate[12:0] = {instructions [31],instructions [7],instructions [30:25],instructions [11:8],1'b0};
                immediate[31:13]={19{immediate[12]}};
            end

            7'b1101111,7'b1100111:begin // J-type:
                immediate[20:0] = {instructions [31],instructions [19:12],instructions [20],instructions [30:21],1'b0};
                immediate[31:12]={20{immediate[20]}};
            end
            
            7'b0110111:begin // U-type:
                immediate[31:12] = {instructions [31:12]};
            end



            default: immediate = 32'b0;
        endcase
    end
endmodule