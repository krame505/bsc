//Signal from Argument to Return value of another method,
//Should show when using -dpathsPostSched flag

package Argument2ReturnValue;

import FIFO :: *;

interface Argument2ReturnValueInter;
    method Action start (Bit #(8) inp);
    method Bit #(8) result();
endinterface

(* synthesize *)

module mkArgument2ReturnValue(Argument2ReturnValueInter);

    FIFO #(Bit #(8)) my_fifo();
    mkFIFO the_my_fifo (my_fifo);

    Reg #(Bit #(8)) counter();
    mkReg #(0) the_counter (counter);

    RWire #(Bit #(8)) x();
    mkRWire the_x (x);

    rule always_fire;
        counter <= counter + 1;
    endrule

    method Action start (inp);
        my_fifo.enq (counter);
        x.wset (inp);
    endmethod

    method result;
        return (unJust (x.wget));
    endmethod

endmodule


endpackage
