interface apb_if(input pclk);
  
  //parameters : ADDR_WIDTH and DATA_WIDTH are in package param_pkg
  //reset 
  logic presetn;
  //APB Slave Inputs
  logic psel, penable, pwrite;
  logic [`ADDR_WIDTH-1:0] paddr;
  logic [`DATA_WIDTH-1:0] pwdata;
  
  //APB Slave Outputs
  logic [`DATA_WIDTH-1:0] prdata;
  logic pready, pslverr;
  
  //modports to identify directions of the signals in the dut and the test
  
  //signals direction for the dut (APB Slave)
  modport DUT (input pclk, psel, penable, pwrite, paddr, pwdata, presetn, output prdata, pready, pslverr);
  //signals direction for the test (APB Master) 
  modport TEST (input pclk, prdata, pready, pslverr, output psel, penable, pwrite, paddr, pwdata);
endinterface
