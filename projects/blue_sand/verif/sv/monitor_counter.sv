class monitor_counter extends uvm_monitor;
  `uvm_component_utils (monitor_counter)

  function new (string name = "monitor_counter", uvm_component parent = null);
		super.new (name, parent);
	endfunction

	virtual counter_if vif;
    sequence_item_counter  data_obj;
  //analysis port to broadcast the encapsulated signal (trasnsaction level) to
  //other components such that scoreboard
  uvm_analysis_port  #(sequence_item_counter) mon_analysis_port;
  
  virtual function void build_phase (uvm_phase phase);
   super.build_phase (phase);

   // Create an instance of the declared analysis port
   mon_analysis_port = new ("mon_analysis_port", this);

   // Get virtual interface handle from the configuration DB
    if (! uvm_config_db #(virtual counter_if) :: get (this, "", "counter_vif", vif)) begin
      `uvm_error (get_type_name (), "counter interface not found")
   end
  endfunction
 
   virtual task run_phase (uvm_phase phase);
     super.run_phase(phase);
      data_obj = sequence_item_counter::type_id::create ("data_obj", this);
      forever begin
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

  virtual task monitor_item(ref sequence_item_counter data_obj);
	//monitoring the output here
    @(posedge vif.pclk);
  endtask

endclass