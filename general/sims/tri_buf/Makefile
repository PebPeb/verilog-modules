


all: rebuild gtkwave

rebuild:
	iverilog -o tri_buf_tb.out tri_buf_tb.v ../../tri_buf.v
	vvp tri_buf_tb.out

gtkwave:
	gtkwave tri_buf_tb.vcd

clean:
	rm -f tri_buf_tb.out
	rm -f tri_buf_tb.vcd