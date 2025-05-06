
module lbshift #(
  parameter WIDTH = 8
)(
  input  wire [WIDTH-1:0] data_in,
  input  wire [$clog2(WIDTH)-1:0] shift_amt,
  output wire [WIDTH-1:0] data_out
);

  wire [WIDTH-1:0] stage [$clog2(WIDTH):0];

  assign stage[0] = data_in;

  genvar i;
  generate
    for (i = 0; i < $clog2(WIDTH); i = i + 1) begin : shift_stage
      assign stage[i+1] = shift_amt[i] ? (stage[i] << (1 << i)) | (stage[i] >> (WIDTH - (1 << i))) : stage[i];
    end
  endgenerate

  assign data_out = stage[$clog2(WIDTH)];

endmodule