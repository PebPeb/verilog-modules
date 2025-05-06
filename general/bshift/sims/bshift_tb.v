`timescale 1ns / 1ps

module bshift_tb;

  parameter WIDTH = 16;

  reg [WIDTH-1:0] data_in = 0;
  reg [$clog2(WIDTH)-1:0] shift_amt = 0;
  wire [WIDTH-1:0] l_data_out, r_data_out;

  lbshift #(
    .WIDTH(WIDTH)
  ) DUT_L (
    .data_in(data_in),
    .shift_amt(shift_amt),
    .data_out(l_data_out)
  );

  rbshift #(
    .WIDTH(WIDTH)
  ) DUT_R (
    .data_in(data_in),
    .shift_amt(shift_amt),
    .data_out(r_data_out)
  );

  integer i;
  initial begin
    data_in = 0;
    shift_amt = 0;
    #4;

    data_in = 1;
    for (i = 0; i < 10; i = i + 1) begin
      shift_amt = i;
      #4;
    end

    data_in = 1;
    shift_amt = 2;
    #4;

    data_in = 16'hF00B;
    shift_amt = 4;
    #4;

    data_in = 16'h00FF;
    shift_amt = 2;
    #4;
    // $display("Time\t\t a\t\t\t b\t\t\t sel\t y");
    // $monitor("%0t\t %h\t %h\t %b\t %h", $time, a, b, sel, y);

    $finish;
  end

  initial begin
		$dumpfile("bshift_tb.vcd");
		$dumpvars(0, bshift_tb);
	end

endmodule
