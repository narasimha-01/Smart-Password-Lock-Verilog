`timescale 1ns/1ps
module lock_controller(
    input clk,
    input reset,
    input submit,
    input password_match,
    input limit_reached,
    input change_password,

    output reg unlock,
    output reg error,
    output reg locked,
    output reg write_password,
    output reg clear_attempts
);

localparam IDLE   = 3'b000;
localparam CHECK  = 3'b001;
localparam ACCESS = 3'b010;
localparam ERROR  = 3'b011;
localparam CHANGE = 3'b100;
localparam LOCKED = 3'b101;

reg [2:0] state;
reg [2:0] next_state;
reg change_mode;

always @(posedge clk) begin
    if(reset) begin
        state <= IDLE;
        change_mode <= 1'b0;
    end
    else begin
        state <= next_state;

        if(state == IDLE && submit)
            change_mode <= change_password;
    end
end

always @(*) begin

    next_state = state;

    case(state)

        IDLE: begin
            if(limit_reached)
                next_state = LOCKED;
            else if(submit)
                next_state = CHECK;
        end

        CHECK: begin
            if(password_match) begin
                if(change_mode)
                    next_state = CHANGE;
                else
                    next_state = ACCESS;
            end
            else
                next_state = ERROR;
        end

        ACCESS: next_state = IDLE;

        ERROR: begin
            if(limit_reached)
                next_state = LOCKED;
            else
                next_state = IDLE;
        end

        CHANGE: next_state = IDLE;

        LOCKED: next_state = LOCKED;

        default: next_state = IDLE;

    endcase
end

always @(*) begin

    unlock = 0;
    error = 0;
    locked = 0;
    write_password = 0;
    clear_attempts = 0;

    case(state)

        ACCESS: begin
            unlock = 1;
            clear_attempts = 1;
        end

        ERROR: begin
            error = 1;
        end

        CHANGE: begin
            write_password = 1;
            clear_attempts = 1;
        end

        LOCKED: begin
            locked = 1;
        end

    endcase
end

endmodule