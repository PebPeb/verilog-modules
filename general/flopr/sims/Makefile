


all: rebuild gtkwave

rebuild:
	iverilog -o flopren_tb.out flopren_tb.v ../flopren.v
	vvp flopren_tb.out

gtkwave:
	gtkwave flopren_tb.vcd

clean:
	rm -f flopren_tb.out
	rm -f flopren_tb.vcd