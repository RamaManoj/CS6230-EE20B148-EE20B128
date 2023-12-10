//
// Generated by Bluespec Compiler, version 2021.12.1 (build fd501401)
//
// On Mon Dec 11 00:45:25 IST 2023
//
//
// Ports:
// Name                         I/O  size props
// RDY_feed                       O     1
// CLK                            I     1 clock
// RST_N                          I     1 reset
// feed_input_1                   I    64 reg
// feed_input_2                   I    64 reg
// feed_is_valid                  I     1 reg
// EN_feed                        I     1
//
// No combinational paths from inputs to outputs
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
  `define BSV_ASSIGNMENT_DELAY
`endif

`ifdef BSV_POSITIVE_RESET
  `define BSV_RESET_VALUE 1'b1
  `define BSV_RESET_EDGE posedge
`else
  `define BSV_RESET_VALUE 1'b0
  `define BSV_RESET_EDGE negedge
`endif

module mkStage_1(CLK,
		 RST_N,

		 feed_input_1,
		 feed_input_2,
		 feed_is_valid,
		 EN_feed,
		 RDY_feed);
  input  CLK;
  input  RST_N;

  // action method feed
  input  [63 : 0] feed_input_1;
  input  [63 : 0] feed_input_2;
  input  feed_is_valid;
  input  EN_feed;
  output RDY_feed;

  // signals for module outputs
  wire RDY_feed;

  // ports of submodule input_1
  wire [63 : 0] input_1$D_IN, input_1$D_OUT;
  wire input_1$CLR, input_1$DEQ, input_1$EMPTY_N, input_1$ENQ, input_1$FULL_N;

  // ports of submodule input_2
  wire [63 : 0] input_2$D_IN, input_2$D_OUT;
  wire input_2$CLR, input_2$DEQ, input_2$EMPTY_N, input_2$ENQ, input_2$FULL_N;

  // ports of submodule is_valid
  wire is_valid$CLR,
       is_valid$DEQ,
       is_valid$D_IN,
       is_valid$D_OUT,
       is_valid$EMPTY_N,
       is_valid$ENQ,
       is_valid$FULL_N;

  // ports of submodule stage_2
  wire [150 : 0] stage_2$feed_output_stage_1;
  wire stage_2$EN_feed, stage_2$RDY_feed;

  // remaining internal signals
  wire [54 : 0] x__h1025, x__h1028;
  wire [10 : 0] _theResult_____1_exponent_input_2__h385,
		_theResult_____3_snd_exponent_input_2__h477,
		_theResult___snd_exponent_input_1__h658,
		output_stage_1___1_exponent_input_1__h965,
		x__h1020;
  wire IF_input_1_first_BITS_62_TO_52_2_EQ_0b0_3_THEN_ETC___d24;

  // action method feed
  assign RDY_feed = input_1$FULL_N && input_2$FULL_N && is_valid$FULL_N ;

  // submodule input_1
  FIFOL1 #( /*width*/ 32'd64) input_1(.RST(RST_N),
				      .CLK(CLK),
				      .D_IN(input_1$D_IN),
				      .ENQ(input_1$ENQ),
				      .DEQ(input_1$DEQ),
				      .CLR(input_1$CLR),
				      .D_OUT(input_1$D_OUT),
				      .FULL_N(input_1$FULL_N),
				      .EMPTY_N(input_1$EMPTY_N));

  // submodule input_2
  FIFOL1 #( /*width*/ 32'd64) input_2(.RST(RST_N),
				      .CLK(CLK),
				      .D_IN(input_2$D_IN),
				      .ENQ(input_2$ENQ),
				      .DEQ(input_2$DEQ),
				      .CLR(input_2$CLR),
				      .D_OUT(input_2$D_OUT),
				      .FULL_N(input_2$FULL_N),
				      .EMPTY_N(input_2$EMPTY_N));

  // submodule is_valid
  FIFOL1 #( /*width*/ 32'd1) is_valid(.RST(RST_N),
				      .CLK(CLK),
				      .D_IN(is_valid$D_IN),
				      .ENQ(is_valid$ENQ),
				      .DEQ(is_valid$DEQ),
				      .CLR(is_valid$CLR),
				      .D_OUT(is_valid$D_OUT),
				      .FULL_N(is_valid$FULL_N),
				      .EMPTY_N(is_valid$EMPTY_N));

  // submodule stage_2
  mkStage_2 stage_2(.CLK(CLK),
		    .RST_N(RST_N),
		    .feed_output_stage_1(stage_2$feed_output_stage_1),
		    .EN_feed(stage_2$EN_feed),
		    .RDY_feed(stage_2$RDY_feed));

  // submodule input_1
  assign input_1$D_IN = feed_input_1 ;
  assign input_1$ENQ = EN_feed ;
  assign input_1$DEQ =
	     stage_2$RDY_feed && input_2$EMPTY_N && input_1$EMPTY_N &&
	     is_valid$EMPTY_N ;
  assign input_1$CLR = 1'b0 ;

  // submodule input_2
  assign input_2$D_IN = feed_input_2 ;
  assign input_2$ENQ = EN_feed ;
  assign input_2$DEQ =
	     stage_2$RDY_feed && input_2$EMPTY_N && input_1$EMPTY_N &&
	     is_valid$EMPTY_N ;
  assign input_2$CLR = 1'b0 ;

  // submodule is_valid
  assign is_valid$D_IN = feed_is_valid ;
  assign is_valid$ENQ = EN_feed ;
  assign is_valid$DEQ =
	     stage_2$RDY_feed && input_2$EMPTY_N && input_1$EMPTY_N &&
	     is_valid$EMPTY_N ;
  assign is_valid$CLR = 1'b0 ;

  // submodule stage_2
  assign stage_2$feed_output_stage_1 =
	     { input_1$D_OUT[63],
	       input_2$D_OUT[63],
	       output_stage_1___1_exponent_input_1__h965,
	       _theResult_____1_exponent_input_2__h385,
	       x__h1020,
	       !IF_input_1_first_BITS_62_TO_52_2_EQ_0b0_3_THEN_ETC___d24,
	       x__h1025,
	       x__h1028,
	       input_1$D_OUT[62:52] == 11'b11111111111 &&
	       input_1$D_OUT[51:0] != 52'b0,
	       input_2$D_OUT[62:52] == 11'b11111111111 &&
	       input_2$D_OUT[51:0] != 52'b0,
	       input_1$D_OUT[62:52] == 11'b11111111111 &&
	       input_1$D_OUT[51:0] == 52'b0,
	       input_2$D_OUT[62:52] == 11'b11111111111 &&
	       input_2$D_OUT[51:0] == 52'b0,
	       is_valid$D_OUT } ;
  assign stage_2$EN_feed =
	     stage_2$RDY_feed && input_2$EMPTY_N && input_1$EMPTY_N &&
	     is_valid$EMPTY_N ;

  // remaining internal signals
  assign IF_input_1_first_BITS_62_TO_52_2_EQ_0b0_3_THEN_ETC___d24 =
	     output_stage_1___1_exponent_input_1__h965 <
	     _theResult_____1_exponent_input_2__h385 ;
  assign _theResult_____1_exponent_input_2__h385 =
	     (input_2$D_OUT[62:52] == 11'b0) ?
	       _theResult_____3_snd_exponent_input_2__h477 :
	       input_2$D_OUT[62:52] ;
  assign _theResult_____3_snd_exponent_input_2__h477 =
	     (input_2$D_OUT[51:0] == 52'b0) ?
	       input_2$D_OUT[62:52] :
	       11'b00000000001 ;
  assign _theResult___snd_exponent_input_1__h658 =
	     (input_1$D_OUT[51:0] == 52'b0) ?
	       input_1$D_OUT[62:52] :
	       11'b00000000001 ;
  assign output_stage_1___1_exponent_input_1__h965 =
	     (input_1$D_OUT[62:52] == 11'b0) ?
	       _theResult___snd_exponent_input_1__h658 :
	       input_1$D_OUT[62:52] ;
  assign x__h1020 =
	     IF_input_1_first_BITS_62_TO_52_2_EQ_0b0_3_THEN_ETC___d24 ?
	       _theResult_____1_exponent_input_2__h385 -
	       output_stage_1___1_exponent_input_1__h965 :
	       output_stage_1___1_exponent_input_1__h965 -
	       _theResult_____1_exponent_input_2__h385 ;
  assign x__h1025 =
	     { (input_1$D_OUT[62:52] == 11'b0) ? 3'b0 : 3'b001,
	       input_1$D_OUT[51:0] } ;
  assign x__h1028 =
	     { (input_2$D_OUT[62:52] == 11'b0) ? 3'b0 : 3'b001,
	       input_2$D_OUT[51:0] } ;
endmodule  // mkStage_1
