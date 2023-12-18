module AHB_Slave(
    // Global signals
	input Hclk,
    input Hresetn,
	// Address and control signals
    input Hwrite,
    input Hreadyin,
    input [1:0] Htrans,
    input [31:0] Haddr, // New one 
    input [31:0] Hwdata,
	input [31:0] Prdata,
	// Outputs
    output reg valid,
    output reg Hwritereg,
    output reg [31:0] Haddr1, // Current address
    output reg [31:0] Haddr2, // Next address
    output reg [31:0] Hwdata1,
    output reg [31:0] Hwdata2,
    output [31:0] Hrdata,
    output reg [2:0] tempselx,
    output [1:0] Hresp);

// Implementing AHB Pipeline Logic for address,data and control Signals
	always @(posedge Hclk)
		begin
			if (~Hresetn) // Active low reset
				begin
					Haddr1<=0;
					Haddr2<=0;
				end
			else
				begin
					Haddr1<=Haddr;
					Haddr2<=Haddr1;
				end
		end
	always@(posedge Hclk)
		begin
			if (~Hresetn)
				begin
					Hwdata1<=0;
					Hwdata2<=0;
				end
			else
				begin
					Hwdata1<=Hwdata;
					Hwdata2<=Hwdata1;
				end
		end
	always @(posedge Hclk)
		begin	
			if (~Hresetn)
				Hwritereg<=0;
			else
				Hwritereg<=Hwrite;
		end
// Implementing Valid Logic Generation
	always @(Hreadyin,Haddr,Htrans,Hresetn)
		begin
			valid=0;
			if (Hresetn && Hreadyin && (Haddr>=32'h8000_0000 && Haddr<32'h8C00_0000) && (Htrans==2'b10 || Htrans==2'b11))
			// For a valid transfer --> reset is off, READY signal is high (previous transfer is completed),
			// valid address, and SEQ or NONSEQ HTRANS signal
				valid=1;
		end
/// Implementing Tempselx Logic
	always @(Haddr,Hresetn) // Decoding address bus into tempselx
		begin
			tempselx=3'b000;
			if (Hresetn && Haddr>=32'h8000_0000 && Haddr<32'h8400_0000)
				tempselx=3'b001;
			else if (Hresetn && Haddr>=32'h8400_0000 && Haddr<32'h8800_0000)
				tempselx=3'b010;
			else if (Hresetn && Haddr>=32'h8800_0000 && Haddr<32'h8C00_0000)
				tempselx=3'b100;

		end
assign Hrdata = Prdata; // Read from APB
assign Hresp=2'b00;	// OKAY signal --> transfer is proceeding correctly
endmodule
