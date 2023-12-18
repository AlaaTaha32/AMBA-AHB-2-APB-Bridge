module AHB_Master(
    input Hclk,
    input Hresetn,
    input Hreadyout,
    input [1:0] Hresp,
    input [31:0] Hrdata,
    output reg Hwrite,
    output reg Hreadyin,
    output reg [1:0] Htrans,
    output reg [31:0] Hwdata,
    output reg [31:0] Haddr);

reg [2:0] Hburst;
reg [2:0] Hsize;
integer i;

task Write_transfer();
 begin
  @(posedge Hclk) // First cycle, address phase
  #2;
   begin
    Hwrite=1; // Enable write
    Htrans=2'b10; // Indicates NONSEQ --> single write transfer
    Hsize=3'b000; // 8 bits size of transfer
    Hburst=3'b000; // No burst --> single transfer
    Hreadyin=1;
    Haddr=32'h8000_0001;  // Address bus
   end

  @(posedge Hclk) // Second cycle, data phase
  #2;
   begin
    Htrans=2'b00; // IDLE state, no further write transfers
    Hwdata=32'h29; // Data bus 
   end 
 end
endtask


task Read_transfer();
 begin
  @(posedge Hclk) // Address phase
  #2;
   begin
    Hwrite=0; // Disable write --> read transfer
    Htrans=2'b10; // Indicates NONSEQ --> single read transfer
    Hsize=3'b000; // 8 bits size of transfer
    Hburst=3'b000; // No burst --> single transfer
    Hreadyin=1;
    Haddr=32'h8000_00A2; // Address bus
   end
  
  @(posedge Hclk) // Data phase, data is driven by APB in read transfer
  #2;
   begin
    Htrans=2'b00; // IDLE state, no further read transfers
   end 
 end
endtask

task Burst_incr4_write();
  begin
  @(posedge Hclk) // First cycle, address phase
  #2;
   begin
    Hwrite=1; // Enable write
    Htrans=2'b10; // Indicates NONSEQ --> single write transfer
    Hsize=3'b000; // 8 bits size of transfer
    Hburst=3'b000; // No burst --> single transfer
    Hreadyin=1;
    Haddr=32'h8000_0001;  // Address bus
   end

  @(posedge Hclk) // Second cycle, first data phase
  #2;
   begin
    Haddr = Haddr + 1;
    Hwdata = ($random)%256; // Generates random 8-bits number for each transfer
    Htrans = 2'b11; // Indicates SEQ --> burst of transfers
    Hburst=3'b011;  // 4 beat incrementing burst
   end

   for (i=0; i<2; i=i+1) begin // Additional two transfers
    @(posedge Hclk) begin
      #2;
      Haddr = Haddr + 1; // Address for next cycle
      Hwdata = ($random)%256;
      Htrans = 2'b11;
      Hburst=3'b011;
    end
   end

  @(posedge Hclk) // Last transfer
  #2;
  begin
    Hwdata={$random}%256;
    Htrans=2'd0;
  end
  end
endtask


  task Burst_incr4_read();
    begin
      @(posedge Hclk) // Address phase
      #2;
      begin
        Hwrite=0; // Disable write --> read transfer
        Htrans=2'b10; // Indicates NONSEQ --> single read transfer
        Hsize=3'b000; // 8 bits size of transfer
        Hburst=3'b000; // No burst --> single transfer
        Hreadyin=1;
        Haddr=32'h8000_00A2; // Address bus
      end
    for(i=0;i<3;i=i+1)
    begin
      @(posedge Hclk); // Address phase
      #2;
      begin
        Haddr=Haddr+1;
        Htrans = 2'b11;
        Hburst=3'b011;
      end
      @(posedge Hclk); // Data phase
    end
    end 
  endtask
endmodule
