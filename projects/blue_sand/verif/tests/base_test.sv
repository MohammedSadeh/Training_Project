class base_test extends uvm_test;

  //factory register
  `uvm_component_utils (base_test)
  
  function new (string name = "base_test", uvm_component parent = null);
      super.new (name, parent);
  endfunction

// Step 2: Declare other testbench components - my_env and my_cfg are assumed to be defined
      env   my_env; 
      virtual apb_if vif;
      // Instantiate and build components declared above
      virtual function void build_phase (uvm_phase phase);
         super.build_phase (phase);
         my_env  = env::type_id::create ("my_env", this);

         //get the if
         if (! uvm_config_db #(virtual apb_if) :: get (this, "", "apb_vif", vif)) begin
                   `uvm_fatal (get_type_name (), "Didn't get handle to virtual interface apb_if")
         end
      endfunction
      
  
   // print the topology for debug
      virtual function void end_of_elaboration_phase (uvm_phase phase);
         uvm_top.print_topology ();
      endfunction
  

      //reset phase
      virtual task reset_phase(uvm_phase phase);
        super.reset_phase(phase);
        phase.raise_objection(this, "Applying reset");
        //unknown phase
        vif.presetn <= 1;
        repeat($urandom_range(4,10)) @(posedge vif.pclk);

        //reset phase
        vif.presetn <= 0;
        vif.psel <= 0;
        vif.penable <= 0;
        vif.pwrite <= 0;
        vif.paddr <= 0;
        vif.pwdata <= 0;

        repeat($urandom_range(10,20)) @(posedge vif.pclk);
        vif.presetn <= 1;
        phase.drop_objection(this, "Reset Don");
      endtask
  
endclass
