module CU(
    input clk, reset,
    input [6:0] opcode,
    output reg [1:0] ALU_OP,
    output reg [2:0] mem_to_reg,
    output reg ALU_src, mem_read, mem_write, reg_write,PC_EN,
    output reg [1:0] branch
);

    // FSM state
    reg [2:0] state, next_state;

    // Sequential state update
    always @(posedge clk or posedge reset) begin
        if(reset) state <= 3'b000; // IF
        else state <= next_state;
    end

    // FSM next state logic
    always @(*) begin
        // Default next state
        next_state = 3'b000;
        case(state)
            3'b000: 
                next_state = 3'b001; // IF -> ID
            3'b001: begin  // ID
                case(opcode)
                    7'b0110011: 
                        next_state = 3'b010; // R-type -> EX
                    7'b0010011: 
                        next_state = 3'b010; // I-type
                    7'b0000011: 
                        next_state = 3'b010; // Load
                    7'b0100011: 
                        next_state = 3'b010; // Store
                    7'b1100011: 
                        next_state = 3'b010; // Branch
                    7'b1101111, 7'b1100111: 
                        next_state = 3'b010; // JAL/JALR
                    7'b0110111, 7'b0010111: 
                        next_state = 3'b010; // LUI/AUIPC
                    default: next_state = 3'b000;
                endcase
                end
            3'b010: begin  // EX
                case(opcode)
                    7'b0110011, 7'b0010011, 7'b0110111, 7'b0010111: 
                        next_state = 3'b000; // IF
                    7'b0100011: //s
                        next_state = 3'b000; // IF
                    7'b0000011: //s
                        next_state = 3'b011; // MEM
                    7'b1100011: 
                        next_state = 3'b000; // Branch -> back to IF
                    7'b1101111, 7'b1100111: 
                        next_state = 3'b000; // JAL/JALR need IF (write next PC)
                    default: next_state = 3'b000;
                endcase
                end
            3'b011:        //MEM
                next_state = 3'b000; // MEM -> IF (load)
                endcase
            end


    // Control signals logic
    always @(*) begin
        // Defaults
        ALU_OP     = 2'b00;
        ALU_src    = 0;
        mem_read   = 0;
        mem_write  = 0;
        reg_write  = 0;
        mem_to_reg = 3'b000;
        branch     = 2'b00;
        PC_EN = 1'b0;

        case(state)
            3'b000: begin // IF
            case(opcode)
                7'b1100011: begin
                    ALU_OP = 2'b10; 
                    branch = 2'b01; 
                    end

                7'b1100111:  begin  //JALR  
                    ALU_OP = 2'b11; 
                    branch = 2'b11; 
                    reg_write  = 1'b1;
                    mem_to_reg = 3'b010; // next_pc
                    end

                7'b1101111:  begin  // JAL
                    branch = 2'b10; 
                    reg_write  = 1'b1;
                    mem_to_reg = 3'b010; // next_pc
                    end
            endcase
                PC_EN = 1'b1;  // fetch instruction
                end

            3'b010: begin // EX
                case(opcode)
                    7'b0110011: begin 
                        ALU_OP = 2'b00; // R-type
                        reg_write  = 1'b1;
                        mem_to_reg = 3'b000; // ALU result
                    end
                    7'b0010011: begin 
                            ALU_OP = 2'b00; 
                            ALU_src = 1'b1; 
                            reg_write  = 1'b1;
                            mem_to_reg = 3'b000; // ALU result
                            end
                    7'b0000011: begin 
                            ALU_OP = 2'b01; 
                            ALU_src = 1'b1; 
                            // reg_write  = 1'b1;
                            mem_read = 1'b1;  // load
                            mem_to_reg = 3'b001; // RAM data
                            end
                    7'b0100011: begin 
                            ALU_OP = 2'b01; 
                            ALU_src = 1'b1; 
                            mem_write = 1'b1; // store
                            end
                    7'b1100011: begin
                        ALU_OP = 2'b10; 
                        branch = 2'b01; 
                        end
                    
                    7'b1100111:  begin  //JALR  
                        ALU_OP = 2'b11; 
                        branch = 2'b11; 
                        reg_write  = 1'b1;
                        mem_to_reg = 3'b010; // next_pc
                    end

                    7'b1101111:  begin  // JAL
                        branch = 2'b10; 
                        reg_write  = 1'b1;
                        mem_to_reg = 3'b010; // next_pc
                        end

                    7'b0110111: begin 
                            ALU_OP = 2'b11; 
                            reg_write  = 1'b1;
                            mem_to_reg = 3'b011; // immediate (upper imm)
                            end
                    7'b0010111: begin 
                            ALU_OP = 2'b11; 
                            reg_write  = 1'b1;
                            mem_to_reg = 3'b100; // PC + immediate
                            end
                endcase
                end

            3'b011: begin // MEM
                    ALU_OP = 2'b01;
                    ALU_src = 1'b1; 
                    reg_write  = 1'b1;
                    mem_to_reg = 3'b001; // RAM data
                end
        
        endcase
    end

endmodule
