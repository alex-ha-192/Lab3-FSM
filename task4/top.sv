module top(
    input logic [4:0] N,
    input logic cmd_seq_in,
    input logic rst,
    input logic clk,
    input logic cmd_delay_in,
    input logic trigger,
    output logic [7:0] data_out,
    output logic cmd_seq_out,
    output logic cmd_delay_out
);

logic tick_inner;
logic [6:0] K_inner;
logic time_out_inner;
logic mux_out;

clktick clktick (
    .N (N),
    .en (cmd_seq_in),
    .rst (rst),
    .clk (clk),
    .tick (tick_inner)
);

lfsr lfsr (
    .clk (clk),
    .data_out (K_inner)
);

delay delay (
    .n (K_inner),
    .trigger (cmd_delay_in),
    .rst (rst),
    .clk (clk),
    .time_out (time_out_inner)
);

f1_fsm f1_fsm (
    .rst (rst),
    .en (mux_out),
    .trigger (trigger),
    .clk (clk),
    .data_out (data_out),
    .cmd_seq (cmd_seq_out),
    .cmd_delay (cmd_delay_out)
);

// Implement MUX

always_comb begin
    if (cmd_seq_in == 1'b1)
        mux_out = tick_inner;
    else
        mux_out = time_out_inner;
end

endmodule
