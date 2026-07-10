interface counter_if(input pclk);

  //parameter : COUNT_WIDTH is in parameters.sv file
  
  logic [`COUNT_WIDTH-1:0] count;
  
  //modports to identify directions of the signals in the dut and the test
  
  //signals direction for the dut - count is output
  modport DUT (input pclk, output count);
  
  //signals direction for the test - count is input
  modport TEST (input pclk, count);
endinterface
