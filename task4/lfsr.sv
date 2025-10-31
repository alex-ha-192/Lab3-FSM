module lfsr (
    input   logic       clk,
    output  logic [6:0] data_out
);

logic [7:1] sreg;

initial begin
    sreg = 7'b0000001;
end

always_ff @(posedge clk)
    sreg <= {sreg[6:1], sreg[3] ^ sreg[7]};

assign data_out = sreg;

endmodule
