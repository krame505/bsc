typedef Bit#(4) TD ;

// TODO:
//   vectors
//   sub interface
//   tagged union
//   all data types ?

typedef struct {
   TD a;
   TD b;
   TD c;
  } TS deriving(Bits,Eq);

// (* always_ready, always_enabled *)
interface Test6;
   method Action method1 ( int in1, int in2 );
   method int    method2 ( int in1, int in2 );
   method int    method3 ();
   method ActionValue#(int)  method4 ( int in1 );

   method Action method5 ( TD in1 );
   method int    method6 ( TS in1 );
   method TS     method7 ();
   method ActionValue#(TD)  method8 ();
   method ActionValue#(TD)  method9 ( TD in1 );
endinterface

(* synthesize *)
module mkTest6#(Clock c1, Int#(4) pIn)( Test6 );
   method Action             method1 ( int in1, int in2 )  = ?;
   method int                method2 ( int in1, int in2 )  = ?;
   method int                method3 ()                    = ?;
   method ActionValue#(int)  method4 ( int in1 )           = ?;

   method Action             method5 ( TD in1 )            = ?;
   method int                method6 ( TS in1 )            = ?;
   method TS                 method7 ()                    = ?;
   method ActionValue#(TD)   method8 ()                    = ?;
   method ActionValue#(TD)   method9 ( TD in1 )            = ?;

endmodule


