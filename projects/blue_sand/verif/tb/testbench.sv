module tb_top;
 import uvm_pkg::*;
 import env_pkg::*;
 import tests_pkg::*;

  bit clk;
  
  //clock generator
  always #10 clk <= ~clk;


   // Instantiate the Interface and pass it to Design
   apb_if         _apb_if (clk);
   counter_if     _counter_if(clk);
   env_cfg		  env_cfg1;
  
  //dut instantiation with the interface
  wrapper_dut dut(._apb_if(_apb_if), ._counter_if(_counter_if));
  assign _counter_if.presetn = _apb_if.presetn;
   initial begin
     //set the apb and counter interfaced in the config DB
     uvm_config_db #(virtual apb_if)::set (null, "*", "apb_vif", _apb_if);
     uvm_config_db #(virtual counter_if)::set (null, "*", "counter_vif", _counter_if);
     uvm_config_db #(env_cfg)::set (null, "*", "env_cfg", env_cfg1);

     
     //run the base test
     run_test ("base_test");
     
   end

endmodule
