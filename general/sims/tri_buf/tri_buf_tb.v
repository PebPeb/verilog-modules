//
//	tri_buf.v
//		Adjustable data width Tri State Buffer
//

// -------------------------------- //
//	By: Bryce Keen	
//	Created: 06/30/2023
// -------------------------------- //
//	Last Modified: 06/30/2023



module tri_buf(data_in, data_out, enable);
	parameter WIDTH = 32;
	
	input wire [WIDTH - 1:0]	data_in;
  input wire      			    enable;
	inout wire [WIDTH - 1:0]	data_out;

  assign data_out = enable ? data_in : {WIDTH{1'bZ}};

endmodule


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
  wire [WIDTH - 1:0]    bus;


	tri_buf UUT(
    .data_in(tri_data),
    .data_out(bus),
    .enable(enable)
		);

	initial begin
    

		$finish;
	end

  initial begin
		$dumpfile("flopren_tb.vcd");
		$dumpvars(0, flopren_tb);
	end

endmodule
