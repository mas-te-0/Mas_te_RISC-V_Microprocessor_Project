module tb_RISC_V;
    parameter t = 10;
    reg clk, reset;

    // Instantiate the CPU

    wire [31:0] instructions,PC_current,ram_address,ram_data_in,ram_data_out;
    wire RAM_write,RAM_read;
    wire [1:0]  data_type;

    RISC_V RISC_V (
    .clk(clk),
    .reset(reset),
    .instructions(instructions),
    .ram_data_in(ram_data_in),
    .PC_current(PC_current),
    .RAM_write(RAM_write),
    .RAM_read(RAM_read),
    .data_type(data_type),
    .ram_address(ram_address),
    .ram_data_out(ram_data_out)
    );

    instr_mem Memory (
        .address(PC_current),
        .instruction(instructions)
    );


    ram Ram (
    .clk(clk),
    .write_EN(RAM_write),
    .read_EN(RAM_read),
    .data_type(data_type),
    .address(ram_address),
    .write_data(ram_data_out),
    .read_data (ram_data_in)
    );


    // Clock generation: 100 MHz (period = 10ns)
    always begin
        clk = 1'b0; #(t/2);
        clk = 1'b1; #(t/2);
    end

    // initial begin
    //     #(2000*t) $finish;
    // end

    initial begin
    reset = 1;
    # (t);   // keep reset high for some cycles
    reset = 0;
end


endmodule
