


all: rebuild gtkwave

rebuild:
	iverilog -o serializer_tb.out serializer_tb.v ../*.v
	vvp serializer_tb.out

gtkwave:
	gtkwave serializer_tb.vcd

clean:
	rm -f serializer_tb.out
	rm -f serializer_tb.vcd