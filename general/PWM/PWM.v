module PWM (
    clk,
    duty_cycle,
    out
  );  
  
  localparam IN_CLK_FRQ = 100;
  localparam OUT_CLK_FRQ = 10;

  input wire clk;
  input wire [7:0] duty_cycle;  // 100 - 0
  output reg out = 0;

  integer freq_count = 0;
  always @(posedge clk) begin
    if (freq_count >= 99) begin
      freq_count <= 0;
    end
    else begin
      freq_count <= freq_count + 1;
    end

    if (freq_count < duty_cycle) begin
      out <= 1'b1;
    end 
    else begin
      out <= 1'b0;
    end
  end
endmodule