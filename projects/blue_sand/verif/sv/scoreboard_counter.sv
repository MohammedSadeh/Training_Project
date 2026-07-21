`uvm_analysis_imp_decl(_apb);
`uvm_analysis_imp_decl(_counter);

class scoreboard_counter extends uvm_scoreboard;
  `uvm_component_utils (scoreboard_counter)
  
  uvm_analysis_imp_apb #(sequence_item_apb, scoreboard_counter) data_export_apb;
  uvm_analysis_imp_counter #(sequence_item_counter, scoreboard_counter) data_export_counter;
  
  //register modelling
  bit [`DATA_WIDTH-1:0] reg_model [bit [`ADDR_WIDTH-1:0]];
  bit [`DATA_WIDTH-1:0] mask [bit [`ADDR_WIDTH-1:0]];
  
  virtual counter_if vif;
 
  sequence_item_apb apb_items_queue[$]; 

  //expected output
  bit [`COUNT_WIDTH-1:0] exp_count;
  bit main_loaded;
  bit enabled_now;

  function new (string name = "scoreboard_counter", uvm_component parent = null);
      super.new (name, parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    data_export_apb = new ("data_export_apb", this);
    data_export_counter = new ("data_export_counter", this);
    
    if (! uvm_config_db #(virtual counter_if) :: get (this, "", "counter_vif", vif)) begin
      `uvm_error (get_type_name (), "counter interface not found")
   end
    
    //mask the upper unused bits in reg_model
    
    //counter_en_config_reg
    mask['h00] = 'h1;
    //counter_main_load_config_reg
    mask['h01] = 'hFF;
    //counter_secondery_load_config_reg
    mask['h02] = 'hFF;
    //counter_number_of_cycles_config_reg
    mask['h03] = 'hFF;
    //counter_mode_control_config_reg
    mask['h04] = 'h07;
    //counter_current_count_status_reg
    mask['h05] = 'hFF;
    //counter_wrap_count_counter_reg
    mask['h06] = '1; //all ones
    
    exp_count = 0;
    main_loaded = 0;
    enabled_now = 0;

    //build the reg model with deafults (zeros)
    reg_model['h00] = 0;
    reg_model['h01] = 0;
    reg_model['h02] = 0;
    reg_model['h03] = 0;
    reg_model['h04] = 0;
    reg_model['h05] = 0;
    reg_model['h06] = 0;
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
        apply_apb_trans();
        ref_model();
    join_none
  endtask

  virtual function void write_apb (sequence_item_apb pkt_apb);
	// What should be done with the data packet received comes here
    apb_items_queue.push_front(pkt_apb);    
  endfunction  
  
  virtual function void write_counter (sequence_item_counter pkt_counter);
	// What should be done with the data packet received comes here
    //print it
    `uvm_info("SCB_Count", pkt_counter.conv2str(), UVM_HIGH)
    if (pkt_counter.count !== exp_count) begin
      `uvm_error("SCB", $sformatf("Mismatch [Count] @%0t: exp = 0X%0h act = 0X%h", $time, exp_count, pkt_counter.count));
    end
  endfunction
  
  task apply_apb_trans();
    sequence_item_apb pkt_apb;
    forever begin
        pkt_apb = new();
        wait(apb_items_queue.size() > 0);
        pkt_apb = apb_items_queue.pop_back();

        //write
        if(pkt_apb.pwrite == 1) begin
            //only if te register is RW (not RO or RC)
            if(pkt_apb.paddr !== 'h05 && pkt_apb.paddr !== 'h06) begin
                if(pkt_apb.paddr === 'h00 && reg_model['h00] === 0) begin
                    enabled_now = 1;
                end
                reg_model [pkt_apb.paddr] = pkt_apb.pwdata & mask[pkt_apb.paddr];
                `uvm_info("SCB-Reg Model", $sformatf("Write to address %0h,Value %0h", pkt_apb.paddr, reg_model[pkt_apb.paddr]), UVM_LOW);
            end
            //if the write to main load value -> update exp
            if(pkt_apb.paddr === 'h01) begin
                exp_count = reg_model['h01];
                main_loaded = 1;
                enabled_now = 1;
                `uvm_info("MAIN_LOAD", $sformatf("@%0t: Load Main Value to 0x%0h",$time, exp_count), UVM_LOW)
            end

        end
    
        //read
        else begin
            if (reg_model.exists(pkt_apb.paddr)) begin
                if (!( $signed(pkt_apb.prdata & mask[pkt_apb.paddr]) >= $signed(reg_model[pkt_apb.paddr] - 3)
                    && ($signed(pkt_apb.prdata & mask[pkt_apb.paddr])) <= $signed(reg_model[pkt_apb.paddr] + 3) )) begin
                    `uvm_error("SCB", $sformatf("Mismatch [READ] @0x%0h: exp = 0x%0h act = 0x%0h",pkt_apb.paddr, reg_model[pkt_apb.paddr], pkt_apb.prdata & mask[pkt_apb.paddr]));
                end
        
                //if RC clear it
                if(pkt_apb.paddr === 'h06) begin
                    reg_model[pkt_apb.paddr] = '0;
                end
            end
            //if not exist
            else begin
                `uvm_error("SCB", $sformatf("Mismatch [READ Not Exist in Reg model] @0x%0h: act = 0x%0h", pkt_apb.paddr, pkt_apb.prdata & mask[pkt_apb.paddr]));
            end
        end
    end
  endtask

  task ref_model();
    int count;
    @(negedge vif.presetn) begin
      exp_count = 0;
    end

    forever begin
      count = reg_model['h03];
      @(posedge vif.pclk);
      #0;
      if (enabled_now) begin
          count = count + 1;
          enabled_now = 0;
      end
      if(reg_model['h00] == 1 && vif.presetn === 1) begin //check if counter is enable

        while (count != 0) begin
        main_loaded = 0;
          @(posedge vif.pclk);
          #0;
          if(main_loaded === 1) begin
              main_loaded =0;
              count = reg_model['h03];
          end
          else begin
              count -= 1;
          end
        end
     
     if(reg_model['h00] == 1) begin //check if enabled
        //dec or inc based on direction
        //increment
        if (reg_model['h04][2] == 1) begin

          //Free running mode
          if(reg_model['h04][1:0] == 0) begin
              if(&exp_count) begin //reach max value
                  exp_count = 0; //wrap to 0
              end
              else begin //count normally
                  exp_count += 1;
              end
          end

          //Single Wrap point mode
          if(reg_model['h04][1:0] == 1) begin
              if(&exp_count) begin //reach max value
                  exp_count = reg_model['h01]; //wrap to main load
              end
              //if reached main load value when counting up
              else if(exp_count == reg_model['h01]) begin
                  exp_count = 0; //wrap to 0
              end
              else begin
                  exp_count += 1; //count normally
              end
          end

          //Double wrap point mode
          if(reg_model['h04][1:0] == 2) begin
              //if reached secondery load value
              if(exp_count == reg_model['h02]) begin
                  exp_count = reg_model['h01]; //wrap to main load value
              end

              //if reached main load value
              else if(exp_count == reg_model['h01]) begin
                  exp_count = reg_model['h02]; // wrap to secondey load value
              end

              else begin
                  exp_count += 1; //normally count
              end
          end

          //special single wrap point mode
          if(reg_model['h04][1:0] == 3) begin
              //if reached max value
              if(&exp_count) begin
                  exp_count = reg_model['h01];
              end

              //if reached 0
              else if(exp_count == 0) begin
                  exp_count = reg_model['h01];
              end

              //else normally
              else begin
                  exp_count += 1;
              end
          end

        end

        //decrement
        else begin
          //Free running mode
          if(reg_model['h04][1:0] == 0) begin
              if(exp_count == 0) begin // reach min value (0)
                  exp_count = '1; //(all ones, wrap to max)
              end
              else begin //count normally
                  exp_count -= 1;
              end
          end

          //Single Wrap point mode
          if(reg_model['h04][1:0] == 1) begin
              if(exp_count == 0) begin
                  exp_count = reg_model['h01]; //wrap to main load
              end
              //if reached main load value when counting down
              else if(exp_count == reg_model['h01]) begin
                  exp_count = '1; //all ones (wrap to max)
              end
              else begin
                  exp_count -= 1; //normally count
              end
          end

          
          //Double wrap point mode
          if(reg_model['h04][1:0] == 2) begin
              //if reached secondery load value
              if(exp_count == reg_model['h02]) begin
                  exp_count = reg_model['h01]; //wrap to main load value
              end

              //if reached main load value
              else if(exp_count == reg_model['h01]) begin
                  exp_count = reg_model['h02]; // wrap to secondey load value
              end

              else begin
                  exp_count -= 1; //normally count
              end
          end

          //special single wrap point mode
          if(reg_model['h04][1:0] == 3) begin
              //if reached max value
              if(&exp_count) begin
                  exp_count = reg_model['h01];
              end

              //if reached 0
              else if(exp_count == 0) begin
                  exp_count = reg_model['h01];
              end

              //else normally
              else begin
                  exp_count -= 1;
              end
          end
      end

      reg_model['h05] = exp_count & mask['h05];
      `uvm_info("SCB", $sformatf("@%t: exp_count = reg_model[0x05] = %0h", $time, exp_count), UVM_LOW)
    end
   end
  end
  endtask 
endclass
