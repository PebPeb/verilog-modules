`timescale 1ns / 1ps

module PWM_tb;

  wire out;
  reg [7:0] duty_cycle = 0;

  reg clk = 0;
  always #2 clk = ~clk;

  PWM DUT (
      .clk(clk),
      .duty_cycle(duty_cycle),
      .out(out)
    );  
  

  initial begin
    duty_cycle <= 10;
    #1000;
    duty_cycle <= 100;
    #1000;
    duty_cycle <= 50;
    #1000;
    duty_cycle <= 0;
    #1000;
    $finish;
  end

  initial begin
		$dumpfile("PWM_tb.vcd");
		$dumpvars(0, PWM_tb);
	end

endmodule
