//Date:9-12-2023
//Author:V.V.S.Rama Manoj
/*Goals of the following stage:
1. This stage will perform addition and return 
   *the sign of the final result
   *positive, non normalized mantissa of the final result
   *Exponent of result before normalization
2. If any of the special case flags are set, the result will be overwritten accordingly in 
   the order of NaN, input 1 is infinite, input 2 is infinite
   
*/
package Stage_3;
import  FIFO :: *;
import Type_defs :: *;
import Stage_4 :: *;

//Interface for stage_3
//method to interface with Stage_2
interface Stage_3_Ifc;
    method Action feed(Output_stage_2 output_stage_2);//enq pipeline FIFO of Stage_3 
endinterface :Stage_3_Ifc

//module declaration
(*synthesize*)
module mkStage_3(Stage_3_Ifc);
    FIFO#(Output_stage_2) input_fifo<-mkLFIFO;
    Stage_4_Ifc stage_4<-mkStage_4;
    //The following function will update the output
    function Output_stage_3 get_stage_3();//allows stage_2 to get stage_1 results
        Output_stage_3 output_stage_3;
        output_stage_3.is_valid=input_fifo.first.is_valid;
        output_stage_3.is_infi=False;
        output_stage_3.is_NaN=False;
        //handling special cases
        if(input_fifo.first.is_NaN_1||input_fifo.first.is_NaN_2) begin
            output_stage_3.is_NaN=True;
            output_stage_3.sign_sum=1'b0;
            output_stage_3.exponent_sum=11'b11111111111;
            output_stage_3.mantissa_sum=54'b111111111111111111111111111111111111111111111111111111;
        end
        else if(input_fifo.first.is_infi_1) begin
            output_stage_3.is_infi=True;
            output_stage_3.sign_sum=input_fifo.first.sign_input_1;
            output_stage_3.exponent_sum=11'b11111111111;
            output_stage_3.mantissa_sum=54'b000000000000000000000000000000000000000000000000000000;
        end
        //infinity on first input takes precedence
        else if(input_fifo.first.is_infi_2) begin
            output_stage_3.is_infi=True;
            output_stage_3.sign_sum=input_fifo.first.sign_input_2;
            output_stage_3.exponent_sum=11'b11111111111;
            output_stage_3.mantissa_sum=54'b000000000000000000000000000000000000000000000000000000;
        end
        //Addition
        else begin 
            output_stage_3.exponent_sum=input_fifo.first.exponent;
            Bit#(55) signed_mantissa_1=input_fifo.first.mantissa_input_1;
            Bit#(55) signed_mantissa_2=input_fifo.first.mantissa_input_2;
            if(input_fifo.first.sign_input_1==1'b1) begin
                signed_mantissa_1=-(input_fifo.first.mantissa_input_1);
            end
            if(input_fifo.first.sign_input_2==1'b1) begin
                signed_mantissa_2=-(input_fifo.first.mantissa_input_2);
            end
            Bit#(55) sum_temp=signed_mantissa_1+signed_mantissa_2;
            Bit#(55) neg_sum_temp=-sum_temp;
            if(sum_temp[54]==1) begin
                output_stage_3.sign_sum=1;
                output_stage_3.mantissa_sum=neg_sum_temp[53:0];
            end
            else begin
                output_stage_3.sign_sum=0;
                output_stage_3.mantissa_sum=sum_temp[53:0];
            end
        end
        return output_stage_3;
    endfunction:get_stage_3
    rule rl_feed_stage_4;
        $display("\n**Stage_3_Output**\nsign_sum:%0b\nexponent_sum:%0b\nmantissa_sum:%0b\n",
        get_stage_3().sign_sum,
        get_stage_3().exponent_sum,get_stage_3().mantissa_sum);
        stage_4.feed(get_stage_3());
        input_fifo.deq;
    endrule : rl_feed_stage_4
    method Action feed(Output_stage_2 output_stage_2);
        input_fifo.enq(output_stage_2);
    endmethod: feed
endmodule
endpackage : Stage_3