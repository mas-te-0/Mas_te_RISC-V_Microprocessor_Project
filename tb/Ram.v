module ram(
    input clk,
    input write_EN,
    input read_EN,
    input [1:0] data_type,
    input [31:0] address,
    input [31:0] write_data,
    output reg [31:0] read_data
);

    reg [7:0] mem [0:4095]; // 4K bytes memory

    // Truncate address to 12 bits for 4K memory
    wire [11:0] addr = address[11:0];

    // Sequential write
    always @(posedge clk) begin
        if(write_EN) begin
            case(data_type)
                2'b00: begin // word
                    mem[addr]   <= write_data[7:0];
                    mem[addr+1] <= write_data[15:8];
                    mem[addr+2] <= write_data[23:16];
                    mem[addr+3] <= write_data[31:24];
                end
                2'b01: begin // halfword
                    mem[addr]   <= write_data[7:0];
                    mem[addr+1] <= write_data[15:8];
                end
                2'b10: begin // byte
                    mem[addr]   <= write_data[7:0];
                end
            endcase
        end
    end

    // Sequential read (output updates on clk edge)
    always @(posedge clk) begin
        if(read_EN) begin
            case(data_type)
                2'b00: read_data <= {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
                2'b01: read_data <= {16'b0, mem[addr+1], mem[addr]};
                2'b10: read_data <= {24'b0, mem[addr]};
                default: read_data <= 32'b0;
            endcase
        end else begin
            read_data <= 32'b0; // optional: clear when not reading
        end
    end

endmodule
