//
//	tri_buf.v
//		Adjustable data width Tri State Buffer
//    Testbench
//

// -------------------------------- //
//	By: Bryce Keen	
//	Created: 06/30/2022
// -------------------------------- //
//	Last Modified: 06/30/2023


module tri_buf_tb();
	parameter WIDTH = 32;

  reg                   enable = 0;
	reg [WIDTH - 1:0]     tri_data = 32'h00FF00FF;
  reg [WIDTH - 1:0]     bus_data = 32'hFF00FF00;

  wire [WIDTH - 1:0]    bus, data_out;


	tri_buf UUT(
    .data_in(tri_data),
    .data_out(data_out),
    .enable(enable)
		);

  assign bus = enable ? data_out : bus_data;

	initial begin
    #10
    enable <= 1;
    #10

		$finish;
	end

  initial begin
		$dumpfile("tri_buf_tb.vcd");
		$dumpvars(0, tri_buf_tb);
	end

endmodule
