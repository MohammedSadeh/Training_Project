class monitor_apb extends uvm_monitor;
  //factory register
  `uvm_component_utils (monitor_apb)

  function new (string name = "monitor_apb", uvm_component parent = null);
		super.new (name, parent);
	endfunction
  
    //virtual interface which connected to an actual interface to the dut
	virtual apb_if vif;
  
  //item that will be sampled from the dut
    sequence_item_apb  data_obj;
  
  //analysis port to broadcast the encapsulated signal (trasnsaction level) to
  //other components such that scoreboard
  uvm_analysis_port  #(sequence_item_apb) mon_analysis_port;
  
  //build phase: construct objects, set or get from configuration DB
  virtual function void build_phase (uvm_phase phase);
   super.build_phase (phase);

   // Create an instance of the declared analysis port
   mon_analysis_port = new ("mon_analysis_port", this);

   // Get virtual interface handle from the configuration DB
    if (! uvm_config_db #(virtual apb_if) :: get (this, "", "apb_vif", vif)) begin
      `uvm_error (get_type_name (), "apb interface not found")
   end
  endfunction
 
  
   //run phase: sample signals form the dut, sampling for coverage,
   // convert bin level sampled signals to item (transaction level) - encapsulated,
   // broadcast this encapsulated item to other components like scoreboard
   virtual task run_phase (uvm_phase phase);
     super.run_phase(phase);
      forever begin
        data_obj = sequence_item_apb::type_id::create("data_obj", this);
        monitor_item(data_obj);

         // Sample functional coverage if required. Data packet class is assumed
         // to have functional covergroups and bins
        
         /*
         if (enable_coverage)
           data_obj.cg_trans.sample();
           */

         // Send data object through the analysis port
        mon_analysis_port.write (data_obj);
      end
   endtask

  virtual task monitor_item(ref sequence_item_apb data_obj);
	//monitoring the output here; the event that should sample at 
    @(posedge vif.pclk iff vif.psel && vif.penable && vif.pready) begin
      //convert signals from bin level to packet (transaction) level
    	data_obj.paddr = vif.paddr;
    	data_obj.pwrite = vif.pwrite;
    	data_obj.pwdata = vif.pwdata;
    
    	data_obj.prdata = vif.prdata;
    	data_obj.pslverr = vif.pslverr;
    end
  endtask

endclass