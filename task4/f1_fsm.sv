module f1_fsm (
    input   logic       rst,
    input   logic       en,
    input   logic       clk,
    input   logic       trigger,
    output  logic [7:0] data_out,
    output  logic       cmd_seq,
    output  logic       cmd_delay
);

// Define states
typedef enum { S0, S1, S2, S3, S4, S5, S6, S7, S8 } f1_fsm_state;
f1_fsm_state current_state, next_state;

// State transition
always_ff @(posedge clk) 
    if (rst) current_state <= S0;
    else begin
        if (current_state == S0) begin
            if (trigger) current_state <= next_state;
        end
        else begin
            if (en) current_state <= next_state;
        end
    end

// Next state logic
always_comb
    case (current_state)
        S0: next_state = S1;
        S1: next_state = S2;
        S2: next_state = S3;
        S3: next_state = S4;
        S4: next_state = S5;
        S5: next_state = S6;
        S6: next_state = S7;
        S7: next_state = S8;
        S8: next_state = S0;
        default: next_state = S0;
    endcase

// Output logic
always_comb
    case (current_state)
        S0: begin
            data_out = 8'b0;
            cmd_seq = 0;
            cmd_delay = 0;
        end

        S1: begin
            data_out = 8'b1;
            cmd_seq = 1;
            cmd_delay = 0;
        end

        S2: begin
            data_out = 8'b11;
            cmd_seq = 1;
            cmd_delay = 0;
        end

        S3: begin
            data_out = 8'b111;
            cmd_seq = 1;
            cmd_delay = 0;
        end

        S4: begin
            data_out = 8'b1111;
            cmd_seq = 1;
            cmd_delay = 0;
        end

        S5: begin
            data_out = 8'b11111;
            cmd_seq = 1;
            cmd_delay = 0;
        end

        S6: begin
            data_out = 8'b111111;
            cmd_seq = 1;
            cmd_delay = 0;
        end

        S7: begin
            data_out = 8'b1111111;
            cmd_seq = 1;
            cmd_delay = 0;
        end

        S8: begin
            data_out = 8'b11111111;
            cmd_seq = 0;
            cmd_delay = 1;
        end

        default: begin
            data_out = 8'b0;
                 cmd_seq = 0;
                 cmd_delay = 0;
        end
    endcase

endmodule
