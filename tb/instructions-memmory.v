module instr_mem (
    input  [31:0]  address,
    output reg [31:0] instruction 
);

    reg [7:0] mem [0:32767]; // 32K × 8-bit memory
    
    integer i;

    // Truncate address to 15 bits for 32K memory
    wire [14:0] addr = address[14:0];

    always @(*) begin
        instruction = {mem[addr], mem[addr+1], mem[addr+2], mem[addr+3]};
    end
    
    initial begin
        $readmemh("E:/ECE/Verilog/RISC-V/bin.mem", mem);
    end

endmodule
