class special_single_wrap_point_mode_test extends base_test;

  //factory register
  `uvm_component_utils (special_single_wrap_point_mode_test)
  
  function new (string name = "special_single_wrap_point_mode_test", uvm_component parent = null);
      super.new (name, parent);
  endfunction

  virtual task main_phase(uvm_phase phase);
    special_single_wrap_point_mode_seq my_seq;
    super.main_phase(phase);
    my_seq = special_single_wrap_point_mode_seq::type_id::create("my_seq");
    my_seq.randomize();

    phase.raise_objection(this);
    my_seq.start(my_env.agt_apb.seqr0);
    phase.drop_objection(this);
  endtask
      
endclass
