// 



module AXI4_Lite_M (
    input ACLK,
    input ARESETn,

    output AWVALID
  );

  parameter DATA_WIDTH = 32;

  // Parameter Check
  initial begin
    if (DATA_WIDTH != 32 && DATA_WIDTH != 64) begin
      $display("Error: WIDTH must be either 32 or 64.");
      $stop;
    end
  end

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
    else begin

    end    
  end





endmodule
