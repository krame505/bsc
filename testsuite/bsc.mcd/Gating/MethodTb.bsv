import Clocks::*;

// Clock period
Integer p1 = 10;

// the initial value of the registers will be AA
Bit#(8) init_val = 8'hAA;

// function to make $stime the same for Bluesim and Verilog
function ActionValue#(Bit#(32)) adj_stime(Integer p);
   actionvalue
      let adj = (p + 1) / 2;
      let t <- $stime();
      if (genVerilog)
         return (t + fromInteger(adj));
      else
         return t;
   endactionvalue
endfunction

(* synthesize *)
module sysMethodTb();
   Reg#(Bit#(8)) counter <- mkReg(0);

   GatedClockIfc g1 <- mkGatedClockFromCC(True);
   Reg#(Bit#(8)) gate_diff <- mkReg(1);
   Reg#(Bit#(8)) gate_count <- mkReg(0);
   (* fire_when_enabled *)
   rule update_gate (gate_count == counter);
      Bool gate_on = (gate_count[0] == 0);
      g1.setGateCond(gate_on);
      gate_count <= gate_count + gate_diff;
      gate_diff <= gate_diff + 1;
   endrule
   Clock clk1 = g1.new_clk;

   GatedClockIfc g2 <- mkMethodTb_Gate(clocked_by clk1);
   Clock clk2 = g2.new_clk;

   Ifc s <- mkMethodTb(clocked_by clk2);

   // avoid the need for reset
   Reg#(Bit#(8)) rg1 <- mkRegU(clocked_by clk1);

   (* fire_when_enabled *)
   rule r1;
      rg1 <= rg1 + 1;
      g2.setGateCond(!g2.getGateCond);
   endrule

   (* fire_when_enabled *)
   rule r2;
      s.rg2 <= s.rg2 + 1;
   endrule

   (* fire_when_enabled *)
   rule tick;
      counter <= counter + 1;
      $display("(%d) counter = %h, rg1 = %h, rg2 = %h",
               adj_stime(p1), counter, rg1, s.rg2);
      if (s.rg2 > (init_val + 17))
         $finish(0);
   endrule
endmodule

interface Ifc;
   interface Reg#(Bit#(8)) rg2;
endinterface

(* synthesize, gate_all_clocks *)
module mkMethodTb(Ifc);
   // avoid the need for reset
   Reg#(Bit#(8)) srg <- mkRegU;

   interface rg2 = srg;
endmodule

(* synthesize *)
module mkMethodTb_Gate(GatedClockIfc);
   GatedClockIfc sg <- mkGatedClockFromCC(False);
   return sg;
endmodule
