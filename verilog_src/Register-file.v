module Register_file(
    input  write_EN, clk, reset,
    input  [4:0]  read_address1, read_address2, write_address, 
    input  [31:0] write_data, 
    output [31:0] read_data1, read_data2 
);
    
    reg [31:0] Q [31:0];
    integer k;
    
    // Continuous assignments for reading
    assign read_data1 = Q[read_address1];
    assign read_data2 = Q[read_address2];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset all registers
            for (k = 0; k < 32; k = k + 1) begin
                Q[k] <= 32'b0;
            end
        end
        else begin
            // Always keep register x0 as zero
            Q[0] <= 32'b0;
            
            // Write to register if enabled and not writing to x0
            if (write_EN && (write_address != 5'b0)) begin
                Q[write_address] <= write_data;
            end
        end
    end
endmodule