`timescale 1ns/100ps

module uart_xintf_tb();

  reg clk = 0, reset = 0;
  always begin
    #5 
    clk <= ~clk;
  end

  reg [7:0]     rx_data_in = 0;
  reg           rx_valid = 0;

  wire [15:0]   xa, xd;
  wire          xwen, xrdn;
  wire          zone_6_n, zone_7_n;

  uart_xintf DUT(
    .clk(clk),
    .reset(reset),
    .rx_valid(rx_valid),
    .rx_data_in(rx_data_in),
    .xd(xd),
    .xa(xa),
    .xwen(xwen),
    .xrdn(xrdn),
    .zone_6_n(zone_6_n),
    .zone_7_n(zone_7_n)
  );

  initial begin
    #50
    serial_write_byte2(8'b01110111);  // 'w'
    // Address
    serial_write_byte2(8'h01);
    serial_write_byte2(8'h00);
    serial_write_byte2(8'h10);
    serial_write_byte2(8'h00);
    // Data
    serial_write_byte2(8'h0A);
    serial_write_byte2(8'hA0);

    #200
    #50
    serial_write_byte2(8'b01110010);  // 'r'
    // Address
    serial_write_byte2(8'h01);
    serial_write_byte2(8'h00);
    serial_write_byte2(8'h10);
    serial_write_byte2(8'h00);

    #1000
    $finish;
	end

  task serial_write_byte2;
    input [7:0] write_data;
    begin
      #200
      rx_data_in <= write_data;
      rx_valid <= 1'b1;
      #20
      rx_valid <= 1'b0;
    end
  endtask

  initial begin
		$dumpfile("uart_xintf_tb.vcd");
		$dumpvars(0, uart_xintf_tb);
	end

endmodule