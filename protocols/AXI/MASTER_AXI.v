
module MASTER_AXI (
    input ACLK,
    input ARESETn,

    output AWVALID
  );

  parameter DATA_WIDTH = 32;

  wire ACLK;
  wire ARESETn;

  reg AWVALID = 0;

  always @(posedge ACLK) begin

    // A3.1.2 Documents Reset requirements
    if (~ARESETn) begin
      ARVALID <= 1'b0; 
      AWVALID <= 1'b0;
      WVALID <= 1'b0;
    end

    
  end





endmodule
