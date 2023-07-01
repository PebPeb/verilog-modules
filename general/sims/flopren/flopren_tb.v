//
//	flopren_tb.v
//		Enabled Resetable flip-flop
//    Testbench
//

// -------------------------------- //
//	By: Bryce Keen	
//	Created: 06/30/2022
// -------------------------------- //
//	Last Modified: 06/30/2023


module flopren_tb();
	parameter WIDTH = 32;

	reg 				      reset = 0, clk = 0, enable = 0;
	reg [WIDTH - 1:0]		  d = 0;
	wire [WIDTH - 1:0]		q;
	
	always begin
		#10
		clk <= ~clk;
	end
	
	
	flopr UUT(
		.d(d),
		.q(q),
		.clk(clk),
		.enable(enable),
		.reset(reset)
		);

	initial begin
		d <= 127;
		
		#20
		enable <= 1;
		d <= 255;
		
		#20
		
		reset <= 1;
		
		#30
		
		reset <= 0;
		#20

		enable <= 0;

    #16
    reset <= 1;
    #20
		$finish;
	end

  initial begin
		$dumpfile("flopren_tb.vcd");
		$dumpvars(0, flopren_tb);
	end

endmodule
