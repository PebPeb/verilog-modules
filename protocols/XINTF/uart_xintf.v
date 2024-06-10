
module uart_xintf (
  clk,
  reset,
  rx_valid,
  rx_data_in,
  xd,
  xa,
  xready,
  xwen,
  xrdn,
  zone_6_n,
  zone_7_n,
  tx_data_out,
  tx_busy,
  tx_start
);

input wire clk;
input wire reset;
input wire rx_valid;
input wire xready;
input wire tx_busy;
input wire [7:0] rx_data_in;

output reg tx_start = 0;
output reg xwen = 1;
output reg xrdn = 1;
output reg zone_6_n = 1;
output reg zone_7_n = 1;
inout wire [15:0] xd;
output reg [7:0] tx_data_out = 0;
output reg [15:0] xa = 16'h0000; 

reg [7:0] rx_data = 0;

localparam IDLE = 0;
localparam ADRS_0 = 1;
localparam ADRS_1 = 2;
localparam ADRS_2 = 3;
localparam ADRS_3 = 4;
localparam WRITE_0 = 5;
localparam WRITE_1 = 6;


reg [7:0] rx_state = IDLE;
reg rd_wr_op;       // 0 for read 1 for write

reg [31:0] address = 0;
reg [15:0] data = 0, data_1 = 0, data_tx = 0, data_tx_1 = 0;

reg write_trigger = 0;
reg read_trigger = 0;


always @(posedge rx_valid, posedge reset) begin
  if (reset) begin
    rx_state <= IDLE;
    rd_wr_op <= 0;
    address <= 0;
    data <= 0;
    write_trigger <= 0;
    read_trigger <= 0;
  end
  else begin
    rx_data = rx_data_in;
    case (rx_state)
      IDLE: begin
        if (rx_data == 8'b01110111) begin             // 'w'
          rx_state <= ADRS_0;
          rd_wr_op <= 1;
        end
        else if (rx_data == 8'b01110010) begin        // 'r'
          rx_state <= ADRS_0;
          rd_wr_op <= 0;
        end
        read_trigger <= 0;
        write_trigger <= 0;
      end
      ADRS_0: begin
        address[7:0] <= rx_data;
        rx_state <= ADRS_1;
      end 
      ADRS_1: begin
        address[15:8] <= rx_data;
        rx_state <= ADRS_2;
      end 
      ADRS_2: begin
        address[23:16] <= rx_data;
        rx_state <= ADRS_3;
      end 
      ADRS_3: begin
        address[31:24] <= rx_data;
        if (rd_wr_op == 1) begin    // Write operation
          rx_state <= WRITE_0;
        end
        else begin
          read_trigger <= 1;
          rx_state <= IDLE;
        end
      end 
      WRITE_0: begin
        data[7:0] <= rx_data;
        rx_state <= WRITE_1;
      end
      WRITE_1: begin
        data[15:8] <= rx_data;
        rx_state <= IDLE;
        write_trigger <= 1;
      end
    endcase
  end
end

localparam	ST_1 = 4'h1;         
localparam	ST_2 = 4'h2;
localparam	ST_3 = 4'h3;
localparam	ST_4 = 4'h4;         
localparam	ST_5 = 4'h5;
localparam	ST_6 = 4'h6;               
localparam	ST_7 = 4'h7;
localparam	ST_8 = 4'h8;
localparam	ST_9 = 4'h9;

localparam NONE = 0;
localparam READ_STATE = 1;
localparam WRITE_STATE = 2;
reg [1:0] rd_wr_xintf_state = NONE;

reg [3:0] xintf_state = IDLE;
reg xd_high_impd = 1;

assign xd = xd_high_impd ? 16'hzzzz : data_1;

reg read_trigger_rise = 0;
reg read_trigger_1 = 0;
reg [1:3] resync_read_trigger = 0;

reg write_trigger_rise = 0;
reg write_trigger_1 = 0;
reg [1:3] resync_write_trigger = 0;

always @(posedge clk, posedge reset) begin
  read_trigger_rise <= resync_read_trigger[2] & !resync_read_trigger[3];
  resync_read_trigger <= {read_trigger, resync_read_trigger[1:2]};

  write_trigger_rise <= resync_write_trigger[2] & !resync_write_trigger[3];
  resync_write_trigger <= {write_trigger, resync_write_trigger[1:2]};

  if (reset) begin
    xintf_state <= IDLE;
    zone_6_n <= 1;
    zone_7_n <= 1;
    xa <= 16'h0000;
    data_1 <= 16'h0000;
    xd_high_impd <= 1;
    xwen <= 1;
    xrdn <= 1;
    rd_wr_xintf_state <= NONE;
    read_trigger_1 <= 0;
    write_trigger_1 <= 0;
  end
  else begin
    case (xintf_state)
      IDLE: begin
        if (write_trigger_rise || read_trigger_rise) begin
          read_trigger_1 <= read_trigger_rise;
          write_trigger_1 <= write_trigger_rise;
          xintf_state <= ST_1;
          xa <= address[15:0];
          xd_high_impd <= 1;
          if (address[31:16] == 16'h0010) begin
            zone_6_n <= 0;
          end
          else if (address[31:16] == 16'h0020) begin
            zone_7_n <= 0;
          end
          else begin
            zone_6_n <= 0;
          end
        end
      end 
      ST_1: begin
        xintf_state <= ST_2;
      end
      ST_2: begin
        xintf_state <= ST_3;
        if (write_trigger_1) begin
          write_trigger_1 <= 0;
          xwen <= 0;
          xd_high_impd <= 0;
          data_1 <= data;
          rd_wr_xintf_state <= WRITE_STATE;
        end
        else if (read_trigger_1) begin
          xd_high_impd <= 1;
          read_trigger_1 <= 0;
          xrdn <= 0;
          rd_wr_xintf_state <= READ_STATE;
        end
      end
      ST_3: begin
        if (rd_wr_xintf_state == READ_STATE) begin
          read_xintf(data_tx); 
        end
        xintf_state <= ST_4;
      end
      ST_4: begin
        if (rd_wr_xintf_state == READ_STATE) begin
          read_xintf(data_tx); 
        end
        xintf_state <= ST_5;
      end
      ST_5: begin
        if (rd_wr_xintf_state == READ_STATE) begin
          read_xintf(data_tx); 
        end
        xintf_state <= ST_6;
      end
      ST_6: begin
        if (rd_wr_xintf_state == READ_STATE) begin
          read_xintf(data_tx); 
        end 
        xintf_state <= ST_7;
      end
      ST_7: begin
        if (rd_wr_xintf_state == READ_STATE) begin
          read_xintf(data_tx); 
        end
        xwen <= 1;
        xrdn <= 1;
        xintf_state <= ST_8;
      end
      ST_8: begin
        xd_high_impd <= 1;
        xintf_state <= ST_9;
      end
      ST_9: begin
        zone_6_n <= 1;
        zone_7_n <= 1;
        xintf_state <= IDLE;

        // Start TX state machine
        if (rd_wr_xintf_state == READ_STATE) begin
          data_tx_1 <= data_tx;
          tx_start_state <= 1;
        end 
        rd_wr_xintf_state <= NONE;
      end
    endcase
  end
end

task read_xintf;
  output [15:0] xintf_data_line;
  begin
    if (xrdn == 0 && xready == 1) begin
      xintf_data_line <= xd;
    end
  end
endtask

localparam TX_LOWER = 1;
localparam TX_UPPER = 2;
localparam TX_WAIT_0 = 3;
localparam TX_WAIT_1 = 4;

reg tx_start_state = 0;
reg [3:0] tx_state = IDLE;

integer i = 0;
always @(posedge clk, posedge reset) begin
  if (reset) begin
    tx_state <= IDLE;
    tx_start_state <= 0;
  end
  else begin
    case (tx_state)
      IDLE: begin
        if (tx_start_state && ~tx_busy) begin
          tx_data_out <= data_tx_1[7:0];
          tx_start <= 1;
          tx_state <= TX_WAIT_0;
          tx_start_state <= 0;
        end
        else begin
          tx_state <= IDLE;
        end
      end 
      TX_WAIT_0: begin
        if (i >= 10) begin
          tx_state <= TX_UPPER;
          i <= 0;
          tx_start <= 0;
        end
        else begin
          i <= i + 1;
          tx_state <= TX_WAIT_0;
        end 
      end
      TX_UPPER: begin
        if (~tx_busy) begin
          tx_data_out <= data_tx_1[15:8];
          tx_start <= 1;
          tx_state <= TX_WAIT_1;
        end
        else begin
          tx_state <= TX_UPPER;
        end
      end 
      TX_WAIT_1: begin
        if (i >= 10) begin
          tx_state <= IDLE;
          i <= 0;
          tx_start <= 0;
        end
        else begin
          i <= i + 1;
          tx_state <= TX_WAIT_1;
        end 
      end
    endcase
  end
end

endmodule


