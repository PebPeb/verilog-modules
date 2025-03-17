

module AXI4_Lite_S (
    input ACLK,
    input ARESETn,

    output AWREADY  
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

  reg AWREADY = 0;

  always @(posedge clk) begin
    
    // A3.1.2 Documents Reset requirements
    if (~ARESETn) begin
      RVALID <= 1'b0; 
      BVALID <= 1'b0;
    end

  end


endmodule
