`timescale 1ns/100ps

module top_uart_xintf_tb();

  reg clk = 0, reset = 0;
  localparam CLK_PERIOD = 10;
  always begin
    #(CLK_PERIOD / 2) 
    clk <= ~clk;
  end

  reg           RX = 1;
  wire [15:0]   xa, xd;
  wire          xwen, xrdn;
  wire          zone_6_n, zone_7_n;
  wire          TX;

  localparam INPUT_CLK = 1000;
  localparam BAUD_RATE = 100;

  top_uart_xintf #(
    .INPUT_CLK(INPUT_CLK),   // Values for sim
    .BAUD_RATE(BAUD_RATE)     // NOT A VALID REAL BAUD
  ) DUT(
    .clk(clk), 
    .reset(reset), 
    .RX(TX_testbench), 
    .TX(TX), 
    .xd(xd), 
    .xa(xa),
    .xwen(xwen), 
    .xrdn(xrdn), 
    .zone_6_n(zone_6_n), 
    .zone_7_n(zone_7_n),
    .xready()
  );

  reg [7:0] tx_data = 0;
  reg tx_start = 0;
  wire tx_busy;
  wire TX_testbench;

  uart_tx #(
    .INPUT_CLK(INPUT_CLK),
    .BAUD_RATE(BAUD_RATE)
  ) tb_tx (
    .clk(clk), 
    .reset(reset), 
    .tx_start(tx_start), 
    .tx_data(tx_data), 
    .tx_busy(tx_busy), 
    .tx(TX_testbench)
  );

  initial begin
    #50
    // Write
    serial_write_byte2(8'b01110111);  // 'w' 77
      // Address
    serial_write_byte2(8'h01);
    serial_write_byte2(8'h00);
    serial_write_byte2(8'h10);
    serial_write_byte2(8'h00);
      // Data
    serial_write_byte2(8'h0A);
    serial_write_byte2(8'hA0);

    
    
    serial_write_byte2(8'b01110010);  // 'r'
    // Address
    serial_write_byte2(8'h01);
    serial_write_byte2(8'h00);
    serial_write_byte2(8'h10);
    serial_write_byte2(8'h00);
    force DUT.xintf_translate.data_tx_1 = 16'hBEEF;
    #10000
    $finish;
	end

  task serial_write_byte2;
    input [7:0] write_data;
    begin
      #20
      tx_data <= write_data;
      tx_start <= 1;
      #20
      tx_start <= 0;
      #(10 * (INPUT_CLK / BAUD_RATE) * CLK_PERIOD);   // 10 Bits at X rate ()
    end
  endtask

  initial begin
		$dumpfile("top_uart_xintf_tb.vcd");
		$dumpvars(0, top_uart_xintf_tb);
	end

endmodule