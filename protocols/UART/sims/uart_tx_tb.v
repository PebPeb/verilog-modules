`timescale 1ns/100ps

module uart_tx_tb();

  reg clk = 0;
  always begin
    #5 
    clk <= ~clk;
  end

  reg           reset = 0;
  reg           tx_start = 0;
  reg [7:0]     data = 0;
  wire          tx, tx_busy;


  uart_tx #(
    .INPUT_CLK(100_000_000),
    .BAUD_RATE(115200),
    .STOP_BITS(1),
    .PARITY_BIT(0)
  ) DUT (
    .clk(clk), 
    .reset(reset), 
    .tx_start(tx_start), 
    .tx_data(data), 
    .tx_busy(tx_busy), 
    .tx(tx)
  );

  initial begin
    #10000
    data <= 8'b00111101;
    tx_start <= 1;
    #20
    tx_start <= 0;
    while (tx_busy) begin
      #10;
    end
    #10000

    data <= 8'b11000011;
    tx_start <= 1;
    #20
    tx_start <= 0;
    while (tx_busy) begin
      #10;
    end
    #10000

    data <= 8'b10101010;
    tx_start <= 1;
    #20
    tx_start <= 0;
    while (tx_busy) begin
      #10;
    end
    #10000

    data <= 8'b01010101;
    tx_start <= 1;
    #20
    tx_start <= 0;
    while (tx_busy) begin
      #10;
    end
    #10000

    #10000
    #10000
    $finish;
	end

  initial begin
		$dumpfile("uart_tx_tb.vcd");
		$dumpvars(0, uart_tx_tb);
	end

endmodule