


all: rebuild gtkwave

rebuild:
	iverilog -o top_uart_xintf_tb.out top_uart_xintf_tb.v ../../*.v ../../../UART/*.v
	vvp top_uart_xintf_tb.out

gtkwave:
	gtkwave top_uart_xintf_tb.vcd

clean:
	rm -f *.out
	rm -f *.vcd

