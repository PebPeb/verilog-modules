// 

module AXI4_Lite_M (
    input ACLK,
    input ARESETn,
    // Write Address Channel
    output AWADDR,
    output AWPROT,
    output AWVALID,
    input AWREADY,
    // Write Data Channel 
    output WDATA,
    output WSTRB,             // Optional
    output WVALID,
    input WREADY,
    // Write Response Channel
    input BRESP,              // Optional
    input BVALID,
    output BREADY
    // Read Address Channel
    output ARADDR,
    output ARPROT,
    output ARVALID,
    input ARREADY,
    // Read Data Channel
    input RDATA,
    input RRESP,              // Optional
    input RVALID,
    output RREADY
  );

  parameter DATA_WIDTH = 32;
  parameter ADDR_WIDTH = 32;

  // Parameter Check
  initial begin
    if (DATA_WIDTH != 32 && DATA_WIDTH != 64) begin
      $display("Error: DATA_WIDTH must be either 32 or 64.");
      $stop;
    end

    if (ADDR_WIDTH < 1) begin
      $display("Error: ADDR_WIDTH must be greater than 0.");
      $stop;
    end

  end

  wire ACLK;
  wire ARESETn;

  wire [DATA_WIDTH-1:0] WDATA;

  wire [DATA_WIDTH-1:0] RDATA;

  reg AWVALID = 0;

  always @(posedge ACLK) begin

    // A3.1.2 Documents Reset requirements
    if (~ARESETn) begin
      ARVALID <= 1'b0; 
      AWVALID <= 1'b0;
      WVALID <= 1'b0;
    end
    else begin
      // Write Address Channel



    end    
  end





endmodule
