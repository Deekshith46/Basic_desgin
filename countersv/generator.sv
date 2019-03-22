
class generator;
rand transaction trans;
int repeat_count;
mailbox gen2drv;
event ended;

    function new(mailbox gen2drv);
    this.gen2drv = gen2drv;
    endfunction

    task main();
    repeat(repeat_count)begin
    trans = new();
        if(!trans.randomize()) $fatal("GEN :: transa randomization failed");
        trans.display("[GEN]");
        gen2drv.put(trans);
    end
    -> ended;
    endtask
endclass
