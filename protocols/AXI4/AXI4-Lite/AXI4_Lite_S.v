

module AXI4_Lite_S (
    input ACLK,
    input ARESETn,

    // Write data channel
    input WVALID,
    input WDATA,
    input WSTRB,
    output WREADY,

    output AWREADY,  
    input ARVALID,
    input ARADDR,
    input ARPROT
  );
  
  parameter DATA_WIDTH = 32;

  // Parameter Check
  initial begin
    if (DATA_WIDTH != 32 && DATA_WIDTH != 64) begin
      $display("Error: WIDTH must be either 32 or 64.");
      $stop;
    end
  end

  localparam WSTRB_WIDTH = DATA_WIDTH / 8;   

  wire ACLK;
  wire ARESETn;

  /* ************** */
  // Write Channels //

  // Write data channel
  reg WREADY = 0;
  wire WVALID;
  wire [DATA_WIDTH - 1:0] WDATA;
  wire [WSTRB_WIDTH - 1:0] WSTRB;

  //  Write response channel
  wire BREADY;
  reg BRESP = 0;
  reg BVALID = 0;

  //  Write address channel
  reg AWREADY = 0;
  wire AWVALID;
  wire AWADDR;
  wire AWPROT;
  /* ************** */

  /* ************** */
  // Read Channels //

  //  Read address channel
  reg ARREADY = 0;
  wire ARVALID;
  wire ARADDR;
  wire ARPROT;

  // Read data channel
  wire RREADY;
  reg RVALID = 0;
  reg [DATA_WIDTH - 1:0] RDATA = 0;
  reg RRESP = 0;
  /* ************** */


  always @(posedge clk) begin
    
    // A3.1.2 Documents Reset requirements
    if (~ARESETn) begin
      AWREADY <= 0;
    end

  end


endmodule
