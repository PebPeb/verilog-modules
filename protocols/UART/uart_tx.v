

module uart_tx (clk, reset, tx_start, tx_data, tx_busy, tx);

  input wire                         clk, reset;
  input wire                         tx_start;
  input wire [PAYLOAD_WIDTH - 1:0]   tx_data;
  output reg                         tx_busy;  
  output reg                         tx = 1'b1;

  parameter     INPUT_CLK      = 100_000_000;
  parameter     BAUD_RATE      = 115200;
  parameter     PAYLOAD_WIDTH  = 8;
  parameter     STOP_BITS      = 1;
  parameter     PARITY_BIT     = 0;

  localparam    CYCLES_PER_BIT = (INPUT_CLK / BAUD_RATE) - 1;

  // Program States
  localparam    IDLE_STATE     = 0;
  localparam    START_STATE    = 1;
  localparam    DATA_STATE     = 2;
  localparam    PARITY_STATE   = 3;
  localparam    STOP_STATE     = 4;
  reg [2:0]     state_reg      = IDLE_STATE;

  reg [3:0]                 bits_transmited = 0;
  reg [PAYLOAD_WIDTH - 1:0] data = 0;
  reg [15:0]                counter = 0;


  // State Machine
  always @(posedge clk or posedge reset) begin
    counter <= counter + 1;           // Cycles per bit counter  
    
    if (reset) begin
      tx <= 1'b1;
      tx_busy <= 1'b0;                     
      counter <= 0;                     // Reset Counter
      bits_transmited <= 0;             // Resets bits transmited
      state_reg <= IDLE_STATE;
    end
    else begin
      case(state_reg)
        IDLE_STATE: begin
          tx <= 1'b1;
          tx_busy <= 1'b0;                     
          counter <= 0;                     // Reset Counter
          bits_transmited <= 0;             // Resets bits transmited
          if (tx_start && ~reset) begin
            data <= tx_data;
            tx_busy <= 1'b1;                 
            state_reg <= START_STATE;      // Next State
          end
        end

        START_STATE: begin
          tx <= 1'b0;
          if (counter == CYCLES_PER_BIT) begin
            state_reg <= DATA_STATE;
            counter <= 0;
          end
        end

        DATA_STATE: begin
          tx <= data[bits_transmited];
          if (counter == CYCLES_PER_BIT) begin
            counter <= 0;
            bits_transmited <= bits_transmited + 1;
            if (bits_transmited == (PAYLOAD_WIDTH - 1)) begin
              bits_transmited <= 0;
              if (PARITY_BIT) begin
                state_reg <= PARITY_STATE;
              end else begin
                state_reg <= STOP_STATE;
              end
            end
          end
        end

        PARITY_STATE: begin
          tx <= data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[4] ^ data[5] ^ data[6] ^ data[7];
          if (counter == CYCLES_PER_BIT) begin
            state_reg <= STOP_STATE;
            counter <= 0;
          end
        end

        STOP_STATE: begin
          tx <= 1'b1;
          if (counter == CYCLES_PER_BIT) begin
            counter <= 0;
            bits_transmited <= bits_transmited + 1;
            if (bits_transmited == (STOP_BITS - 1)) begin
              state_reg <= IDLE_STATE;
              bits_transmited <= 0;
            end
          end
        end

        default: begin
          tx <= 1'b1;
          counter <= 0;
          state_reg <= IDLE_STATE;
        end
      endcase    
    end
  end

endmodule
