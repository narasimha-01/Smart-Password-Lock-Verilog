`timescale 1ns/1ps
module attempt_counter(
    input clk,
    input reset,
    input wrong_attempt,
    input clear_counter,
    output reg [1:0] attempts,
    output reg limit_reached
);

always @(posedge clk) begin
    if(reset) begin
        attempts <= 2'd0;
        limit_reached <= 1'b0;
    end
    else if(clear_counter) begin
        attempts <= 2'd0;
        limit_reached <= 1'b0;
    end
    else if(wrong_attempt && !limit_reached) begin
        if(attempts == 2'd2) begin
            attempts <= 2'd3;
            limit_reached <= 1'b1;
        end
        else begin
            attempts <= attempts + 1'b1;
        end
    end
end

endmodule