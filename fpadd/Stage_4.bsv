//Date:25-11-2023
//Author:V.V.S.Rama Manoj
/*Goals of the following stage:
1. This stage will shift the mantissa of the number with the smaller exponent to the right
2. It will return sign bits, exponent, mantissae and flags corresponding to both inputs
-----------------------------------------------------------------------------
Notes:
1. Input will be of same type as output of stage_1.
2. All required flags and the valid bit will be continued to be carried.
*/
package Stage_4;
import  FIFO :: *;
import Type_defs :: *;

//Interface for stage_4
//method to interface with Stage_3
interface Stage_4_Ifc;
    method Action feed(Output_stage_3 output_stage_3);//enq pipeline FIFO of Stage_4
endinterface :Stage_4_Ifc

//module declaration
(*synthesize*)
module mkStage_4(Stage_4_Ifc);
    FIFO#(Output_stage_3) input_fifo<-mkLFIFO;
    FIFO#(Output_stage_4) output_fifo<-mkLFIFO;
    //The following function will update the output
    function Output_stage_4 get_stage_4();//gives final result
        Output_stage_4 output_stage_4;
        output_stage_4.final_sum.mantissa=52'b0000000000000000000000000000000000000000000000000000;
        output_stage_4.final_sum.exponent=11'b00000000000;
        Bool done=False;
        UInt#(11) normalization_shift_left=0;
        //setting sign bit of output
        output_stage_4.final_sum.sign=input_fifo.first.sign_sum;
        //passing valid flag
        output_stage_4.is_valid=input_fifo.first.is_valid;
        //handling special cases
        if(input_fifo.first.is_NaN||input_fifo.first.is_infi) begin
            output_stage_4.final_sum.mantissa=(input_fifo.first.mantissa_sum)[51:0];
            output_stage_4.final_sum.exponent=input_fifo.first.exponent_sum;
            done=True;
        end
        //priority encoder
        else if(input_fifo.first.mantissa_sum[53]==1) begin
            output_stage_4.final_sum.mantissa=(input_fifo.first.mantissa_sum>>1)[51:0];
            output_stage_4.final_sum.exponent=(input_fifo.first.exponent_sum)+1;
            //if sum has crossed positive limit, replace it with infinity
            if(output_stage_4.final_sum.exponent==11'b11111111111) begin
                output_stage_4.final_sum.mantissa=52'b0000000000000000000000000000000000000000000000000000;
            end
            done=True;
        end
        else if(input_fifo.first.mantissa_sum[52]==1) begin
            output_stage_4.final_sum.mantissa=(input_fifo.first.mantissa_sum)[51:0];
            output_stage_4.final_sum.exponent=input_fifo.first.exponent_sum;
            done=True;
        end
        else if(input_fifo.first.mantissa_sum[51]==1) begin
            normalization_shift_left=1;
        end
        else if(input_fifo.first.mantissa_sum[50]==1) begin
            normalization_shift_left=2;
        end
        else if(input_fifo.first.mantissa_sum[49]==1) begin
            normalization_shift_left=3;
        end
        else if(input_fifo.first.mantissa_sum[48]==1) begin
            normalization_shift_left=4;
        end
        else if(input_fifo.first.mantissa_sum[47]==1) begin
            normalization_shift_left=5;
        end
        else if(input_fifo.first.mantissa_sum[46]==1) begin
            normalization_shift_left=6;
        end
        else if(input_fifo.first.mantissa_sum[45]==1) begin
            normalization_shift_left=7;
        end
        else if(input_fifo.first.mantissa_sum[44]==1) begin
            normalization_shift_left=8;
        end
        else if(input_fifo.first.mantissa_sum[43]==1) begin
            normalization_shift_left=9;
        end
        else if(input_fifo.first.mantissa_sum[42]==1) begin
            normalization_shift_left=10;
        end
        else if(input_fifo.first.mantissa_sum[41]==1) begin
            normalization_shift_left=11;
        end
        else if(input_fifo.first.mantissa_sum[40]==1) begin
            normalization_shift_left=12;
        end
        else if(input_fifo.first.mantissa_sum[39]==1) begin
            normalization_shift_left=13;
        end
        else if(input_fifo.first.mantissa_sum[38]==1) begin
            normalization_shift_left=14;
        end
        else if(input_fifo.first.mantissa_sum[37]==1) begin
            normalization_shift_left=15;
        end
        else if(input_fifo.first.mantissa_sum[36]==1) begin
            normalization_shift_left=16;
        end
        else if(input_fifo.first.mantissa_sum[35]==1) begin
            normalization_shift_left=17;
        end
        else if(input_fifo.first.mantissa_sum[34]==1) begin
            normalization_shift_left=18;
        end
        else if(input_fifo.first.mantissa_sum[33]==1) begin
            normalization_shift_left=19;
        end
        else if(input_fifo.first.mantissa_sum[32]==1) begin
            normalization_shift_left=20;
        end
        else if(input_fifo.first.mantissa_sum[31]==1) begin
            normalization_shift_left=21;
        end
        else if(input_fifo.first.mantissa_sum[30]==1) begin
            normalization_shift_left=22;
        end
        else if(input_fifo.first.mantissa_sum[29]==1) begin
            normalization_shift_left=23;
        end
        else if(input_fifo.first.mantissa_sum[28]==1) begin
            normalization_shift_left=24;
        end
        else if(input_fifo.first.mantissa_sum[27]==1) begin
            normalization_shift_left=25;
        end
        else if(input_fifo.first.mantissa_sum[26]==1) begin
            normalization_shift_left=26;
        end
        else if(input_fifo.first.mantissa_sum[25]==1) begin
            normalization_shift_left=27;
        end
        else if(input_fifo.first.mantissa_sum[24]==1) begin
            normalization_shift_left=28;
        end
        else if(input_fifo.first.mantissa_sum[23]==1) begin
            normalization_shift_left=29;
        end
        else if(input_fifo.first.mantissa_sum[22]==1) begin
            normalization_shift_left=30;
        end
        else if(input_fifo.first.mantissa_sum[21]==1) begin
            normalization_shift_left=31;
        end
        else if(input_fifo.first.mantissa_sum[20]==1) begin
            normalization_shift_left=32;
        end
        else if(input_fifo.first.mantissa_sum[19]==1) begin
            normalization_shift_left=33;
        end
        else if(input_fifo.first.mantissa_sum[18]==1) begin
            normalization_shift_left=34;
        end
        else if(input_fifo.first.mantissa_sum[17]==1) begin
            normalization_shift_left=35;
        end
        else if(input_fifo.first.mantissa_sum[16]==1) begin
            normalization_shift_left=36;
        end
        else if(input_fifo.first.mantissa_sum[15]==1) begin
            normalization_shift_left=37;
        end
        else if(input_fifo.first.mantissa_sum[14]==1) begin
            normalization_shift_left=38;
        end
        else if(input_fifo.first.mantissa_sum[13]==1) begin
            normalization_shift_left=39;
        end
        else if(input_fifo.first.mantissa_sum[12]==1) begin
            normalization_shift_left=40;
        end
        else if(input_fifo.first.mantissa_sum[11]==1) begin
            normalization_shift_left=41;
        end
        else if(input_fifo.first.mantissa_sum[10]==1) begin
            normalization_shift_left=42;
        end
        else if(input_fifo.first.mantissa_sum[9]==1) begin
            normalization_shift_left=43;
        end
        else if(input_fifo.first.mantissa_sum[8]==1) begin
            normalization_shift_left=44;
        end
        else if(input_fifo.first.mantissa_sum[7]==1) begin
            normalization_shift_left=45;
        end
        else if(input_fifo.first.mantissa_sum[6]==1) begin
            normalization_shift_left=46;
        end
        else if(input_fifo.first.mantissa_sum[5]==1) begin
            normalization_shift_left=47;
        end
        else if(input_fifo.first.mantissa_sum[4]==1) begin
            normalization_shift_left=48;
        end
        else if(input_fifo.first.mantissa_sum[3]==1) begin
            normalization_shift_left=49;
        end
        else if(input_fifo.first.mantissa_sum[2]==1) begin
            normalization_shift_left=50;
        end
        else if(input_fifo.first.mantissa_sum[1]==1) begin
            normalization_shift_left=51;
        end
        else if(input_fifo.first.mantissa_sum[0]==1) begin
            normalization_shift_left=52;
        end
        //if mantissa is zero, flush exponent to zero
        else begin
            output_stage_4.final_sum.mantissa=52'b0000000000000000000000000000000000000000000000000000;
            output_stage_4.final_sum.exponent=11'b00000000000;
            done=True;
        end
        //handling subnormal output
        if(!done) begin
            if(pack(normalization_shift_left)>=input_fifo.first.exponent_sum) begin
                normalization_shift_left=unpack(input_fifo.first.exponent_sum-1);
                output_stage_4.final_sum.mantissa=(input_fifo.first.mantissa_sum<<normalization_shift_left)[51:0];
                output_stage_4.final_sum.exponent=11'b00000000000;
                done=True;
            end
            //not a special case of output
            else begin
            output_stage_4.final_sum.mantissa=(input_fifo.first.mantissa_sum<<normalization_shift_left)[51:0];
            output_stage_4.final_sum.exponent=(input_fifo.first.exponent_sum)-pack(normalization_shift_left);
            done=True;
            end
        end
        return output_stage_4;
    endfunction:get_stage_4
    rule rl_feed_output;
        $display("\n**Stage_4_Output**\nOutput:%b \n Valid:%0b", pack(get_stage_4().final_sum),pack(get_stage_4().is_valid));
        output_fifo.enq(get_stage_4());
        input_fifo.deq;
    endrule : rl_feed_output
    rule r2_flush_output;
        output_fifo.deq;
    endrule:r2_flush_output
    method Action feed(Output_stage_3 output_stage_3);
        input_fifo.enq(output_stage_3);
    endmethod: feed
endmodule
endpackage : Stage_4