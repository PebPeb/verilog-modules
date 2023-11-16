`timescale 1ns/100ps

module serializer_tb();

  reg clk = 0;
  always begin
    #5 
    clk <= ~clk;
  end

  reg reset = 0;
  reg [9:0] data = 0;
  wire serialdata;

  serializer #(.WIDTH(10)) UUT(
    .clk(clk), 
    .reset(reset), 
    .I(data), 
    .O(serialdata));


  initial begin
    data <= 10'b1100110011;
    #100
    data <= 10'b0010101011;
    #100
    data <= 10'b0000000000;
    #100
    data <= 10'b1111111111;
    #100
    data <= 10'b0000000000;
    #100
    #100
    $finish;
	end

  initial begin
		$dumpfile("serializer_tb.vcd");
		$dumpvars(0, serializer_tb);
	end

endmodule