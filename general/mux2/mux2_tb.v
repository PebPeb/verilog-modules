`timescale 1ns / 1ps

module mux2_tb;

    // Parameters
    parameter WIDTH = 32;

    // Inputs to the DUT (Device Under Test)
    reg [WIDTH-1:0] a, b;
    reg sel;

    // Output from the DUT
    wire [WIDTH-1:0] y;

    // Instantiate the mux2 module
    mux2 #(WIDTH) uut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    // Test procedure
    initial begin
        // Initialize inputs
        a = 32'hAAAA_AAAA;
        b = 32'h5555_5555;
        sel = 0;

        // Display header
        $display("Time\t\t a\t\t\t b\t\t\t sel\t y");
        $monitor("%0t\t %h\t %h\t %b\t %h", $time, a, b, sel, y);

        // Test case 1: sel = 0, expect y = a
        #10;
        sel = 0;
        #10;

        // Test case 2: sel = 1, expect y = b
        sel = 1;
        #10;

        // Change inputs and test with sel = 0
        a = 32'h1234_5678;
        b = 32'h9ABC_DEF0;
        sel = 0;
        #10;

        // Test case 3: sel = 1, expect y = b
        sel = 1;
        #10;

        // Finish simulation
        $finish;
    end

    initial begin
		$dumpfile("mux2_tb.vcd");
		$dumpvars(0, mux2_tb);
	end

endmodule
