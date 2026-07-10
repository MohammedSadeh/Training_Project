class driver_apb extends uvm_driver #(sequence_item_apb);
  //factory register
  `uvm_component_utils(driver_apb);
  
  //item that will be drived to the dut
  sequence_item_apb item;
  
  function new(string name = "driver_apb", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  //virtual interface which connected to an actual interface to the dut
  virtual apb_if vif;
  
  
  //build phase: construct objects, get or set from the config database 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase (phase);
    //get the virtual interface from the configuration DB 
    if (! uvm_config_db #(virtual apb_if) :: get (this, "", "apb_vif", vif)) begin
      `uvm_fatal (get_type_name (), "Didn't get handle to virtual interface apb_if")
    end
  endfunction
  
  //run phase: get the items from the sequencer and drive them to the vif (bin level)
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
	forever begin
       `uvm_info (get_name(), $sformatf ("Waiting for data from sequencer"), UVM_MEDIUM)
		// 1. Get next item from the sequencer
		seq_item_port.get_next_item (item);

		// 2. Drive signals to the interface
        drive_item(item);
		// Drive remaining signals, put write data/get read data

		// 3. Tell the sequence that driver has finished current item
		seq_item_port.item_done();
	end
  endtask
  
  
  virtual task drive_item(sequence_item_apb item);
    //setup phase: sel asserted; which means the data is valid 
    vif.psel <= 1;
    
    vif.paddr <= item.paddr;
    vif.pwrite <= item.pwrite;
    vif.pwdata <= item.pwdata;
    
    //access phase: enable asserted after one cycle
    @(posedge vif.pclk); 
    vif.penable <= 1;
    
    //wait for pready to finish the transfer
    @(posedge vif.pclk iff vif.pready);

    //deassert enable
    vif.penable <= 0;
    //deassert psel if there is no back to back transfer
    if(item.delay != 0) begin
      vif.psel <= 0;
    end
    
    //wait for delay between transfer
    repeat(item.delay) begin
      @(posedge vif.pclk); 
    end
  endtask
  
endclass