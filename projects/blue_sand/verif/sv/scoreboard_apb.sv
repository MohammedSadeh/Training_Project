class scoreboard_apb extends uvm_scoreboard;
  //factory register
  `uvm_component_utils (scoreboard_apb)
  
  //implemenation port to recieve from monitor and do checking on the data
  uvm_analysis_imp #(sequence_item_apb, scoreboard_apb) data_export;
  
  function new (string name = "scoreboard_apb", uvm_component parent = null);
      super.new (name, parent);
  endfunction
  
  
  //build phase: construct objects, set or get from config DB
  function void build_phase (uvm_phase phase);
	data_export = new ("data_export", this);
  endfunction
  
  virtual function void write (sequence_item_apb data);
	// What should be done with the data packet received comes here - let's display it
	`uvm_info ("write", $sformatf("Data received = 0x%0h", data), UVM_MEDIUM)
  endfunction
endclass
