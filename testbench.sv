module new_test();
    // Declare testbench signals
    reg clk, rst, door, start, filled, detergent_added, cycle_timeout, drained, spin;
    wire door_lock, motor_on, fill_value_on, drain_value_on, done;

    // Instantiate the washing_machine module
    washing_machine machine1 (
        .clk(clk),
        .rst(rst),
        .start(start),
        .door(door),
        .lock(door_lock),
        .filled(filled),
        .water_valve(fill_value_on),
        .water_wash(),  // Unconnected signal
        .detergent_add(detergent_added),
        .soap_wash(),   // Unconnected signal
        .cycle_timeout(cycle_timeout),
        .motor(motor_on),
        .drained(drained),
        .drain_valve(drain_value_on),
        .spin(spin),
        .done(done)
    );

    // Initialize signals
    initial begin
        clk = 0;
        rst = 1;
        start = 0;
        door = 0;
        filled = 0;
        detergent_added = 0;
        cycle_timeout = 0;
        drained = 0;
        spin = 0;

        // Open the VCD file for waveform dumping
        $dumpfile("waveform.vcd");
        $dumpvars(0, new_test);  // Dump all signals at top level

        // Test sequence
        #5 rst = 0;                 // De-assert reset
        #5 start = 1; door = 1;     // Start and close the door
        #10 filled = 1;             // Water is filled
        #10 detergent_added = 1;    // Detergent is added
        #10 cycle_timeout = 1;      // Washing cycle completes
        #10 drained = 1;            // Water is drained
        #10 spin = 1;               // Spin cycle starts
        #20 $finish;                // End simulation
    end

    // Clock generation
    always begin
        #5 clk = ~clk;  // Generate a clock with a period of 10 units
    end

    // Monitor signals only on state changes
    always @(posedge clk) begin
        $display(
            "Time=%d, Clock=%b, Reset=%b, Start=%b, Door=%b, Filled=%b, Detergent Added=%b, Cycle Timeout=%b, Drained=%b, Spin=%b, Door Lock=%b, Motor=%b, Fill Valve=%b, Drain Valve=%b, Done=%b",
            $time, clk, rst, start, door, filled, detergent_added, cycle_timeout, drained, spin, door_lock, motor_on, fill_value_on, drain_value_on, done
        );
    end
endmodule
