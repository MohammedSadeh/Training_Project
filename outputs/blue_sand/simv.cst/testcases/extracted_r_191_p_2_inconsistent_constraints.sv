class c_191_2;
    int val = 208;
    rand bit[0:0] pwrite; // rand_mode = ON 

    constraint WITH_CONSTRAINT_this    // (constraint_mode = ON) (/home/st102/Training/projects/blue_sand/verif/seq/double_wrap_point_mode_seq.sv:60)
    {
       (pwrite == val);
    }
endclass

program p_191_2;
    c_191_2 obj;
    string randState;

    initial
        begin
            obj = new;
            randState = "10z1zx001x10xzzxxxz1x10x0zzx1z10xxxzxzzxxzxxzzxxzxzxxzzzxxzzxxxx";
            obj.set_randstate(randState);
            obj.randomize();
        end
endprogram
