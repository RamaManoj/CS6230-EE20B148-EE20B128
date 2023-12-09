package Stage_1_tb;
import Stage_1::*;
(*synthesize*)
module mkTest_Stage_1(Empty);
   Stage_1_Ifc dut<-mkStage_1;
   Reg#(int) i<-mkReg(0);
   rule rl_stage_1_test;
      $display("iter %d", i);
      i<=i+1;
      Output_stage_1 disamb=dut.get_output();
      if(disamb.is_valid) begin
         $display ("sign:%0b \nmantissa:%0b \nexponent:%0b\nexponent_diff:%0b",disamb.sign_input_1,
         disamb.mantissa_input_1,disamb.exponent_input_1,
         disamb.exponent_diff);
         $finish;
      end
      else begin
         $display ("invalid");
         $finish;
      end
   endrule
   rule r2_stage_1_test;
       dut.feed(unpack(64'b1100000001001001000000000000000000000000000000000000000000000000),unpack(64'b1100000001001001000000000000000000000000000000000000000000000000),True);
   endrule
endmodule
endpackage : Stage_1_tb