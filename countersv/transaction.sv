
class transaction;
randc bit mod;
 bit[2:0]count;

function void display(input string name);
    $display("------------------------------");
    $display("- %s",name);
    $display("------------------------------");
    $display("-mod = %0d",mod);
    $display("-count = %0d",count);
endfunction
endclass
