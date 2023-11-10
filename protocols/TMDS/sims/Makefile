


all: rebuild gtkwave

rebuild:
	iverilog -o TMDS_tb.out TMDS_tb.v ../*.v
	vvp TMDS_tb.out

gtkwave:
	gtkwave TMDS_tb.vcd

clean:
	rm -f TMDS_tb.out
	rm -f TMDS_tb.vcd