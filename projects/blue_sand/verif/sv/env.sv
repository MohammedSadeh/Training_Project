class env extends uvm_env;

  //factory register
  `uvm_component_utils (env)
  function new (string name = "env", uvm_component parent = null);
    super.new (name, parent);
  endfunction
  
  //env cmponents: agents, scoreboards
  agent_apb				agt_apb;
  agent_counter			agt_counter;
  //scoreboard_apb 		scbd_apb;
  scoreboard_counter 	scbd_counter;
  //configurations object for the environment
  env_cfg				env_cfg_obj; 

  // Build components within the "build_phase"
  virtual function void build_phase (uvm_phase phase);
    super.build_phase (phase);
    agt_apb = agent_apb::type_id::create ("agt_apb", this);
    agt_counter = agent_counter::type_id::create ("agt_counter", this);
    //scbd_apb	= scoreboard_apb::type_id::create ("scbd_apb", this);
    scbd_counter	= scoreboard_counter::type_id::create ("scbd_counter", this);
    
    //get the cfg from the config DB
    if(! uvm_config_db #(env_cfg)::get(this, "", "env_cfg", env_cfg_obj))
      `uvm_fatal (get_type_name (), "Did not get a configuration object for env")
  endfunction
  
   virtual function void connect_phase (uvm_phase phase);
      // Connect the scoreboard with the agent
     //agt_apb.mon0.mon_analysis_port.connect (scbd_apb.data_export);
    agt_apb.mon0.mon_analysis_port.connect (scbd_counter.data_export_apb);
    agt_counter.mon0.mon_analysis_port.connect (scbd_counter.data_export_counter);
     //connect different agents
   endfunction
endclass