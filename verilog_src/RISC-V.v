module RISC_V (
    input  clk,
    input  reset,
    input  [31:0] instructions,
    input  [31:0] ram_data_in,
    output [31:0] PC_current,
    output RAM_write,RAM_read,
    output [1:0]  data_type,
    output [31:0] ram_address,
    output [31:0] ram_data_out
);

    // --- PC ---
    wire [31:0] PC_next, next_address, imm_address;
    wire PC_EN;
    // --- Instruction ---
    // wire [31:0] instructions;
    wire [6:0] opcode = instructions[6:0];
    wire [6:0] funct7 = instructions[31:25];
    wire [2:0] funct3 = instructions[14:12];
    wire [4:0] read_address1 = instructions[19:15];
    wire [4:0] read_address2 = instructions[24:20];
    wire [4:0] write_address = instructions[11:7];

    // --- Immediate ---
    wire [31:0] immediate;

    // --- Register File ---
    wire [31:0] read_data1, read_data2;
    wire [31:0] reg_data;
    wire [2:0] reg_sel;
    wire reg_write;

    // --- ALU ---
    wire [31:0] ALU_result;
    wire ALU_zero, ALU_sign, ALU_ovf;
    wire [31:0] ALU_src_data;
    wire [3:0] OP;
    wire [1:0] ALU_OP;

    // --- RAM ---
    wire [31:0] ram_data;
    // --- Branch ---
    wire [1:0] CU_branch;
    wire BU_branch;
    wire [1:0] branch_op;


    // ---------------------------
    // Program Counter
    // ---------------------------
    PC PC_unit (
        .clk(clk),
        .PC_EN(PC_EN),
        .reset(reset),
        .branch_offset(immediate),
        .Q_next(PC_next),
        .address(PC_current),
        .next_address(next_address),
        .imm_address(imm_address)
    );

    // ---------------------------
    // Branch Unit
    // ---------------------------
    Branch_unit Branch_Unit (
        // .clk(clk),
        .zero(ALU_zero), 
        .sign(ALU_sign),
        .ovf(ALU_ovf),
        .BR_control(branch_op),
        .Branch(BU_branch)
    );

    // ---------------------------
    // PC MUX (next PC selection)
    // ---------------------------
    MUX_3x1 #(.n(32)) PC_MUX (
        .w1(ALU_result),
        .w2(imm_address),
        .w3(next_address),
        .s({CU_branch[1], CU_branch[0] & BU_branch}),
        .f(PC_next)
    );



    // ---------------------------
    // Immediate Generator
    // ---------------------------
    imm_gen immediate_generator (
        .instructions(instructions),
        .immediate(immediate)
    );

    // ---------------------------
    // Register File
    // ---------------------------
    Register_file Register_File (
        .clk(clk),
        .reset(reset),
        .write_EN(reg_write),
        .read_address1(read_address1),
        .read_address2(read_address2),
        .write_address(write_address),
        .write_data(reg_data),
        .read_data1(read_data1),
        .read_data2(read_data2)
    );

    // ---------------------------
    // Register Write MUX (5x1)
    // ---------------------------
    MUX_5x1 #(.n(32)) Mux5 (
        .w1(ALU_result),
        .w2(ram_data),
        .w3(next_address),
        .w4(immediate),
        .w5(imm_address),
        .s(reg_sel),
        .f(reg_data)
    );


    // ---------------------------
    // ALU Source MUX (2x1)
    // ---------------------------
    MUX_2x1 #(.n(32)) ALU_Src (
        .w1(read_data2),
        .w2(immediate),
        .s(ALU_src),
        .f(ALU_src_data)
    );

    // ---------------------------
    // ALU
    // ---------------------------
    ALU ALU_unit (
        .reset(reset),
        .A_(read_data1),
        .B_(ALU_src_data),
        .OP(OP),
        .result(ALU_result),
        .zero(ALU_zero),
        .sign(ALU_sign),
        .ovf(ALU_ovf)
    );


    // ---------------------------
    // ALU Control
    // ---------------------------
    ALU_control ALU_Control (
        .funct7(funct7),
        .funct3(funct3),
        .ALU_OP(ALU_OP),
        .OP(OP),
        .BR(branch_op),
        .data_type(data_type)
    );

    // ---------------------------
    // Control Unit
    // ---------------------------
    CU CU_unit (
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .PC_EN(PC_EN),
        .ALU_OP(ALU_OP),
        .mem_to_reg(reg_sel),
        .ALU_src(ALU_src),
        .mem_read(RAM_read),
        .mem_write(RAM_write),
        .reg_write(reg_write),
        .branch(CU_branch)
    );
    
     assign ram_data= ram_data_in;
     assign ram_data_out = read_data2;
     assign ram_address = ALU_result;

endmodule
