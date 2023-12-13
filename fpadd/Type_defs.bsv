//Date:9-12-2023
//Author:V.V.S.Rama Manoj
//All custom data_types used in design
package Type_defs;
typedef struct {Bit#(1) sign;Bit#(11) exponent;Bit#(52) mantissa;} Double deriving(Bits);
//2 variables of double data type are taken as input by Stage_1

typedef struct
{
    Bit#(1) sign_input_1; 
    Bit#(1) sign_input_2;
    Bit#(11) exponent_input_1;
    Bit#(11) exponent_input_2;
    Bit#(11) exponent_diff;
    Bool is_1_greater_than_2;//is exponent of input_1>exponent of input_2?
    Bit#(55) mantissa_input_1;
    Bit#(55) mantissa_input_2;
    Bool is_NaN_1;Bool is_NaN_2;//Account for invalid inputs
    Bool is_infi_1;Bool is_infi_2; //Account for infinite numbers in input
    Bool is_valid;//function select/validity bit
} Output_stage_1 deriving(Bits);
//Output of Stage_1,Input of Stage_2
typedef struct
{
    Bit#(1) sign_input_1; 
    Bit#(1) sign_input_2;
    Bit#(11) exponent;
    Bit#(55) mantissa_input_1;
    Bit#(55) mantissa_input_2;
    Bool is_NaN_1;Bool is_NaN_2;//Account for invalid and zero numbers
    Bool is_infi_1;Bool is_infi_2; //Account for infinite numbers
    Bool is_valid;//function select/validity bit
} Output_stage_2 deriving(Bits);
//Out:2,In:3
typedef struct
{
    Bit#(1)  sign_sum;
    Bit#(11) exponent_sum;
    Bit#(54) mantissa_sum;
    Bool is_NaN;//Account for invalid
    Bool is_infi; //Account for infinite numbers
    Bool is_valid;//function select/validity bit
} Output_stage_3 deriving(Bits);
//Out:3,In:4
typedef struct
{
    Double final_sum;
    Bool is_valid;//function select/validity bit
} Output_stage_4 deriving(Bits);
//Out:4
endpackage : Type_defs