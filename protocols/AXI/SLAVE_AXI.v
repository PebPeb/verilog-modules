

module SLAVE_AXI (
    input clk,

    output AWREADY  
  );
  
  parameter DATA_WIDTH = 32;

  reg AWREADY = 0;

  always @(posedge clk) begin
    
  end


endmodule
