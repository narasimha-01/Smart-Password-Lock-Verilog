`timescale 1ns/1ps
module password_lock(

    input clk,
    input reset,

    input submit,
    input change_password,

    input [15:0] entered_password,
    input [15:0] new_password,

    input [1:0] status_select,

    output unlock,
    output error,
    output locked,

    output [1:0] attempts,
    output [3:0] status_data

);

wire password_match;
wire write_password;
wire clear_attempts;
wire limit_reached;
wire wrong_attempt;

wire [15:0] stored_password;
wire [3:0] status_inputs;


// Password comparison

password_comparator PC(

    .entered_password(entered_password),
    .stored_password(stored_password),
    .password_match(password_match)

);


// Password storage register

password_register PR(

    .clk(clk),
    .reset(reset),
    .write_enable(write_password),
    .new_password(new_password),
    .stored_password(stored_password)

);


// Wrong attempt counter

assign wrong_attempt = error;

attempt_counter AC(

    .clk(clk),
    .reset(reset),
    .wrong_attempt(wrong_attempt),
    .clear_counter(clear_attempts),
    .attempts(attempts),
    .limit_reached(limit_reached)

);


// FSM controller

lock_controller LC(

    .clk(clk),
    .reset(reset),
    .submit(submit),
    .password_match(password_match),
    .limit_reached(limit_reached),
    .change_password(change_password),

    .unlock(unlock),
    .error(error),
    .locked(locked),
    .write_password(write_password),
    .clear_attempts(clear_attempts)

);


// Status selection using 4:1 MUX

assign status_inputs = {
    1'b0,
    locked,
    error,
    unlock
};

mux_4to1 MUX(

    .data_in(status_inputs),
    .select(status_select),
    .data_out(status_data[0])

);

assign status_data[3:1] = 3'b000;

endmodule