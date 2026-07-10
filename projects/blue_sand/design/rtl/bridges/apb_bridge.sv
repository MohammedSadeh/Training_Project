// apb_bridge
module apb_bridge ( pclk,
	            presetn,
	            psel,
	            penable,
	            pwrite_in,
	            paddr_in,
	            pwdata_in,
	            pready_out,
	            prdata_out,
	            pslverr_out,
	            pwrite_out,
	            paddr_out,
	            pwdata_out,
	            pready_in,
	            prdata_in,
	            pslverr_in,
	            ready_s
	          );

  parameter ADDR_WIDTH = 8;
  parameter DATA_WIDTH = 8;
  
  //system control
  input pclk;
  input presetn;
  
  //input data
  input [ADDR_WIDTH-1:0] paddr_in;
  input [DATA_WIDTH-1:0] pwdata_in;
  
  //input data bridge signals
  output logic [ADDR_WIDTH-1:0] paddr_out;
  output logic [DATA_WIDTH-1:0] pwdata_out;
  
  //apb control
  input        psel;
  input        penable;
  input        pwrite_in;
  output logic pready_out;
  
  //apb control bridge signals
  output logic pwrite_out;
  input        pready_in;
  
  //output data
  output logic                  pslverr_out;
  output logic [DATA_WIDTH-1:0] prdata_out;
  
  //output data bridge signals	
  input                  pslverr_in;
  input [DATA_WIDTH-1:0] prdata_in;
  
  //bridge control
  output logic ready_s;

  localparam  IDLE_STATE   = 2'b00;
  localparam  SETUP_STATE  = 2'b01;
  localparam  ACCESS_STATE = 2'b10;

  logic err;
  logic [1:0] current_state;
  
  always @(posedge pclk) begin 
    if(presetn == 0) begin
      err           <= 0;
      ready_s       <= 0;
      paddr_out     <= 0;
      pwdata_out    <= 0;
      pwrite_out    <= 0;
      prdata_out    <= 0;
      pready_out    <= 0;
      pslverr_out   <= 0;
      current_state <= IDLE_STATE;
    end 
    else begin
      paddr_out  <= paddr_in;
      pwdata_out <= pwdata_in;
      pwrite_out <= pwrite_in;
      prdata_out <= prdata_in;
      if(current_state == IDLE_STATE) begin
        if((psel == 0) && (penable == 0)) begin
          current_state <= IDLE_STATE;
        end
        else if((psel == 1) && (penable == 0)) begin
          current_state <= SETUP_STATE;
        end			
      end
      else if(current_state == SETUP_STATE) begin
        if((psel == 1) && (penable == 1)) begin
          err           <= 0;
          ready_s       <= 1;
          current_state <= ACCESS_STATE;
        end
      end
      else if(current_state == ACCESS_STATE) begin
        if(pready_out == 1) begin
          pready_out    <= 0;
          pslverr_out   <= 0;
          current_state <= IDLE_STATE;
        end
        else if((psel == 1) && (penable == 1) && (presetn == 1)) begin
          if(ready_s == 1) begin
            ready_s <= 0;
          end
          if(pslverr_in == 1) begin
            err <= 1;
          end
          if((pready_in == 1) && (pready_out == 0)) begin
            pready_out    <= 1;
            pslverr_out   <= (err|pslverr_in);
          end
        end
        else begin
          current_state <= IDLE_STATE;
        end
      end
    end
  end
endmodule	
