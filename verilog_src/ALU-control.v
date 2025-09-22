module ALU_control (
    input  [6:0] funct7,
    input  [2:0] funct3,
    input  [1:0] ALU_OP,
    output reg [3:0] OP,
    output reg [1:0] BR,data_type
);
    always @(*) begin

        OP= 4'b0000; 
        BR= 2'b00; 
        data_type=2'b00;

        case (ALU_OP)
            2'b00: begin                                              //R-instructions

                casex (funct3)
                    3'b000: 
                        if(funct7 == 7'b0000001)
                            OP=4'b0010;                             //mul
                        else if(funct7 == 7'b0100000)
                            OP=4'b0001;                             //sub
                            else
                                OP=4'b0000;                         //add

                    3'b100: 
                        if(funct7 == 7'b0000001)
                            OP=4'b0011;                             //div
                            else
                            OP=4'b0110;                             //xor

                    3'b110: 
                        if(funct7 == 7'b0000001)
                            OP=4'b0100;                             //rem
                            else
                            OP=4'b0101;                             //or

                    3'b111: 
                        OP=4'b0111;                                //and

                    3'b001: 
                        OP=4'b1000;                               //shl

                    3'b101: 
                        OP=4'b1001;                               //shr
                    3'b010: 
                        OP=4'b1010;                              //slt
                    default:OP=4'b0000;
                endcase
                end
            
            2'b01: begin                                           // L/S-instructions
                OP=4'b0000;                         //add
                case (funct3)
                    3'b010: data_type=2'b00;
                    3'b001: data_type=2'b01;
                    3'b000: data_type=2'b10;
                    default: data_type=2'b00;
                endcase
                end
            
            2'b10: begin                                           //B-instructions
                OP=4'b0001;                             //sub
                case (funct3)
                    3'b000:
                        BR= 2'b00; 
                    3'b001:
                        BR= 2'b01; 
                    3'b100:
                        BR= 2'b10; 
                    3'b101:
                        BR= 2'b11; 
                endcase
                end
            
            2'b11: begin                                           //J-instructions
                OP=4'b0000;                         //add
                end
        endcase
    end

endmodule
