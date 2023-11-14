//
//	TMDS_encoder.v
//    Transition-minimized differential signaling
//

// -------------------------------- //
//	By: Bryce Keen	
//	Created: 11/09/2023
// -------------------------------- //
//	Last Modified: 11/14/2023


module TMDS_encoder(clk, D, C0, C1, DE, q_out);
  input wire         clk;
  input wire [7:0]   D;
  input wire         C0, C1, DE;
  output reg [9:0]   q_out = 0;

  reg [9:0]          control_data = 0;          // Control Data
  reg [9:0]          pixel_data = 0;            // Pixel Data 
  reg signed [4:0]          cnt = 0, cnt_n = 0;

  wire [3:0]         N1D;                        // Number of 1s
  wire [3:0]         cnt_bal;                   // Balancing 1s and 0x
  wire [3:0]         q_m_N1, q_m_N0;
  wire               XNOR;                      // If it is not XNOR then it was XOR
  wire [8:0]         q_m;

  assign N1D = D[0] + D[1] + D[2] + D[3] + D[4] + D[5] + D[6] + D[7];
  assign XNOR = (N1D > 4) || ((N1D == 4) && (D[0] == 0));

  assign q_m = {~XNOR, (q_m[6:0] ^ D[7:1]) ^ {7{XNOR}}, D[0]};

  assign q_m_N1 = q_m[0] + q_m[1] + q_m[2] + q_m[3] + q_m[4] + q_m[5] + q_m[6] + q_m[7];
  assign q_m_N0 = 8 - q_m_N1;

  always @(*) begin
    if ((cnt == 0) || (q_m_N1 == q_m_N0)) begin
      pixel_data <= {~q_m[8], q_m[8], q_m[8] ? q_m[7:0] : ~q_m[7:0]};
      cnt_n <= q_m[8] ? cnt + q_m_N1 - q_m_N0 : cnt - q_m_N1 + q_m_N0;
    end
    else begin
      if (((cnt > 0) && (q_m_N1 > q_m_N0)) || ((cnt < 0) && (q_m_N0 > q_m_N1))) begin
        pixel_data <= {1'b1, q_m[8], ~q_m[7:0]};
        cnt_n <= cnt + (q_m[8] ? 2 : 0) - q_m_N1 + q_m_N0;
      end
      else begin
        pixel_data <= {1'b0, q_m[8], q_m[7:0]};
        cnt_n <= cnt - (~q_m[8] ? 2 : 0) + q_m_N1 - q_m_N0;
      end
    end
  
  end

  always @(*) begin
    case ({C0, C1})
      2'b00:    control_data <= 10'b1101010100;
      2'b01:    control_data <= 10'b0010101011;
      2'b10:    control_data <= 10'b0101010100;
      2'b11:    control_data <= 10'b1010101011;
    endcase
  end

  always @(posedge clk) begin
    // If DE then we use pixel data
    // else control data
    if (DE) begin                               
      q_out <= pixel_data;
      cnt <= cnt_n;
    end
    else begin
      q_out <= control_data;
      cnt <= 0;
    end
  end


endmodule
