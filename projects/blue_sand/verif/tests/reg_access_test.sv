class reg_access_test extends base_test;

    //factroy register
    `uvm_component_utils (reg_access_test)

    function new (string name ="reg_access_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // Start a sequence
    virtual task main_phase (uvm_phase phase);
        apb_read_write_seq my_seq = apb_read_write_seq::type_id::create ("my_seq");
        super.main_phase(phase);
        // Create and instantiate the sequence
        my_seq.randomize();
        
        // Raise objection - else this test will not consume simulation time
        phase.raise_objection (this);
        // Start the sequence on a given sequencer
        my_seq.start (my_env.agt_apb.seqr0);
        
        // start other sequences, and multiple agents
        
        // Drop objection - else this test will not finish
        phase.drop_objection (this);
    endtask
endclass
