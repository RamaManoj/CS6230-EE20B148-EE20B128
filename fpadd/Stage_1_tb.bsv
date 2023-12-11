package Stage_1_tb;
import Stage_1::*;
import Type_defs :: *;
module mkTest_Stage_1(Empty);
   Stage_1_Ifc dut<-mkStage_1;
   Reg#(int) i <- mkReg(0); // iterator to run all testcases
   Bit#(64) test_cases[10][3] = { {'h408F3A7AE147AE14, 'h4038B0A3D70A3D71, 'h4090000000000000}, // 999.31 + 24.69 = 1024
                                        {'h405EC00000000000, 'h405EC00000000000, 'h406EC00000000000}, // 123 + 123 = 246
                                        {'hC049000000000000, 'hC049000000000000, 'hC059000000000000}, // -50 - 50 = -100
                                        {'hFFF9000000000000, 'hD559000000000000, 'h7FFFFFFFFFFFFFFF}, // NaN + const = NaN
                                        {'hC034000000000000, 'h403E000000000000, 'h4024000000000000}, // 30 - 20 = 10
                                        {'hFFF0000000000000, 'hD559000000000000, 'hFFF0000000000000}, // -inf + const = -inf
                                        {'h7FE0000000000001, 'h7FE0000000000001, 'h0000000000000000}, // a - a = 0
                                        {'h7FE0000000000001, 'h7FE0000000000001, 'h7FF0000000000000}, // overflow to +inf
                                        {'hFFE0000000000001, 'hFFE0000000000001, 'hFFF0000000000000}, // overflow to -inf
                                        {'hFFE0000000000001, 'h8000000000000000, 'hFFE0000000000001}}; // addition with -ve 0
   rule test (i<10&&i>=0);      
       dut.feed(unpack(test_cases[i][0]),unpack(test_cases[i][0]),True);
       $display("Feeding inputs %0b %0b...", test_cases[i][0], test_cases[i][1]);
       $display("Expected final output = %0b", test_cases[i][2]);
       i<=i+1;
   endrule

   rule end_test (i>=10);
        $finish (0);
   endrule 

endmodule
endpackage : Stage_1_tb