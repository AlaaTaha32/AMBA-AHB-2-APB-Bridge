module Top (
    input Hclk,
    input Hresetn,
    input Hwrite,
    input Hreadyin,
    input [1:0] Htrans,
    input [31:0] HWdata,
    input [31:0] Haddr,
    input [31:0] PRdata,
    output Penable,
    output Pwrite,
    output Hreadyout,
    output [1:0] Hresp,
    output [2:0] Pselx,
    output [31:0] PWdata,
    output [31:0] Paddr,
    output [31:0] HRdata
);

    wire Valid;
    wire Hwritereg;
    wire [2:0] tempselx;
    wire [31:0] Haddr1, Haddr2, Hwdata1, Hwdata2;

    AHB_Slave M1(
	.Hclk(Hclk),
    .Hresetn(Hresetn),
    .Hwrite(Hwrite),
    .Hreadyin(Hreadyin),
    .Htrans(Htrans),
    .Haddr(Haddr), 
    .Hwdata(HWdata),
    .Prdata(PRdata),
    .valid(Valid),
    .Hwritereg(Hwritereg),
    .Haddr1(Haddr1), 
    .Haddr2(Haddr2),
    .Hwdata1(Hwdata1),
    .Hwdata2(Hwdata2),
    .Hrdata(HRdata),
    .tempselx(tempselx),
    .Hresp(Hresp)
    );

    Bridge_FSM M2(
    .Hclk(Hclk),
    .Hresetn(Hresetn),
    .Valid(Valid),
    .Hwrite(Hwrite),
    .Hwritereg(Hwritereg),
    .HWdata(HWdata),
    .HWdata1(Hwdata1),
    .HWdata2(Hwdata2),
    .Haddr(Haddr),
    .Haddr1(Haddr1),
    .Haddr2(Haddr2),
    .PRdata(PRdata),
    .Tempselx(tempselx),
    .Pwrite(Pwrite),
    .Penable(Penable),
    .Hreadyout(Hreadyout),
    .Pselx(Pselx),
    .Paddr(Paddr),
    .PWdata(PWdata)
    );
    
endmodule
