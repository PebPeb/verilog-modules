// module fifo_tb;
//   reg clk, rst_n;
//   reg w_en, r_en;
//   reg [7:0] data_in;
//   wire [7:0] data_out;
//   wire full, empty;
  
//   my_fifo fifo(
//     .clk(clk), 
//     .reset(reset),
//     .wr(w_en), 
//     .rd(r_en),
//     .wr_data(data_in),
//     .rd_data(data_out),
//     .empty(empty), 
//     .full(full)
//   );
  
//   always #2 clk = ~clk;
//   initial begin
//     clk = 0; rst_n = 1;
//     w_en = 0; r_en = 0;
//     #3 rst_n = 0;
//     drive(20);
//     drive(40);
//     $finish;
//   end
  
//   task push();
//     if(!full) begin
//       w_en = 1;
//       data_in = $random;
//       #1 $display("Push In: w_en=%b, r_en=%b, data_in=%h",w_en, r_en,data_in);
//     end
//     else $display("FIFO Full!! Can not push data_in=%d", data_in);
//   endtask 
  
//   task pop();
//     if(!empty) begin
//       r_en = 1;
//       #1 $display("Pop Out: w_en=%b, r_en=%b, data_out=%h",w_en, r_en,data_out);
//     end
//     else $display("FIFO Empty!! Can not pop data_out");
//   endtask
  
//   task drive(delay);
//     w_en = 0; r_en = 0;
//     fork
//       begin
//         repeat(10) begin @(posedge clk) push(); end
//         w_en = 0;
//       end
//       begin
//         #delay;
//         repeat(10) begin @(posedge clk) pop(); end
//         r_en = 0;
//       end
//     join
//   endtask
  
//   initial begin 
//     $dumpfile("fifo_tb.vcd"); $dumpvars;
//   end
// endmodule


module fifo_tb;
  reg clk, rst_n;
  reg w_en, r_en;
  reg [7:0] data_in;
  wire [7:0] data_out;
  wire full, empty;
  
  // Parameter for delay
  parameter DELAY_1 = 60;
  parameter DELAY_2 = 20;

  // Instantiate the FIFO module
  fifo #(.DATA_WIDTH(8)) my_fifo (
    .clk(clk), 
    .reset(rst_n), 
    .wr(w_en), 
    .rd(r_en), 
    .wr_data(data_in), 
    .rd_data(data_out), 
    .empty(empty), 
    .full(full)
  );

  // Clock generation
  always #2 clk = ~clk;

  // Testbench initialization
  initial begin
    clk = 0;
    rst_n = 1;
    w_en = 0;
    r_en = 0;
    
    // Apply reset
    #3 rst_n = 1;
    #3 rst_n = 0;

    // Drive operations with different delays
    drive(DELAY_1);
    drive(DELAY_2);
    
    // Finish simulation
    $finish;
  end

  // Push task
  task push;
    if (!full) begin
      w_en = 1;
      data_in = $random;
      #1 $display("Push In: w_en=%b, r_en=%b, data_in=%h", w_en, r_en, data_in);
    end
    else begin
      $display("FIFO Full!! Cannot push data_in=%h", data_in);
    end
  endtask

  // Pop task
  task pop;
    if (!empty) begin
      r_en = 1;
      #1 $display("Pop Out: w_en=%b, r_en=%b, data_out=%h", w_en, r_en, data_out);
    end
    else begin
      $display("FIFO Empty!! Cannot pop data_out");
    end
  endtask

  // Drive task using parameter for delay
  task drive(input integer delay);
    begin
      w_en = 0;
      r_en = 0;
      fork
        begin
          repeat(10) begin
            @(posedge clk);
            push();
          end
          w_en = 0;
        end
        begin
          #delay;
          repeat(10) begin
            @(posedge clk);
            pop();
          end
          r_en = 0;
        end
      join
    end
  endtask

  // Dump waveform
  initial begin 
    $dumpfile("fifo_tb.vcd");
    $dumpvars;
  end
endmodule
