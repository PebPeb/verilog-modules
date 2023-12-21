


all: rebuild gtkwave

rebuild:
	iverilog -o uart_tb.out uart_tb.v ../*.v
	vvp uart_tb.out

gtkwave:
	gtkwave uart_tb.vcd

clean:
	rm -f *.out
	rm -f *.vcd