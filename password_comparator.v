`timescale 1ns/1ps
module password_comparator(
    input [15:0] entered_password,
    input [15:0] stored_password,
    output password_match
);

assign password_match =
    (entered_password == stored_password);

endmodule