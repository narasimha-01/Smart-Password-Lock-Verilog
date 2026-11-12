
`timescale 1ns/1ps

module tb_password_lock;

reg clk;
reg reset;
reg submit;
reg change_password;

reg [15:0] entered_password;
reg [15:0] new_password;
reg [1:0] status_select;

wire unlock;
wire error;
wire locked;
wire [1:0] attempts;
wire [3:0] status_data;

integer pass_count;
integer fail_count;

reg previous_locked;


// DUT INSTANTIATION

password_lock DUT (
    .clk(clk),
    .reset(reset),
    .submit(submit),
    .change_password(change_password),
    .entered_password(entered_password),
    .new_password(new_password),
    .status_select(status_select),
    .unlock(unlock),
    .error(error),
    .locked(locked),
    .attempts(attempts),
    .status_data(status_data)
);


// CLOCK GENERATION: 10 ns

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end


// SELF-CHECKING TASK

task check_result;
    input condition;
    input [8*100-1:0] message;

    begin
        if (condition) begin
            pass_count = pass_count + 1;
            $display("PASS: %0s | Time=%0t",
                     message, $time);
        end
        else begin
            fail_count = fail_count + 1;
            $display("FAIL: %0s | Time=%0t",
                     message, $time);
        end
    end
endtask


// PASSWORD SUBMISSION TASK

task attempt_password;
    input [15:0] password;
    input expected_success;
    input [8*100-1:0] message;

    begin

        @(negedge clk);

        entered_password = password;
        submit = 1'b1;

        if (expected_success)
            status_select = 2'b00;
        else
            status_select = 2'b01;

        // IDLE -> CHECK

        @(negedge clk);
        submit = 1'b0;

        // CHECK -> ACCESS / ERROR

        @(posedge clk);
        #1;

        if (expected_success) begin

            check_result(
                unlock && !error && !locked,
                message
            );

            check_result(
                status_data[0] == 1'b1,
                "MUX selects UNLOCK signal"
            );

        end
        else begin

            check_result(
                error && !unlock && !locked,
                message
            );

            check_result(
                status_data[0] == 1'b1,
                "MUX selects ERROR signal"
            );

        end

        // ACCESS / ERROR -> IDLE

        @(negedge clk);

        // Allow counter update

        @(posedge clk);
        #1;

    end
endtask


// PASSWORD CHANGE TASK

task change_existing_password;

    begin

        @(negedge clk);

        entered_password = 16'h1234;
        new_password = 16'hABCD;

        change_password = 1'b1;
        submit = 1'b1;

        // IDLE -> CHECK

        @(negedge clk);

        submit = 1'b0;
        change_password = 1'b0;

        // CHECK -> CHANGE

        @(posedge clk);
        #1;

        check_result(
            unlock == 1'b0 &&
            error == 1'b0 &&
            locked == 1'b0,
            "Authenticated password change requested"
        );

        // CHANGE -> IDLE
        // Password register updates on this edge

        @(posedge clk);
        #1;

        check_result(
            attempts == 2'd0,
            "Password change clears attempt counter"
        );

    end
endtask


// ASSERTION MONITOR

always @(posedge clk) begin

    #1;

    if (reset) begin
        previous_locked = 1'b0;
    end
    else begin

        if (unlock && error) begin
            fail_count = fail_count + 1;
            $display(
                "ASSERTION FAILED: UNLOCK and ERROR both HIGH"
            );
        end

        if (unlock && locked) begin
            fail_count = fail_count + 1;
            $display(
                "ASSERTION FAILED: UNLOCK and LOCKED both HIGH"
            );
        end

        if (error && locked) begin
            fail_count = fail_count + 1;
            $display(
                "ASSERTION FAILED: ERROR and LOCKED both HIGH"
            );
        end

        if (previous_locked && !locked) begin
            fail_count = fail_count + 1;
            $display(
                "ASSERTION FAILED: Lockout exited without reset"
            );
        end

        previous_locked = locked;

    end
end


// MAIN TEST SEQUENCE

initial begin

    pass_count = 0;
    fail_count = 0;
    previous_locked = 0;

    reset = 1'b1;
    submit = 1'b0;
    change_password = 1'b0;

    entered_password = 16'h0000;
    new_password = 16'h0000;
    status_select = 2'b00;

    $display("");
    $display("========================================");
    $display(" SMART PASSWORD LOCK - TESTBENCH");
    $display("========================================");

    // INITIAL RESET

    repeat (3) @(negedge clk);

    reset = 1'b0;

    // TEST 1: DEFAULT PASSWORD

    attempt_password(
        16'h1234,
        1'b1,
        "Default password accepted"
    );

    // TEST 2: WRONG PASSWORD

    attempt_password(
        16'h5678,
        1'b0,
        "Incorrect password rejected"
    );

    check_result(
        attempts == 2'd1,
        "Attempt counter increments to one"
    );

    // TEST 3: SUCCESSFUL LOGIN CLEARS COUNTER

    attempt_password(
        16'h1234,
        1'b1,
        "Correct password accepted"
    );

    check_result(
        attempts == 2'd0,
        "Successful login clears attempts"
    );

    // TEST 4: CHANGE PASSWORD

    change_existing_password();

    // TEST 5: NEW PASSWORD

    attempt_password(
        16'hABCD,
        1'b1,
        "New password accepted"
    );

    // TEST 6: OLD PASSWORD

    attempt_password(
        16'h1234,
        1'b0,
        "Old password rejected"
    );

    // CLEAR ATTEMPT BEFORE LOCKOUT TEST

    attempt_password(
        16'hABCD,
        1'b1,
        "New password clears attempts"
    );

    check_result(
        attempts == 2'd0,
        "Attempt counter ready for lockout test"
    );

    // TEST 7: FIRST WRONG ATTEMPT

    attempt_password(
        16'h9999,
        1'b0,
        "First wrong attempt"
    );

    check_result(
        attempts == 2'd1,
        "Attempt count equals one"
    );

    // TEST 8: SECOND WRONG ATTEMPT

    attempt_password(
        16'h8888,
        1'b0,
        "Second wrong attempt"
    );

    check_result(
        attempts == 2'd2,
        "Attempt count equals two"
    );

    // TEST 9: THIRD WRONG ATTEMPT

    attempt_password(
        16'h7777,
        1'b0,
        "Third wrong attempt"
    );

    check_result(
        attempts == 2'd3,
        "Attempt count equals three"
    );

    // TEST 10: LOCKOUT

    @(posedge clk);
    #2;

    check_result(
        locked == 1'b1,
        "System enters permanent lockout"
    );

    // TEST 11: MUX LOCKED STATUS

    status_select = 2'b10;
    #1;

    check_result(
        status_data[0] == 1'b1,
        "MUX selects LOCKED signal"
    );

    // TEST 12: RESET RECOVERY

    @(negedge clk);
    reset = 1'b1;

    @(posedge clk);
    #2;

    check_result(
        locked == 1'b0,
        "Reset clears lockout"
    );

    check_result(
        attempts == 2'd0,
        "Reset clears attempt counter"
    );

    @(negedge clk);
    reset = 1'b0;

    // TEST 13: DEFAULT PASSWORD RESTORED

    attempt_password(
        16'h1234,
        1'b1,
        "Default password restored after reset"
    );

    // FINAL SUMMARY

    $display("");
    $display("========================================");
    $display("             TEST SUMMARY");
    $display("========================================");

    $display("TOTAL PASSED : %0d", pass_count);
    $display("TOTAL FAILED : %0d", fail_count);

    if (fail_count == 0)
        $display("FINAL RESULT : ALL TESTS PASSED");
    else
        $display("FINAL RESULT : TESTS FAILED");

    $display("========================================");

    #20;
    $finish;

end

endmodule
