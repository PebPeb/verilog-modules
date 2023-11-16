



module serializer (clk, reset, I, O);
  parameter WIDTH = 32;

  input wire                        clk, reset;
  input wire [WIDTH - 1:0]          I;
  output wire                       O;

  reg                               I_shift_load = 0;
  reg [WIDTH - 1:0]                 I_shift = 0;

  integer mod = 0;
  always @(posedge clk, posedge reset) begin
    I_shift_load <= (mod == (WIDTH - 1));
    if (reset) begin
      I_shift <= 0;
      mod <= 0;
    end
    else begin
      I_shift <= I_shift_load ? I : I_shift[WIDTH - 1:1];
      mod <= (mod == (WIDTH - 1)) ? 0 : mod + 1;
    end
  end
  assign O = I_shift[0];

endmodule


