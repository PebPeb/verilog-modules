
module TMDS_tb();

  reg clk = 0;
	always begin
		#10
		clk <= ~clk;
	end
	

  reg               C0 = 0, C1 = 0, DE = 0;
  reg [7:0]         D = 0;
  wire [9:0]        TMDS;

  TMDS_encoder UUT(
    .clk(clk),
    .D(D),
    .C0(C0),
    .C1(C1),
    .DE(DE),
    .q_out(TMDS)
    );


  reg control = 0;
  integer i = 0;
  always @(posedge clk) begin
    if (control) begin
      {C0, C1} <= {C0, C1} + 1;
    end
  end


	initial begin
    #60
    control <= 1;
    while (i < 4) begin
      #20
      i = i + 1;
    end
    i <= 0;
    #60

    DE <= 1;
    #60

    while (i < 2**8) begin
      #20
      i = i + 1;
      D = i;
    end

    #60

		$finish;
	end

  initial begin
		$dumpfile("TMDS_tb.vcd");
		$dumpvars(0, TMDS_tb);
	end

endmodule
