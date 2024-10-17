// For simplicity sakes only depths of powers of 2

module fifo(
  clk, reset,
  wr, rd,
  wr_data,
  rd_data,
  empty, full
);

  parameter DATA_WIDTH = 32;
  parameter DEPTH = 8;
  localparam POINTERSIZE = $clog2(DEPTH);
  
  input wire                          clk, reset;
  input wire                          wr, rd;
  input wire [DATA_WIDTH - 1:0]       wr_data;
  output reg [DATA_WIDTH - 1:0]       rd_data;
  output wire                         empty, full;

  reg [DATA_WIDTH - 1:0] mem [DEPTH - 1:0]; 

  reg [POINTERSIZE - 1:0]                 wr_ptr = 0;
  reg [POINTERSIZE - 1:0]                 rd_ptr = 0;
  reg [POINTERSIZE:0]                     stored = 0;

  assign full = (stored == DEPTH);
  assign empty = (wr_ptr == rd_ptr) & (!full);

  always @(posedge clk, posedge reset) begin
    if (reset) begin  
      wr_ptr <= 0;
      rd_ptr <= 0;
      rd_data <= 0;
      stored <= 0;
    end
    else begin
      if (wr & !full) begin
        mem[wr_ptr] <= wr_data;
        wr_ptr <= wr_ptr + 1;
      end

      if (rd & !empty) begin
        rd_data <= mem[rd_ptr];
        rd_ptr <= rd_ptr + 1;
      end

      if(wr & rd) begin
        stored <= stored;
      end
      else if(wr & !full) begin
        stored = stored + 1;
        if (stored > DEPTH) begin
          stored = 0;
        end
      end
      else if(rd & !empty) begin
        stored <= stored - 1;
      end

    end    
  end


endmodule