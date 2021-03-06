import Vector::*;

(* synthesize *)
module sysVectorUninitOK2();

  Vector#(5, UInt#(32)) v;

  for(Integer i = 1; i < 5; i = i + 1)
    v[i] = fromInteger(2*i);

  rule test;
    for(Integer j = 1; j < 5; j = j + 1)
       $display("v[%0d] = %0d", j, v[j]);
    $finish(0);
  endrule

endmodule

