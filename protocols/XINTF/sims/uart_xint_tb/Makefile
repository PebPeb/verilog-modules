


all: rebuild gtkwave

rebuild:
	iverilog -o uart_xintf_tb.out uart_xintf_tb.v ../../uart_xintf.v
	vvp uart_xintf_tb.out

gtkwave:
	gtkwave uart_xintf_tb.vcd

clean:
	rm -f *.out
	rm -f *.vcd

