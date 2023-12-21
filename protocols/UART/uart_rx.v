

module uart_rx (clk, reset, rx_data, rx_busy, rx_valid, rx);

  input wire                         clk, reset;
  output reg [PAYLOAD_WIDTH - 1:0]   rx_data = 0;
  output reg                         rx_busy = 1'b0;  
  output reg                         rx_valid = 1'b0;
  input wire                         rx;

  parameter     INPUT_CLK      = 100_000_000;
  parameter     BAUD_RATE      = 115200;
  parameter     PAYLOAD_WIDTH  = 8;
  parameter     STOP_BITS      = 1;
  parameter     PARITY_BIT     = 0;

  localparam    CYCLES_PER_BIT = (INPUT_CLK / BAUD_RATE) - 1;
  localparam    HALF_CYCLES = CYCLES_PER_BIT / 2;

  // Program States
  localparam    IDLE_STATE     = 0;
  localparam    START_STATE    = 1;
  localparam    DATA_STATE     = 2;
  localparam    PARITY_STATE   = 3;
  localparam    STOP_STATE     = 4;
  reg [2:0]     state_reg      = IDLE_STATE;

  reg [3:0]                 bits_received = 0;
  reg [PAYLOAD_WIDTH - 1:0] data = 0;
  reg [15:0]                counter = 0;
  reg                       valid_check = 1'b0;


  // State Machine
  always @(posedge clk or posedge reset) begin
    counter <= counter + 1;           // Cycles per bit counter  
    
    if (reset) begin
      valid_check <= 1'b0;
      rx_data <= 0;
      data <= 0;
      rx_busy <= 1'b0;  
      rx_valid <= 1'b0;                   
      counter <= 0;                   
      bits_received <= 0;            
      state_reg <= IDLE_STATE;
    end
    else begin
      case(state_reg)
        IDLE_STATE: begin
          rx_busy <= 1'b0;                     
          counter <= 0;                    // Reset Counter
          bits_received <= 0;              // Resets bits transmited
          if (~rx) begin
            rx_valid <= 1'b0;
            rx_busy <= 1'b1;                 
            state_reg <= START_STATE;      // Next State
          end
        end

        START_STATE: begin
          if (counter == HALF_CYCLES) begin
            state_reg <= DATA_STATE;
            counter <= 0;
          end
        end

        DATA_STATE: begin
          if (counter == CYCLES_PER_BIT) begin
            data[bits_received] <= rx;
            counter <= 0;
            bits_received <= bits_received + 1;
            if (bits_received == (PAYLOAD_WIDTH - 1)) begin
              bits_received <= 0;
              if (PARITY_BIT) begin
                state_reg <= PARITY_STATE;
              end else begin
                state_reg <= STOP_STATE;
              end
            end
          end
        end

        PARITY_STATE: begin
          if (counter == CYCLES_PER_BIT) begin
            valid_check <= ((data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[4] ^ data[5] ^ data[6] ^ data[7]) == rx);
            state_reg <= STOP_STATE;
            counter <= 0;
          end
        end

        STOP_STATE: begin
          if (counter == CYCLES_PER_BIT) begin
            valid_check <= (valid_check & rx);
            counter <= 0;
            bits_received <= bits_received + 1;
            if (bits_received == (STOP_BITS - 1)) begin
              rx_valid <= ((valid_check & rx) | ~PARITY_BIT);
              rx_data <= data;
              state_reg <= IDLE_STATE;
              bits_received <= 0;
            end
          end
        end
        default: begin
          state_reg <= IDLE_STATE;
        end
      endcase    
    end
  end

  wire testing, testing2;
  assign testing = (data[0] ^ data[1] ^ data[2] ^ data[3] ^ data[4] ^ data[5] ^ data[6] ^ data[7]);
  assign testing2 = ((valid_check & rx) | ~PARITY_BIT);

endmodule
