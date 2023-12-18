module Bridge_FSM (
    input Hclk,
    input Hresetn,
    input Valid,
    input Hwrite,
    input Hwritereg,
    input [31:0] HWdata,
    input [31:0] HWdata1,
    input [31:0] HWdata2,
    input [31:0] Haddr,
    input [31:0] Haddr1,
    input [31:0] Haddr2,
    input [31:0] PRdata,
    input [2:0] Tempselx,
    output reg Pwrite,
    output reg Penable,
    output reg Hreadyout,
    output reg [2:0] Pselx,
    output reg [31:0] Paddr,
    output reg [31:0] PWdata
);
    
    reg Penable_Temp,Hreadyout_Temp,Pwrite_Temp;
    reg [2:0] Pselx_Temp;
    reg [31:0] Paddr_Temp, Pwdata_Temp;
    
    localparam ST_IDLE = 3'd0, ST_WWAIT = 3'd1, ST_READ = 3'd2, 
    ST_WRITE = 3'd3, ST_WRITEP = 3'd4, ST_RENABLE = 3'd5, 
    ST_WENABLE = 3'd6, ST_WENABLEP = 3'd7;

    reg [2:0] Current_state, Next_state;

    // Current state logic
    always @(posedge Hclk) begin
        if(~Hresetn) Current_state <= ST_IDLE; // Active low reset
        else Current_state <= Next_state;
    end

    // Next state logic
    always @(Current_state, Valid, Hwrite, Hwritereg) begin
        case (Current_state)
            ST_IDLE: begin
                if(~Valid) Next_state = ST_IDLE; // No transfers in case of invalid signals
                else if(Valid && Hwrite) Next_state = ST_WWAIT;  // Write transfer, wait cycle for data phase
                else Next_state = ST_READ; // Read transfer
            end

            ST_WWAIT: Next_state = (Valid)? ST_WRITEP:ST_WRITE; // Check for another pending write transfer

            ST_READ: Next_state = ST_RENABLE; // ENABLE cycle of read transfer

            ST_WRITE: Next_state = (Valid)? ST_WENABLEP:ST_WENABLE;

            ST_WRITEP: Next_state = ST_WENABLEP;

            ST_RENABLE: begin
                if(~Valid) Next_state = ST_IDLE; // No further transfers
                else if(Valid && Hwrite) Next_state = ST_WWAIT; // Write transfer next
                else Next_state = ST_READ; // Read transfer next
            end

            ST_WENABLE: begin
                if(~Valid) Next_state = ST_IDLE; // No further transfers
                else if(Valid && Hwrite) Next_state = ST_WWAIT; // Write transfer next
                else Next_state = ST_READ; // Read transfer next
            end

            ST_WENABLEP: begin
                if(~Valid && Hwritereg) Next_state = ST_WRITE;
                else if (Valid && Hwritereg) Next_state = ST_WRITEP;
                else Next_state = ST_READ;
            end

            default: Next_state = ST_IDLE;
        endcase
    end

    // Temporary output logic
    always@(*) begin
        case (Current_state)
            ST_IDLE: begin
              if (Valid && ~Hwrite) begin // IDLE to READ
                Paddr_Temp = Haddr;
                Pwrite_Temp = Hwrite;
                Pselx_Temp = Tempselx;
                Penable_Temp = 0;
                Hreadyout_Temp = 0;
              end else if (Valid && Hwrite) begin // IDLE to WWAIT
                Pselx_Temp = 0;
                Penable_Temp = 0;
                Hreadyout_Temp = 1;
              end
              else begin // IDLE to IDLE
                Pselx_Temp = 0;
                Penable_Temp = 0;
                Hreadyout_Temp = 1;
              end
            end

            ST_WWAIT: begin
                if (~Valid) begin // WWAIT to WRITE
                    Paddr_Temp = Haddr1;
                    Pwrite_Temp = 1;
                    Pselx_Temp = Tempselx;
                    Penable_Temp = 0;
                    Pwdata_Temp = HWdata;
                    Hreadyout_Temp = 0;
                end else begin  // WWAIT to WRITEP
                    Paddr_Temp = Haddr1;
                    Pwrite_Temp = 1;
                    Pselx_Temp = Tempselx;
                    Pwdata_Temp = HWdata;
                    Penable_Temp = 0;
                    Hreadyout_Temp = 0;
                end
             end
            
           ST_READ: begin // READ to RENABLE
            Penable_Temp = 1;
            Hreadyout_Temp = 1;
           end

           ST_WRITE: begin  // WRITE to WENABLE or WENABLEP
                Penable_Temp = 1;
                Hreadyout_Temp = 1;
           end

           ST_WRITEP: begin // WRITEP to WENABLEP
            Penable_Temp = 1;
            Hreadyout = 1;
           end

           ST_RENABLE: begin
            if(Valid && ~ Hwrite) begin // RENABLE to READ
                Paddr_Temp = Haddr;
                Pwrite_Temp = Hwrite;
                Pselx_Temp = Tempselx;
                Penable_Temp = 0;
                Hreadyout_Temp = 0;
            end
            else if(Valid && Hwrite) begin // RENABLE to WWAIT
                Pselx_Temp = 0;
                Penable_Temp = 0;
                Hreadyout_Temp = 1;
            end
            else begin // RENABLE to IDLE
                Pselx_Temp = 0;
                Penable_Temp = 0;
                Hreadyout_Temp = 1;
            end
           end

           ST_WENABLEP: begin
            if(~Valid && Hwritereg) begin // WENABLE to WRITEP
                Paddr_Temp = Haddr2;
                Pwrite_Temp = Hwrite;
                Pselx_Temp = Tempselx;
                Penable_Temp = 0;
                Pwdata_Temp = HWdata;
                Hreadyout_Temp =0;
            end
            else begin // WENABLEP to WRITE or READ 
                Paddr_Temp = Haddr2;
                Pwrite_Temp = Hwrite;
                Pselx_Temp = Tempselx;
                Pwdata_Temp = HWdata;
                Penable_Temp = 0;
                Hreadyout_Temp = 0;
            end
           end

         ST_WENABLE: begin
            if(Valid && ~Hwritereg) begin 
                Pselx_Temp = 0;
                Penable_Temp = 0;
                Hreadyout_Temp = 0;
            end
            else begin
                Pselx_Temp = 0;
                Penable_Temp = 0;
                Hreadyout_Temp = 0;
            end
         end   
        endcase
    end

    // Sequential output logic
    always @(posedge Hclk) begin // Checks for synchronous reset
        if(~Hresetn) begin
            Paddr <= 0;
            Pselx <= 0;
            PWdata <= 0;
            Penable <= 0;
            Hreadyout <= 0;
        end
        else begin
            Paddr <= Paddr_Temp;
            Pwrite <= Pwrite_Temp;
            Pselx <= Pselx_Temp;
            PWdata <= Pwdata_Temp;
            Penable <= Penable_Temp;
            Hreadyout <= Hreadyout_Temp;
        end
    end
endmodule
