

module SLAVE_AXI (
    input ACLK,
    input ARESETn,

    output AWREADY  
  );
  
  parameter DATA_WIDTH = 32;

  wire ACLK;
  wire ARESETn;

  reg AWREADY = 0;

  always @(posedge clk) begin
    
    // A3.1.2 Documents Reset requirements
    if (~ARESETn) begin
      RVALID <= 1'b0; 
      BVALID <= 1'b0;
    end

  end


endmodule
