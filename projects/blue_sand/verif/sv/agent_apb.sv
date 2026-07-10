class agent_apb extends uvm_agent;

  //factory register
  `uvm_component_utils (agent_apb)
  
  function new (string name = "agent_apb", uvm_component parent = null);
      super.new (name, parent);
  endfunction

  // agent contains three components: driver, monitor, sequencer
  driver_apb                  		 drv0;
  monitor_apb                 		 mon0;
  uvm_sequencer #(sequence_item_apb) seqr0;
  
  
  //build phase: construct objects, set or get from the configuration DB
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
	// If this UVM agent is active, then build driver, and sequencer
    if (get_is_active()) begin
      seqr0 = uvm_sequencer#(sequence_item_apb)::type_id::create ("seqr0", this);
      drv0 = driver_apb::type_id::create ("drv0", this);
    end
    // Both active and passive agents need a monitor
    mon0 = monitor_apb::type_id::create ("mon0", this);
  endfunction
  
  //connect phase: connect the driver with the sequencer 
  virtual function void connect_phase (uvm_phase phase);
  // Connect the driver to the sequencer if this agent is Active
    if (get_is_active())
      drv0.seq_item_port.connect (seqr0.seq_item_export);
  endfunction
  
endclass
