


all: rebuild gtkwave

rebuild:
	iverilog -o uart_tx_tb.out uart_tx_tb.v ../*.v
	vvp uart_tx_tb.out

gtkwave:
	gtkwave uart_tx_tb.vcd

clean:
	rm -f uart_tx_tb.out
	rm -f uart_tx_tb.vcd