module top_uart_xintf(clk, reset, RX, xready, TX, xwen, xrdn, zone_6_n, zone_7_n, xa, xd);

  input wire clk;
  input wire reset;
  input wire RX;
  input wire xready;
  output wire TX;
  output wire xwen;
  output wire xrdn;
  output wire zone_6_n;
  output wire zone_7_n;
  output wire [15:0] xa;
  inout wire [15:0] xd;

  parameter     INPUT_CLK      = 100_000_000;
  parameter     BAUD_RATE      = 115200;
  parameter     PAYLOAD_WIDTH  = 8;
  parameter     STOP_BITS      = 1;
  parameter     PARITY_BIT     = 0;

  wire [7:0] rx_data, tx_data;
  wire rx_valid;
  wire tx_busy;
  wire tx_start;

  uart_xintf xintf_translate(
    .clk(clk),
    .reset(reset),
    .rx_valid(rx_valid),
    .rx_data_in(rx_data),
    .xd(xd),
    .xa(xa),
    .xready(xready),
    .xwen(xwen),
    .xrdn(xrdn),
    .zone_6_n(zone_6_n),
    .zone_7_n(zone_7_n),
    .tx_data_out(tx_data),
    .tx_busy(tx_busy),
    .tx_start(tx_start)
  );

  uart_rx #(
    .INPUT_CLK(INPUT_CLK),
    .BAUD_RATE(BAUD_RATE),
    .PAYLOAD_WIDTH(PAYLOAD_WIDTH),
    .STOP_BITS(STOP_BITS),
    .PARITY_BIT(PARITY_BIT)
  ) rx_module (
    .clk(clk), 
    .reset(reset), 
    .rx_data(rx_data), 
    .rx_busy(), 
    .rx_valid(rx_valid), 
    .rx(RX)
  );

  uart_tx #(
    .INPUT_CLK(INPUT_CLK),
    .BAUD_RATE(BAUD_RATE),
    .PAYLOAD_WIDTH(PAYLOAD_WIDTH),
    .STOP_BITS(STOP_BITS),
    .PARITY_BIT(PARITY_BIT) 
  ) tx_module(
    .clk(clk), 
    .reset(reset), 
    .tx_start(tx_start), 
    .tx_data(tx_data), 
    .tx_busy(tx_busy), 
    .tx(TX)
  );


endmodule
