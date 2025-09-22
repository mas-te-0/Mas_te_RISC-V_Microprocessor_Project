module ALU (
    input reset,
    input  [31:0] A_ , B_,
    input [3:0] OP,
    output reg [31:0] result, 
    output zero, sign, ovf
);
    reg [31:0] A , B , R;    
    wire [31:0] AB_a_s , AB_or , AB_and , AB_xor , AB_mul , AB_div , AB_rem , AB_shl , AB_shr;
    reg cin;
    
    assign AB_or  = A | B;
    assign AB_and = A & B;
    assign AB_xor = A ^ B;
    assign AB_shl = A << B[4:0]; 
    assign AB_shr = A >> B[4:0];
    assign sign = result[31];
    assign zero = ~|result;


    adder_subber #(.n(32)) ADD_SUB (
        .x(A), 
        .y_(B), 
        .m(cin), 
        .s(AB_a_s), 
        .ovf(ovf)
        );

    multiplier #(.n(32)) MUL (
        .x(A), 
        .y(B), 
        .r(AB_mul)
        );

    divider #(.n(32)) DIV (
        .x(A), 
        .y(B), 
        .r(AB_div), 
        .rem(AB_rem)
        );


    always @(*) begin
        if (reset) begin
            A=0;
            B=0;
            result = 0;
        end

        else begin
            A =A_;
            B =B_;
            result = R;
        end
    end


    always @(*) begin

        R = 32'b0;
        cin = 1'b1;

        case (OP)

            4'b0000:begin // add
                cin = 1'b0; R= AB_a_s; 
            end
            
            4'b0001:begin // sub
                cin = 1'b1; R= AB_a_s; 
            end
            
            4'b0010: // mul
                R= AB_mul; 
            
            4'b0011: // div
                R= AB_div; 
            
            4'b0100: // rem
                R= AB_rem; 
            
            4'b0101: // or
                R= AB_or ; 
            
            4'b0110: // xor
                R= AB_xor; 
            
            4'b0111: // and
                R= AB_and; 
            
            4'b1000: // sh l
                R= AB_shl; 
            
            4'b1001: // sh r
                R= AB_shr; 
            
            4'b1010:begin // slt s
                cin = 1'b1; R =  ($signed(A) < $signed(B)) ? 32'b1 : 32'b0; 
            end
            
            default: 
                R =32'b0;
        endcase
    end
    
endmodule