`timescale 1ns/1ps
module password_register(
    input clk,
    input reset,
    input write_enable,
    input [15:0] new_password,
    output reg [15:0] stored_password
);

always @(posedge clk) begin
    if(reset)
        stored_password <= 16'h1234;
    else if(write_enable)
        stored_password <= new_password;
end

endmodule