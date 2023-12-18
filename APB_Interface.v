module APB_Interface(
    input Pwrite, // Control signal
    input Penable, // Strobe signal
    input [2:0] Pselx, // Select signal
    input [31:0] Paddr, // Address signal
    input [31:0] Pwdata, // Write data
    output Pwriteout,
    output Penableout,
    output [2:0] Pselxout,
    output [31:0] Paddrout,
    output [31:0] Pwdataout,
    output reg [31:0] Prdata);

assign Penableout=Penable;
assign Pselxout=Pselx;
assign Pwriteout=Pwrite;
assign Paddrout=Paddr;
assign Pwdataout=Pwdata;

always@(*)
 begin
  if (~Pwrite && Penable) // Enabled read transfer
   Prdata=($random)%256; // Randomizes a message that is less than 256 (maximum value of 8-bits message)
  else
   Prdata=0;
 end

endmodule
