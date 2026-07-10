class agent_counter extends uvm_agent;

  `uvm_component_utils (agent_counter)
  function new (string name = "agent_counter", uvm_component parent = null);
      super.new (name, parent);
    endfunction
  
  	//passive agent
    monitor_counter     mon0;
  
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    mon0 = monitor_counter::type_id::create ("mon0", this);
  endfunction
  
endclass
