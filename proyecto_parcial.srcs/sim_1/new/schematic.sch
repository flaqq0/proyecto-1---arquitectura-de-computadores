# File saved with Nlview 7.8.0 2024-04-26 e1825d835c VDI=44 GEI=38 GUI=JA:21.0 threadsafe
# 
# non-default properties - (restore without -noprops)
property -colorscheme classic
property attrcolor #000000
property attrfontsize 8
property autobundle 1
property backgroundcolor #ffffff
property boxcolor0 #000000
property boxcolor1 #000000
property boxcolor2 #000000
property boxinstcolor #000000
property boxpincolor #000000
property buscolor #008000
property closeenough 5
property createnetattrdsp 2048
property decorate 1
property elidetext 40
property fillcolor1 #ffffcc
property fillcolor2 #dfebf8
property fillcolor3 #f0f0f0
property gatecellname 2
property instattrmax 30
property instdrag 15
property instorder 1
property marksize 12
property maxfontsize 18
property maxzoom 7.5
property netcolor #19b400
property objecthighlight0 #ff00ff
property objecthighlight1 #ffff00
property objecthighlight2 #00ff00
property objecthighlight3 #0095ff
property objecthighlight4 #8000ff
property objecthighlight5 #ffc800
property objecthighlight7 #00ffff
property objecthighlight8 #ff00ff
property objecthighlight9 #ccccff
property objecthighlight10 #0ead00
property objecthighlight11 #cefc00
property objecthighlight12 #9e2dbe
property objecthighlight13 #ba6a29
property objecthighlight14 #fc0188
property objecthighlight15 #02f990
property objecthighlight16 #f1b0fb
property objecthighlight17 #fec004
property objecthighlight18 #149bff
property objecthighlight19 #eb591b
property overlaycolor #19b400
property pbuscolor #000000
property pbusnamecolor #000000
property pinattrmax 20
property pinorder 2
property pinpermute 0
property portcolor #000000
property portnamecolor #000000
property ripindexfontsize 4
property rippercolor #000000
property rubberbandcolor #000000
property rubberbandfontsize 18
property selectattr 0
property selectionappearance 2
property selectioncolor #0000ff
property sheetheight 44
property sheetwidth 68
property showmarks 1
property shownetname 0
property showpagenumbers 1
property showripindex 1
property timelimit 1
#
module new top work:top:NOFILE -nosplit
load symbol LUT6 hdi_primitives BOX pin O output.right pin I0 input.left pin I1 input.left pin I2 input.left pin I3 input.left pin I4 input.left pin I5 input.left fillcolor 1
load symbol LUT5 hdi_primitives BOX pin O output.right pin I0 input.left pin I1 input.left pin I2 input.left pin I3 input.left pin I4 input.left fillcolor 1
load symbol FDRE hdi_primitives GEN pin Q output.right pin C input.clk.left pin CE input.left pin D input.left pin R input.left fillcolor 1
load symbol falu work:falu:NOFILE HIERBOX pin btnU_IBUF input.left pin clk_IBUF_BUFG input.left pin flags_reg[0]_i_1072 input.left pin flags_reg[0]_i_1951 input.left pin flags_reg[0]_i_840 input.left pin mode_fp input.left pin n_m2__0 input.left pin n_m2__0_0 input.left pin result_reg[15]_0 input.left pin result_reg[20]_i_183 input.left pin result_reg[22]_0 input.left pin round_mode input.left pinBus D output.right [15:0] pinBus E input.left [0:0] pinBus Q input.left [1:0] pinBus result_reg[31]_0 input.left [31:0] pinBus result_reg[31]_1 input.left [31:0] pinBus show_seq input.left [1:0] boxcolor 1 fillcolor 2 minwidth 13%
load symbol IBUF hdi_primitives BUF pin O output pin I input fillcolor 1
load symbol BUFG hdi_primitives BUF pin O output pin I input fillcolor 1
load symbol OBUF hdi_primitives BUF pin O output pin I input fillcolor 1
load symbol LUT3 hdi_primitives BOX pin O output.right pin I0 input.left pin I1 input.left pin I2 input.left fillcolor 1
load symbol LUT4 hdi_primitives BOX pin O output.right pin I0 input.left pin I1 input.left pin I2 input.left pin I3 input.left fillcolor 1
load port btnC input -pg 1 -lvl 0 -x 0 -y 7670
load port btnR input -pg 1 -lvl 0 -x 0 -y 7490
load port btnU input -pg 1 -lvl 0 -x 0 -y 7560
load port clk input -pg 1 -lvl 0 -x 0 -y 7630
load portBus led output [15:0] -attr @name led[15:0] -pg 1 -lvl 14 -x 3910 -y 8470
load portBus sw input [15:0] -attr @name sw[15:0] -pg 1 -lvl 0 -x 0 -y 6240
load inst FSM_sequential_state[0]_i_1 LUT6 hdi_primitives -attr @cell(#000000) LUT6 -pg 1 -lvl 6 -x 1510 -y 7560
load inst FSM_sequential_state[1]_i_1 LUT6 hdi_primitives -attr @cell(#000000) LUT6 -pg 1 -lvl 4 -x 910 -y 7520
load inst FSM_sequential_state[2]_i_1 LUT5 hdi_primitives -attr @cell(#000000) LUT5 -pg 1 -lvl 2 -x 300 -y 7470
load inst FSM_sequential_state_reg[0] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 7 -x 1790 -y 7610
load inst FSM_sequential_state_reg[1] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 5 -x 1190 -y 7870
load inst FSM_sequential_state_reg[2] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 3 -x 590 -y 7540
load inst aluuu falu work:falu:NOFILE -autohide -attr @cell(#000000) falu -pinBusAttr D @name D[15:0] -pinBusAttr E @name E -pinBusAttr Q @name Q[1:0] -pinBusAttr result_reg[31]_0 @name result_reg[31]_0[31:0] -pinBusAttr result_reg[31]_1 @name result_reg[31]_1[31:0] -pinBusAttr show_seq @name show_seq[1:0] -pg 1 -lvl 11 -x 3380 -y 10320
load inst btnC_IBUF_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 3 -x 590 -y 7670
load inst btnR_IBUF_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 1 -x 40 -y 7490
load inst btnU_IBUF_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 1 -x 40 -y 7560
load inst clk_IBUF_BUFG_inst BUFG hdi_primitives -attr @cell(#000000) BUFG -pg 1 -lvl 2 -x 300 -y 7630
load inst clk_IBUF_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 1 -x 40 -y 7630
load inst led_OBUF[0]_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 13 -x 3740 -y 8470
load inst led_OBUF[10]_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 13 -x 3740 -y 9970
load inst led_OBUF[11]_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 13 -x 3740 -y 10120
load inst led_OBUF[12]_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 13 -x 3740 -y 10270
load inst led_OBUF[13]_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 13 -x 3740 -y 10420
load inst led_OBUF[14]_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 13 -x 3740 -y 10570
load inst led_OBUF[15]_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 13 -x 3740 -y 10720
load inst led_OBUF[1]_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 13 -x 3740 -y 8620
load inst led_OBUF[2]_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 13 -x 3740 -y 8770
load inst led_OBUF[3]_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 13 -x 3740 -y 8920
load inst led_OBUF[4]_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 13 -x 3740 -y 9070
load inst led_OBUF[5]_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 13 -x 3740 -y 9220
load inst led_OBUF[6]_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 13 -x 3740 -y 9370
load inst led_OBUF[7]_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 13 -x 3740 -y 9520
load inst led_OBUF[8]_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 13 -x 3740 -y 9670
load inst led_OBUF[9]_inst OBUF hdi_primitives -attr @cell(#000000) OBUF -pg 1 -lvl 13 -x 3740 -y 9820
load inst led_reg[0] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 12 -x 3620 -y 8470
load inst led_reg[10] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 12 -x 3620 -y 9970
load inst led_reg[11] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 12 -x 3620 -y 10120
load inst led_reg[12] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 12 -x 3620 -y 10270
load inst led_reg[13] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 12 -x 3620 -y 10420
load inst led_reg[14] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 12 -x 3620 -y 10570
load inst led_reg[15] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 12 -x 3620 -y 10720
load inst led_reg[1] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 12 -x 3620 -y 8620
load inst led_reg[2] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 12 -x 3620 -y 8770
load inst led_reg[3] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 12 -x 3620 -y 8920
load inst led_reg[4] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 12 -x 3620 -y 9070
load inst led_reg[5] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 12 -x 3620 -y 9220
load inst led_reg[6] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 12 -x 3620 -y 9370
load inst led_reg[7] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 12 -x 3620 -y 9520
load inst led_reg[8] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 12 -x 3620 -y 9670
load inst led_reg[9] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 12 -x 3620 -y 9820
load inst mode_fp_i_1 LUT3 hdi_primitives -attr @cell(#000000) LUT3 -pg 1 -lvl 9 -x 2250 -y 7570
load inst mode_fp_reg FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 10140
load inst mode_fp_reg_rep FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 10290
load inst mode_fp_reg_rep__0 FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 10450
load inst mode_fp_reg_rep__1 FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 10610
load inst mode_fp_reg_rep__2 FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 10760
load inst mode_fp_reg_rep__3 FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 10910
load inst mode_fp_reg_rep__4 FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 11060
load inst mode_fp_reg_rep__5 FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 11210
load inst mode_fp_reg_rep__6 FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 11360
load inst op_a_32[15]_i_1 LUT3 hdi_primitives -attr @cell(#000000) LUT3 -pg 1 -lvl 9 -x 2250 -y 6010
load inst op_a_32[31]_i_1 LUT3 hdi_primitives -attr @cell(#000000) LUT3 -pg 1 -lvl 9 -x 2250 -y 7350
load inst op_a_32_reg[0] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 80
load inst op_a_32_reg[10] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 2930
load inst op_a_32_reg[11] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 3080
load inst op_a_32_reg[12] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 3230
load inst op_a_32_reg[13] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 3380
load inst op_a_32_reg[14] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 3530
load inst op_a_32_reg[15] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 3680
load inst op_a_32_reg[16] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 3830
load inst op_a_32_reg[17] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 3980
load inst op_a_32_reg[18] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 4130
load inst op_a_32_reg[19] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 4280
load inst op_a_32_reg[1] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 230
load inst op_a_32_reg[20] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 4430
load inst op_a_32_reg[21] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 4580
load inst op_a_32_reg[22] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 4730
load inst op_a_32_reg[23] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 4880
load inst op_a_32_reg[24] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 5030
load inst op_a_32_reg[25] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 7730
load inst op_a_32_reg[26] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 7890
load inst op_a_32_reg[27] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 8340
load inst op_a_32_reg[28] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 8490
load inst op_a_32_reg[29] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 8640
load inst op_a_32_reg[2] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 380
load inst op_a_32_reg[30] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 8790
load inst op_a_32_reg[31] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 8940
load inst op_a_32_reg[3] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 980
load inst op_a_32_reg[4] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 1280
load inst op_a_32_reg[5] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 1580
load inst op_a_32_reg[6] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 1880
load inst op_a_32_reg[7] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 2330
load inst op_a_32_reg[8] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 2480
load inst op_a_32_reg[9] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 2780
load inst op_b_32[15]_i_1 LUT3 hdi_primitives -attr @cell(#000000) LUT3 -pg 1 -lvl 9 -x 2250 -y 6120
load inst op_b_32[31]_i_1 LUT3 hdi_primitives -attr @cell(#000000) LUT3 -pg 1 -lvl 9 -x 2250 -y 7460
load inst op_b_32_reg[0] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 530
load inst op_b_32_reg[10] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 5330
load inst op_b_32_reg[11] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 5480
load inst op_b_32_reg[12] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 5630
load inst op_b_32_reg[13] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 5780
load inst op_b_32_reg[14] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 5930
load inst op_b_32_reg[15] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 6080
load inst op_b_32_reg[16] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 6230
load inst op_b_32_reg[17] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 6380
load inst op_b_32_reg[18] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 6530
load inst op_b_32_reg[19] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 6680
load inst op_b_32_reg[1] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 680
load inst op_b_32_reg[20] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 6830
load inst op_b_32_reg[21] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 6980
load inst op_b_32_reg[22] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 7130
load inst op_b_32_reg[23] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 7280
load inst op_b_32_reg[24] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 7430
load inst op_b_32_reg[25] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 7580
load inst op_b_32_reg[26] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 8040
load inst op_b_32_reg[27] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 8190
load inst op_b_32_reg[28] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 9090
load inst op_b_32_reg[29] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 9240
load inst op_b_32_reg[2] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 830
load inst op_b_32_reg[30] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 9390
load inst op_b_32_reg[31] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 9540
load inst op_b_32_reg[3] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 1130
load inst op_b_32_reg[4] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 1430
load inst op_b_32_reg[5] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 1730
load inst op_b_32_reg[6] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 2030
load inst op_b_32_reg[7] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 2180
load inst op_b_32_reg[8] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 2630
load inst op_b_32_reg[9] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 5180
load inst op_code_reg[0] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 9690
load inst op_code_reg[1] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 9840
load inst round_mode_reg FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 9990
load inst show_seq[0]_i_1 LUT4 hdi_primitives -attr @cell(#000000) LUT4 -pg 1 -lvl 9 -x 2250 -y 11380
load inst show_seq[1]_i_1 LUT4 hdi_primitives -attr @cell(#000000) LUT4 -pg 1 -lvl 9 -x 2250 -y 11510
load inst show_seq[1]_i_2 LUT4 hdi_primitives -attr @cell(#000000) LUT4 -pg 1 -lvl 8 -x 2030 -y 7680
load inst show_seq_reg[0] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 11520
load inst show_seq_reg[1] FDRE hdi_primitives -attr @cell(#000000) FDRE -pg 1 -lvl 10 -x 2880 -y 11720
load inst sw_IBUF[0]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 9 -x 2250 -y 6240
load inst sw_IBUF[10]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 9 -x 2250 -y 6940
load inst sw_IBUF[11]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 9 -x 2250 -y 7010
load inst sw_IBUF[12]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 9 -x 2250 -y 7080
load inst sw_IBUF[13]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 9 -x 2250 -y 7150
load inst sw_IBUF[14]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 9 -x 2250 -y 7220
load inst sw_IBUF[15]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 9 -x 2250 -y 7290
load inst sw_IBUF[1]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 9 -x 2250 -y 6310
load inst sw_IBUF[2]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 9 -x 2250 -y 6380
load inst sw_IBUF[3]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 9 -x 2250 -y 6450
load inst sw_IBUF[4]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 9 -x 2250 -y 6520
load inst sw_IBUF[5]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 9 -x 2250 -y 6590
load inst sw_IBUF[6]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 9 -x 2250 -y 6660
load inst sw_IBUF[7]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 9 -x 2250 -y 6730
load inst sw_IBUF[8]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 9 -x 2250 -y 6800
load inst sw_IBUF[9]_inst IBUF hdi_primitives -attr @cell(#000000) IBUF -pg 1 -lvl 9 -x 2250 -y 6870
load net <const0> -ground -pin FSM_sequential_state_reg[0] R -pin FSM_sequential_state_reg[1] R -pin FSM_sequential_state_reg[2] R -pin show_seq_reg[0] R -pin show_seq_reg[1] R
load net <const1> -power -pin FSM_sequential_state_reg[0] CE -pin FSM_sequential_state_reg[1] CE -pin FSM_sequential_state_reg[2] CE -pin led_reg[0] CE -pin led_reg[10] CE -pin led_reg[11] CE -pin led_reg[12] CE -pin led_reg[13] CE -pin led_reg[14] CE -pin led_reg[15] CE -pin led_reg[1] CE -pin led_reg[2] CE -pin led_reg[3] CE -pin led_reg[4] CE -pin led_reg[5] CE -pin led_reg[6] CE -pin led_reg[7] CE -pin led_reg[8] CE -pin led_reg[9] CE -pin show_seq_reg[0] CE -pin show_seq_reg[1] CE
load net FSM_sequential_state[0]_i_1_n_0 -pin FSM_sequential_state[0]_i_1 O -pin FSM_sequential_state_reg[0] D
netloc FSM_sequential_state[0]_i_1_n_0 1 6 1 1660 7610n
load net FSM_sequential_state[1]_i_1_n_0 -pin FSM_sequential_state[1]_i_1 O -pin FSM_sequential_state_reg[1] D
netloc FSM_sequential_state[1]_i_1_n_0 1 4 1 1060 7570n
load net FSM_sequential_state[2]_i_1_n_0 -pin FSM_sequential_state[2]_i_1 O -pin FSM_sequential_state_reg[2] D
netloc FSM_sequential_state[2]_i_1_n_0 1 2 1 460 7520n
load net btnC -port btnC -pin btnC_IBUF_inst I
netloc btnC 1 0 3 NJ 7670 NJ 7670 NJ
load net btnC_IBUF -attr @rip(#000000) 0 -pin FSM_sequential_state[0]_i_1 I0 -pin FSM_sequential_state[1]_i_1 I0 -pin aluuu E[0] -pin btnC_IBUF_inst O
netloc btnC_IBUF 1 3 8 760 7670 NJ 7670 1340 7810 NJ 7810 NJ 7810 NJ 7810 NJ 7810 3210
load net btnR -port btnR -pin btnR_IBUF_inst I
netloc btnR 1 0 1 NJ 7490
load net btnR_IBUF -pin FSM_sequential_state[0]_i_1 I3 -pin FSM_sequential_state[1]_i_1 I3 -pin FSM_sequential_state[2]_i_1 I2 -pin btnR_IBUF_inst O -pin show_seq[1]_i_2 I3
netloc btnR_IBUF 1 1 7 170 7710 NJ 7710 800 7710 NJ 7710 1380 7750 NJ 7750 NJ
load net btnU -port btnU -pin btnU_IBUF_inst I
netloc btnU 1 0 1 NJ 7560
load net btnU_IBUF -pin FSM_sequential_state[0]_i_1 I5 -pin FSM_sequential_state[1]_i_1 I5 -pin FSM_sequential_state[2]_i_1 I4 -pin aluuu btnU_IBUF -pin btnU_IBUF_inst O -pin led_reg[0] R -pin led_reg[10] R -pin led_reg[11] R -pin led_reg[12] R -pin led_reg[13] R -pin led_reg[14] R -pin led_reg[15] R -pin led_reg[1] R -pin led_reg[2] R -pin led_reg[3] R -pin led_reg[4] R -pin led_reg[5] R -pin led_reg[6] R -pin led_reg[7] R -pin led_reg[8] R -pin led_reg[9] R -pin mode_fp_reg R -pin mode_fp_reg_rep R -pin mode_fp_reg_rep__0 R -pin mode_fp_reg_rep__1 R -pin mode_fp_reg_rep__2 R -pin mode_fp_reg_rep__3 R -pin mode_fp_reg_rep__4 R -pin mode_fp_reg_rep__5 R -pin mode_fp_reg_rep__6 R -pin op_a_32_reg[0] R -pin op_a_32_reg[10] R -pin op_a_32_reg[11] R -pin op_a_32_reg[12] R -pin op_a_32_reg[13] R -pin op_a_32_reg[14] R -pin op_a_32_reg[15] R -pin op_a_32_reg[16] R -pin op_a_32_reg[17] R -pin op_a_32_reg[18] R -pin op_a_32_reg[19] R -pin op_a_32_reg[1] R -pin op_a_32_reg[20] R -pin op_a_32_reg[21] R -pin op_a_32_reg[22] R -pin op_a_32_reg[23] R -pin op_a_32_reg[24] R -pin op_a_32_reg[25] R -pin op_a_32_reg[26] R -pin op_a_32_reg[27] R -pin op_a_32_reg[28] R -pin op_a_32_reg[29] R -pin op_a_32_reg[2] R -pin op_a_32_reg[30] R -pin op_a_32_reg[31] R -pin op_a_32_reg[3] R -pin op_a_32_reg[4] R -pin op_a_32_reg[5] R -pin op_a_32_reg[6] R -pin op_a_32_reg[7] R -pin op_a_32_reg[8] R -pin op_a_32_reg[9] R -pin op_b_32_reg[0] R -pin op_b_32_reg[10] R -pin op_b_32_reg[11] R -pin op_b_32_reg[12] R -pin op_b_32_reg[13] R -pin op_b_32_reg[14] R -pin op_b_32_reg[15] R -pin op_b_32_reg[16] R -pin op_b_32_reg[17] R -pin op_b_32_reg[18] R -pin op_b_32_reg[19] R -pin op_b_32_reg[1] R -pin op_b_32_reg[20] R -pin op_b_32_reg[21] R -pin op_b_32_reg[22] R -pin op_b_32_reg[23] R -pin op_b_32_reg[24] R -pin op_b_32_reg[25] R -pin op_b_32_reg[26] R -pin op_b_32_reg[27] R -pin op_b_32_reg[28] R -pin op_b_32_reg[29] R -pin op_b_32_reg[2] R -pin op_b_32_reg[30] R -pin op_b_32_reg[31] R -pin op_b_32_reg[3] R -pin op_b_32_reg[4] R -pin op_b_32_reg[5] R -pin op_b_32_reg[6] R -pin op_b_32_reg[7] R -pin op_b_32_reg[8] R -pin op_b_32_reg[9] R -pin op_code_reg[0] R -pin op_code_reg[1] R -pin round_mode_reg R -pin show_seq[0]_i_1 I3 -pin show_seq[1]_i_1 I3
netloc btnU_IBUF 1 1 11 190 7750 NJ 7750 820 7750 NJ 7750 1360 9600 NJ 9600 NJ 9600 2180 9600 2590 10370 3130 10270 3540
load net clk -port clk -pin clk_IBUF_inst I
netloc clk 1 0 1 NJ 7630
load net clk_IBUF -pin clk_IBUF_BUFG_inst I -pin clk_IBUF_inst O
netloc clk_IBUF 1 1 1 NJ 7630
load net clk_IBUF_BUFG -pin FSM_sequential_state_reg[0] C -pin FSM_sequential_state_reg[1] C -pin FSM_sequential_state_reg[2] C -pin aluuu clk_IBUF_BUFG -pin clk_IBUF_BUFG_inst O -pin led_reg[0] C -pin led_reg[10] C -pin led_reg[11] C -pin led_reg[12] C -pin led_reg[13] C -pin led_reg[14] C -pin led_reg[15] C -pin led_reg[1] C -pin led_reg[2] C -pin led_reg[3] C -pin led_reg[4] C -pin led_reg[5] C -pin led_reg[6] C -pin led_reg[7] C -pin led_reg[8] C -pin led_reg[9] C -pin mode_fp_reg C -pin mode_fp_reg_rep C -pin mode_fp_reg_rep__0 C -pin mode_fp_reg_rep__1 C -pin mode_fp_reg_rep__2 C -pin mode_fp_reg_rep__3 C -pin mode_fp_reg_rep__4 C -pin mode_fp_reg_rep__5 C -pin mode_fp_reg_rep__6 C -pin op_a_32_reg[0] C -pin op_a_32_reg[10] C -pin op_a_32_reg[11] C -pin op_a_32_reg[12] C -pin op_a_32_reg[13] C -pin op_a_32_reg[14] C -pin op_a_32_reg[15] C -pin op_a_32_reg[16] C -pin op_a_32_reg[17] C -pin op_a_32_reg[18] C -pin op_a_32_reg[19] C -pin op_a_32_reg[1] C -pin op_a_32_reg[20] C -pin op_a_32_reg[21] C -pin op_a_32_reg[22] C -pin op_a_32_reg[23] C -pin op_a_32_reg[24] C -pin op_a_32_reg[25] C -pin op_a_32_reg[26] C -pin op_a_32_reg[27] C -pin op_a_32_reg[28] C -pin op_a_32_reg[29] C -pin op_a_32_reg[2] C -pin op_a_32_reg[30] C -pin op_a_32_reg[31] C -pin op_a_32_reg[3] C -pin op_a_32_reg[4] C -pin op_a_32_reg[5] C -pin op_a_32_reg[6] C -pin op_a_32_reg[7] C -pin op_a_32_reg[8] C -pin op_a_32_reg[9] C -pin op_b_32_reg[0] C -pin op_b_32_reg[10] C -pin op_b_32_reg[11] C -pin op_b_32_reg[12] C -pin op_b_32_reg[13] C -pin op_b_32_reg[14] C -pin op_b_32_reg[15] C -pin op_b_32_reg[16] C -pin op_b_32_reg[17] C -pin op_b_32_reg[18] C -pin op_b_32_reg[19] C -pin op_b_32_reg[1] C -pin op_b_32_reg[20] C -pin op_b_32_reg[21] C -pin op_b_32_reg[22] C -pin op_b_32_reg[23] C -pin op_b_32_reg[24] C -pin op_b_32_reg[25] C -pin op_b_32_reg[26] C -pin op_b_32_reg[27] C -pin op_b_32_reg[28] C -pin op_b_32_reg[29] C -pin op_b_32_reg[2] C -pin op_b_32_reg[30] C -pin op_b_32_reg[31] C -pin op_b_32_reg[3] C -pin op_b_32_reg[4] C -pin op_b_32_reg[5] C -pin op_b_32_reg[6] C -pin op_b_32_reg[7] C -pin op_b_32_reg[8] C -pin op_b_32_reg[9] C -pin op_code_reg[0] C -pin op_code_reg[1] C -pin round_mode_reg C -pin show_seq_reg[0] C -pin show_seq_reg[1] C
netloc clk_IBUF_BUFG 1 2 10 480 7770 NJ 7770 1080 7770 NJ 7770 1680 7790 NJ 7790 NJ 7790 2490 10530 3030 10690 3520
load net led[0] -attr @rip(#000000) 0 -port led[0] -pin led_OBUF[0]_inst O
load net led[10] -attr @rip(#000000) 10 -port led[10] -pin led_OBUF[10]_inst O
load net led[11] -attr @rip(#000000) 11 -port led[11] -pin led_OBUF[11]_inst O
load net led[12] -attr @rip(#000000) 12 -port led[12] -pin led_OBUF[12]_inst O
load net led[13] -attr @rip(#000000) 13 -port led[13] -pin led_OBUF[13]_inst O
load net led[14] -attr @rip(#000000) 14 -port led[14] -pin led_OBUF[14]_inst O
load net led[15] -attr @rip(#000000) 15 -port led[15] -pin led_OBUF[15]_inst O
load net led[1] -attr @rip(#000000) 1 -port led[1] -pin led_OBUF[1]_inst O
load net led[2] -attr @rip(#000000) 2 -port led[2] -pin led_OBUF[2]_inst O
load net led[3] -attr @rip(#000000) 3 -port led[3] -pin led_OBUF[3]_inst O
load net led[4] -attr @rip(#000000) 4 -port led[4] -pin led_OBUF[4]_inst O
load net led[5] -attr @rip(#000000) 5 -port led[5] -pin led_OBUF[5]_inst O
load net led[6] -attr @rip(#000000) 6 -port led[6] -pin led_OBUF[6]_inst O
load net led[7] -attr @rip(#000000) 7 -port led[7] -pin led_OBUF[7]_inst O
load net led[8] -attr @rip(#000000) 8 -port led[8] -pin led_OBUF[8]_inst O
load net led[9] -attr @rip(#000000) 9 -port led[9] -pin led_OBUF[9]_inst O
load net led_OBUF[0] -pin led_OBUF[0]_inst I -pin led_reg[0] Q
netloc led_OBUF[0] 1 12 1 N 8470
load net led_OBUF[10] -pin led_OBUF[10]_inst I -pin led_reg[10] Q
netloc led_OBUF[10] 1 12 1 N 9970
load net led_OBUF[11] -pin led_OBUF[11]_inst I -pin led_reg[11] Q
netloc led_OBUF[11] 1 12 1 N 10120
load net led_OBUF[12] -pin led_OBUF[12]_inst I -pin led_reg[12] Q
netloc led_OBUF[12] 1 12 1 N 10270
load net led_OBUF[13] -pin led_OBUF[13]_inst I -pin led_reg[13] Q
netloc led_OBUF[13] 1 12 1 N 10420
load net led_OBUF[14] -pin led_OBUF[14]_inst I -pin led_reg[14] Q
netloc led_OBUF[14] 1 12 1 N 10570
load net led_OBUF[15] -pin led_OBUF[15]_inst I -pin led_reg[15] Q
netloc led_OBUF[15] 1 12 1 N 10720
load net led_OBUF[1] -pin led_OBUF[1]_inst I -pin led_reg[1] Q
netloc led_OBUF[1] 1 12 1 N 8620
load net led_OBUF[2] -pin led_OBUF[2]_inst I -pin led_reg[2] Q
netloc led_OBUF[2] 1 12 1 N 8770
load net led_OBUF[3] -pin led_OBUF[3]_inst I -pin led_reg[3] Q
netloc led_OBUF[3] 1 12 1 N 8920
load net led_OBUF[4] -pin led_OBUF[4]_inst I -pin led_reg[4] Q
netloc led_OBUF[4] 1 12 1 N 9070
load net led_OBUF[5] -pin led_OBUF[5]_inst I -pin led_reg[5] Q
netloc led_OBUF[5] 1 12 1 N 9220
load net led_OBUF[6] -pin led_OBUF[6]_inst I -pin led_reg[6] Q
netloc led_OBUF[6] 1 12 1 N 9370
load net led_OBUF[7] -pin led_OBUF[7]_inst I -pin led_reg[7] Q
netloc led_OBUF[7] 1 12 1 N 9520
load net led_OBUF[8] -pin led_OBUF[8]_inst I -pin led_reg[8] Q
netloc led_OBUF[8] 1 12 1 N 9670
load net led_OBUF[9] -pin led_OBUF[9]_inst I -pin led_reg[9] Q
netloc led_OBUF[9] 1 12 1 N 9820
load net led_next[0] -attr @rip(#000000) D[0] -pin aluuu D[0] -pin led_reg[0] D
load net led_next[10] -attr @rip(#000000) D[10] -pin aluuu D[10] -pin led_reg[10] D
load net led_next[11] -attr @rip(#000000) D[11] -pin aluuu D[11] -pin led_reg[11] D
load net led_next[12] -attr @rip(#000000) D[12] -pin aluuu D[12] -pin led_reg[12] D
load net led_next[13] -attr @rip(#000000) D[13] -pin aluuu D[13] -pin led_reg[13] D
load net led_next[14] -attr @rip(#000000) D[14] -pin aluuu D[14] -pin led_reg[14] D
load net led_next[15] -attr @rip(#000000) D[15] -pin aluuu D[15] -pin led_reg[15] D
load net led_next[1] -attr @rip(#000000) D[1] -pin aluuu D[1] -pin led_reg[1] D
load net led_next[2] -attr @rip(#000000) D[2] -pin aluuu D[2] -pin led_reg[2] D
load net led_next[3] -attr @rip(#000000) D[3] -pin aluuu D[3] -pin led_reg[3] D
load net led_next[4] -attr @rip(#000000) D[4] -pin aluuu D[4] -pin led_reg[4] D
load net led_next[5] -attr @rip(#000000) D[5] -pin aluuu D[5] -pin led_reg[5] D
load net led_next[6] -attr @rip(#000000) D[6] -pin aluuu D[6] -pin led_reg[6] D
load net led_next[7] -attr @rip(#000000) D[7] -pin aluuu D[7] -pin led_reg[7] D
load net led_next[8] -attr @rip(#000000) D[8] -pin aluuu D[8] -pin led_reg[8] D
load net led_next[9] -attr @rip(#000000) D[9] -pin aluuu D[9] -pin led_reg[9] D
load net m_add/conv_a_out[30] -attr @rip(#000000) 14 -pin aluuu result_reg[31]_0[14] -pin op_a_32_reg[14] Q
load net m_add/conv_b_out[30] -attr @rip(#000000) 14 -pin aluuu result_reg[31]_1[14] -pin op_b_32_reg[14] Q
load net mode_fp -pin aluuu mode_fp -pin mode_fp_reg Q
netloc mode_fp 1 10 1 3110 10140n
load net mode_fp_reg_rep__0_n_0 -pin aluuu flags_reg[0]_i_1951 -pin mode_fp_reg_rep__0 Q
netloc mode_fp_reg_rep__0_n_0 1 10 1 N 10450
load net mode_fp_reg_rep__1_n_0 -pin aluuu flags_reg[0]_i_1072 -pin mode_fp_reg_rep__1 Q
netloc mode_fp_reg_rep__1_n_0 1 10 1 3010 10430n
load net mode_fp_reg_rep__2_n_0 -pin aluuu result_reg[20]_i_183 -pin mode_fp_reg_rep__2 Q
netloc mode_fp_reg_rep__2_n_0 1 10 1 3130 10550n
load net mode_fp_reg_rep__3_n_0 -pin aluuu flags_reg[0]_i_840 -pin mode_fp_reg_rep__3 Q
netloc mode_fp_reg_rep__3_n_0 1 10 1 3070 10410n
load net mode_fp_reg_rep__4_n_0 -pin aluuu n_m2__0 -pin mode_fp_reg_rep__4 Q
netloc mode_fp_reg_rep__4_n_0 1 10 1 3110 10490n
load net mode_fp_reg_rep__5_n_0 -pin aluuu n_m2__0_0 -pin mode_fp_reg_rep__5 Q
netloc mode_fp_reg_rep__5_n_0 1 10 1 3170 10510n
load net mode_fp_reg_rep__6_n_0 -pin aluuu result_reg[22]_0 -pin mode_fp_reg_rep__6 Q
netloc mode_fp_reg_rep__6_n_0 1 10 1 3210 10570n
load net mode_fp_reg_rep_n_0 -pin aluuu result_reg[15]_0 -pin mode_fp_reg_rep Q
netloc mode_fp_reg_rep_n_0 1 10 1 3090 10290n
load net op_a_32[17] -pin op_a_32[31]_i_1 O -pin op_a_32_reg[16] CE -pin op_a_32_reg[17] CE -pin op_a_32_reg[18] CE -pin op_a_32_reg[19] CE -pin op_a_32_reg[20] CE -pin op_a_32_reg[21] CE -pin op_a_32_reg[22] CE -pin op_a_32_reg[23] CE -pin op_a_32_reg[24] CE -pin op_a_32_reg[25] CE -pin op_a_32_reg[26] CE -pin op_a_32_reg[27] CE -pin op_a_32_reg[28] CE -pin op_a_32_reg[29] CE -pin op_a_32_reg[30] CE -pin op_a_32_reg[31] CE
netloc op_a_32[17] 1 9 1 2790 3820n
load net op_a_32[7] -pin op_a_32[15]_i_1 O -pin op_a_32_reg[0] CE -pin op_a_32_reg[10] CE -pin op_a_32_reg[11] CE -pin op_a_32_reg[12] CE -pin op_a_32_reg[13] CE -pin op_a_32_reg[14] CE -pin op_a_32_reg[15] CE -pin op_a_32_reg[1] CE -pin op_a_32_reg[2] CE -pin op_a_32_reg[3] CE -pin op_a_32_reg[4] CE -pin op_a_32_reg[5] CE -pin op_a_32_reg[6] CE -pin op_a_32_reg[7] CE -pin op_a_32_reg[8] CE -pin op_a_32_reg[9] CE
netloc op_a_32[7] 1 9 1 2390 70n
load net op_a_32_reg_n_0_[0] -attr @rip(#000000) 0 -pin aluuu result_reg[31]_0[0] -pin op_a_32_reg[0] Q
load net op_a_32_reg_n_0_[10] -attr @rip(#000000) 10 -pin aluuu result_reg[31]_0[10] -pin op_a_32_reg[10] Q
load net op_a_32_reg_n_0_[11] -attr @rip(#000000) 11 -pin aluuu result_reg[31]_0[11] -pin op_a_32_reg[11] Q
load net op_a_32_reg_n_0_[12] -attr @rip(#000000) 12 -pin aluuu result_reg[31]_0[12] -pin op_a_32_reg[12] Q
load net op_a_32_reg_n_0_[13] -attr @rip(#000000) 13 -pin aluuu result_reg[31]_0[13] -pin op_a_32_reg[13] Q
load net op_a_32_reg_n_0_[15] -attr @rip(#000000) 15 -pin aluuu result_reg[31]_0[15] -pin op_a_32_reg[15] Q
load net op_a_32_reg_n_0_[16] -attr @rip(#000000) 16 -pin aluuu result_reg[31]_0[16] -pin op_a_32_reg[16] Q
load net op_a_32_reg_n_0_[17] -attr @rip(#000000) 17 -pin aluuu result_reg[31]_0[17] -pin op_a_32_reg[17] Q
load net op_a_32_reg_n_0_[18] -attr @rip(#000000) 18 -pin aluuu result_reg[31]_0[18] -pin op_a_32_reg[18] Q
load net op_a_32_reg_n_0_[19] -attr @rip(#000000) 19 -pin aluuu result_reg[31]_0[19] -pin op_a_32_reg[19] Q
load net op_a_32_reg_n_0_[1] -attr @rip(#000000) 1 -pin aluuu result_reg[31]_0[1] -pin op_a_32_reg[1] Q
load net op_a_32_reg_n_0_[20] -attr @rip(#000000) 20 -pin aluuu result_reg[31]_0[20] -pin op_a_32_reg[20] Q
load net op_a_32_reg_n_0_[21] -attr @rip(#000000) 21 -pin aluuu result_reg[31]_0[21] -pin op_a_32_reg[21] Q
load net op_a_32_reg_n_0_[22] -attr @rip(#000000) 22 -pin aluuu result_reg[31]_0[22] -pin op_a_32_reg[22] Q
load net op_a_32_reg_n_0_[23] -attr @rip(#000000) 23 -pin aluuu result_reg[31]_0[23] -pin op_a_32_reg[23] Q
load net op_a_32_reg_n_0_[24] -attr @rip(#000000) 24 -pin aluuu result_reg[31]_0[24] -pin op_a_32_reg[24] Q
load net op_a_32_reg_n_0_[25] -attr @rip(#000000) 25 -pin aluuu result_reg[31]_0[25] -pin op_a_32_reg[25] Q
load net op_a_32_reg_n_0_[26] -attr @rip(#000000) 26 -pin aluuu result_reg[31]_0[26] -pin op_a_32_reg[26] Q
load net op_a_32_reg_n_0_[27] -attr @rip(#000000) 27 -pin aluuu result_reg[31]_0[27] -pin op_a_32_reg[27] Q
load net op_a_32_reg_n_0_[28] -attr @rip(#000000) 28 -pin aluuu result_reg[31]_0[28] -pin op_a_32_reg[28] Q
load net op_a_32_reg_n_0_[29] -attr @rip(#000000) 29 -pin aluuu result_reg[31]_0[29] -pin op_a_32_reg[29] Q
load net op_a_32_reg_n_0_[2] -attr @rip(#000000) 2 -pin aluuu result_reg[31]_0[2] -pin op_a_32_reg[2] Q
load net op_a_32_reg_n_0_[30] -attr @rip(#000000) 30 -pin aluuu result_reg[31]_0[30] -pin op_a_32_reg[30] Q
load net op_a_32_reg_n_0_[31] -attr @rip(#000000) 31 -pin aluuu result_reg[31]_0[31] -pin op_a_32_reg[31] Q
load net op_a_32_reg_n_0_[3] -attr @rip(#000000) 3 -pin aluuu result_reg[31]_0[3] -pin op_a_32_reg[3] Q
load net op_a_32_reg_n_0_[4] -attr @rip(#000000) 4 -pin aluuu result_reg[31]_0[4] -pin op_a_32_reg[4] Q
load net op_a_32_reg_n_0_[5] -attr @rip(#000000) 5 -pin aluuu result_reg[31]_0[5] -pin op_a_32_reg[5] Q
load net op_a_32_reg_n_0_[6] -attr @rip(#000000) 6 -pin aluuu result_reg[31]_0[6] -pin op_a_32_reg[6] Q
load net op_a_32_reg_n_0_[7] -attr @rip(#000000) 7 -pin aluuu result_reg[31]_0[7] -pin op_a_32_reg[7] Q
load net op_a_32_reg_n_0_[8] -attr @rip(#000000) 8 -pin aluuu result_reg[31]_0[8] -pin op_a_32_reg[8] Q
load net op_a_32_reg_n_0_[9] -attr @rip(#000000) 9 -pin aluuu result_reg[31]_0[9] -pin op_a_32_reg[9] Q
load net op_b_32[17] -pin op_b_32[31]_i_1 O -pin op_b_32_reg[16] CE -pin op_b_32_reg[17] CE -pin op_b_32_reg[18] CE -pin op_b_32_reg[19] CE -pin op_b_32_reg[20] CE -pin op_b_32_reg[21] CE -pin op_b_32_reg[22] CE -pin op_b_32_reg[23] CE -pin op_b_32_reg[24] CE -pin op_b_32_reg[25] CE -pin op_b_32_reg[26] CE -pin op_b_32_reg[27] CE -pin op_b_32_reg[28] CE -pin op_b_32_reg[29] CE -pin op_b_32_reg[30] CE -pin op_b_32_reg[31] CE
netloc op_b_32[17] 1 9 1 2810 6220n
load net op_b_32[7] -pin op_b_32[15]_i_1 O -pin op_b_32_reg[0] CE -pin op_b_32_reg[10] CE -pin op_b_32_reg[11] CE -pin op_b_32_reg[12] CE -pin op_b_32_reg[13] CE -pin op_b_32_reg[14] CE -pin op_b_32_reg[15] CE -pin op_b_32_reg[1] CE -pin op_b_32_reg[2] CE -pin op_b_32_reg[3] CE -pin op_b_32_reg[4] CE -pin op_b_32_reg[5] CE -pin op_b_32_reg[6] CE -pin op_b_32_reg[7] CE -pin op_b_32_reg[8] CE -pin op_b_32_reg[9] CE
netloc op_b_32[7] 1 9 1 2530 520n
load net op_b_32_reg_n_0_[0] -attr @rip(#000000) 0 -pin aluuu result_reg[31]_1[0] -pin op_b_32_reg[0] Q
load net op_b_32_reg_n_0_[10] -attr @rip(#000000) 10 -pin aluuu result_reg[31]_1[10] -pin op_b_32_reg[10] Q
load net op_b_32_reg_n_0_[11] -attr @rip(#000000) 11 -pin aluuu result_reg[31]_1[11] -pin op_b_32_reg[11] Q
load net op_b_32_reg_n_0_[12] -attr @rip(#000000) 12 -pin aluuu result_reg[31]_1[12] -pin op_b_32_reg[12] Q
load net op_b_32_reg_n_0_[13] -attr @rip(#000000) 13 -pin aluuu result_reg[31]_1[13] -pin op_b_32_reg[13] Q
load net op_b_32_reg_n_0_[15] -attr @rip(#000000) 15 -pin aluuu result_reg[31]_1[15] -pin op_b_32_reg[15] Q
load net op_b_32_reg_n_0_[16] -attr @rip(#000000) 16 -pin aluuu result_reg[31]_1[16] -pin op_b_32_reg[16] Q
load net op_b_32_reg_n_0_[17] -attr @rip(#000000) 17 -pin aluuu result_reg[31]_1[17] -pin op_b_32_reg[17] Q
load net op_b_32_reg_n_0_[18] -attr @rip(#000000) 18 -pin aluuu result_reg[31]_1[18] -pin op_b_32_reg[18] Q
load net op_b_32_reg_n_0_[19] -attr @rip(#000000) 19 -pin aluuu result_reg[31]_1[19] -pin op_b_32_reg[19] Q
load net op_b_32_reg_n_0_[1] -attr @rip(#000000) 1 -pin aluuu result_reg[31]_1[1] -pin op_b_32_reg[1] Q
load net op_b_32_reg_n_0_[20] -attr @rip(#000000) 20 -pin aluuu result_reg[31]_1[20] -pin op_b_32_reg[20] Q
load net op_b_32_reg_n_0_[21] -attr @rip(#000000) 21 -pin aluuu result_reg[31]_1[21] -pin op_b_32_reg[21] Q
load net op_b_32_reg_n_0_[22] -attr @rip(#000000) 22 -pin aluuu result_reg[31]_1[22] -pin op_b_32_reg[22] Q
load net op_b_32_reg_n_0_[23] -attr @rip(#000000) 23 -pin aluuu result_reg[31]_1[23] -pin op_b_32_reg[23] Q
load net op_b_32_reg_n_0_[24] -attr @rip(#000000) 24 -pin aluuu result_reg[31]_1[24] -pin op_b_32_reg[24] Q
load net op_b_32_reg_n_0_[25] -attr @rip(#000000) 25 -pin aluuu result_reg[31]_1[25] -pin op_b_32_reg[25] Q
load net op_b_32_reg_n_0_[26] -attr @rip(#000000) 26 -pin aluuu result_reg[31]_1[26] -pin op_b_32_reg[26] Q
load net op_b_32_reg_n_0_[27] -attr @rip(#000000) 27 -pin aluuu result_reg[31]_1[27] -pin op_b_32_reg[27] Q
load net op_b_32_reg_n_0_[28] -attr @rip(#000000) 28 -pin aluuu result_reg[31]_1[28] -pin op_b_32_reg[28] Q
load net op_b_32_reg_n_0_[29] -attr @rip(#000000) 29 -pin aluuu result_reg[31]_1[29] -pin op_b_32_reg[29] Q
load net op_b_32_reg_n_0_[2] -attr @rip(#000000) 2 -pin aluuu result_reg[31]_1[2] -pin op_b_32_reg[2] Q
load net op_b_32_reg_n_0_[30] -attr @rip(#000000) 30 -pin aluuu result_reg[31]_1[30] -pin op_b_32_reg[30] Q
load net op_b_32_reg_n_0_[31] -attr @rip(#000000) 31 -pin aluuu result_reg[31]_1[31] -pin op_b_32_reg[31] Q
load net op_b_32_reg_n_0_[3] -attr @rip(#000000) 3 -pin aluuu result_reg[31]_1[3] -pin op_b_32_reg[3] Q
load net op_b_32_reg_n_0_[4] -attr @rip(#000000) 4 -pin aluuu result_reg[31]_1[4] -pin op_b_32_reg[4] Q
load net op_b_32_reg_n_0_[5] -attr @rip(#000000) 5 -pin aluuu result_reg[31]_1[5] -pin op_b_32_reg[5] Q
load net op_b_32_reg_n_0_[6] -attr @rip(#000000) 6 -pin aluuu result_reg[31]_1[6] -pin op_b_32_reg[6] Q
load net op_b_32_reg_n_0_[7] -attr @rip(#000000) 7 -pin aluuu result_reg[31]_1[7] -pin op_b_32_reg[7] Q
load net op_b_32_reg_n_0_[8] -attr @rip(#000000) 8 -pin aluuu result_reg[31]_1[8] -pin op_b_32_reg[8] Q
load net op_b_32_reg_n_0_[9] -attr @rip(#000000) 9 -pin aluuu result_reg[31]_1[9] -pin op_b_32_reg[9] Q
load net op_code -pin mode_fp_i_1 O -pin mode_fp_reg CE -pin mode_fp_reg_rep CE -pin mode_fp_reg_rep__0 CE -pin mode_fp_reg_rep__1 CE -pin mode_fp_reg_rep__2 CE -pin mode_fp_reg_rep__3 CE -pin mode_fp_reg_rep__4 CE -pin mode_fp_reg_rep__5 CE -pin mode_fp_reg_rep__6 CE -pin op_code_reg[0] CE -pin op_code_reg[1] CE -pin round_mode_reg CE
netloc op_code 1 9 1 2510 7600n
load net op_code_reg_n_0_[0] -attr @rip(#000000) 0 -pin aluuu Q[0] -pin op_code_reg[0] Q
load net op_code_reg_n_0_[1] -attr @rip(#000000) 1 -pin aluuu Q[1] -pin op_code_reg[1] Q
load net round_mode -pin aluuu round_mode -pin round_mode_reg Q
netloc round_mode 1 10 1 3050 9990n
load net show_seq[0] -attr @rip(#000000) 0 -pin aluuu show_seq[0] -pin show_seq[0]_i_1 I0 -pin show_seq[1]_i_1 I2 -pin show_seq_reg[0] Q
load net show_seq[0]_i_1_n_0 -pin show_seq[0]_i_1 O -pin show_seq_reg[0] D
netloc show_seq[0]_i_1_n_0 1 9 1 2470 11410n
load net show_seq[1] -attr @rip(#000000) 1 -pin aluuu show_seq[1] -pin show_seq[0]_i_1 I2 -pin show_seq[1]_i_1 I0 -pin show_seq_reg[1] Q
load net show_seq[1]_i_1_n_0 -pin show_seq[1]_i_1 O -pin show_seq_reg[1] D
netloc show_seq[1]_i_1_n_0 1 9 1 2390 11540n
load net show_seq[1]_i_2_n_0 -pin show_seq[0]_i_1 I1 -pin show_seq[1]_i_1 I1 -pin show_seq[1]_i_2 O
netloc show_seq[1]_i_2_n_0 1 8 1 2140 7710n
load net state[0] -pin FSM_sequential_state[0]_i_1 I2 -pin FSM_sequential_state[1]_i_1 I2 -pin FSM_sequential_state[2]_i_1 I1 -pin FSM_sequential_state_reg[0] Q -pin mode_fp_i_1 I0 -pin op_a_32[15]_i_1 I0 -pin op_a_32[31]_i_1 I1 -pin op_b_32[15]_i_1 I0 -pin op_b_32[31]_i_1 I1 -pin show_seq[1]_i_2 I2
netloc state[0] 1 1 8 190 7420 NJ 7420 820 7490 NJ 7490 1420 7510 NJ 7510 1980 7580 2140
load net state[1] -pin FSM_sequential_state[0]_i_1 I1 -pin FSM_sequential_state[1]_i_1 I1 -pin FSM_sequential_state[2]_i_1 I0 -pin FSM_sequential_state_reg[1] Q -pin mode_fp_i_1 I2 -pin op_a_32[15]_i_1 I1 -pin op_a_32[31]_i_1 I0 -pin op_b_32[15]_i_1 I2 -pin op_b_32[31]_i_1 I2 -pin show_seq[1]_i_2 I0
netloc state[1] 1 1 8 210 7440 NJ 7440 780 7690 NJ 7690 1400 7710 NJ 7710 1940 7650 2160
load net state[2] -pin FSM_sequential_state[0]_i_1 I4 -pin FSM_sequential_state[1]_i_1 I4 -pin FSM_sequential_state[2]_i_1 I3 -pin FSM_sequential_state_reg[2] Q -pin mode_fp_i_1 I1 -pin op_a_32[15]_i_1 I2 -pin op_a_32[31]_i_1 I2 -pin op_b_32[15]_i_1 I1 -pin op_b_32[31]_i_1 I0 -pin show_seq[1]_i_2 I1
netloc state[2] 1 1 8 210 7730 NJ 7730 740 7730 NJ 7730 1420 7730 NJ 7730 1960 7560 2200
load net sw[0] -attr @rip(#000000) sw[0] -port sw[0] -pin sw_IBUF[0]_inst I
load net sw[10] -attr @rip(#000000) sw[10] -port sw[10] -pin sw_IBUF[10]_inst I
load net sw[11] -attr @rip(#000000) sw[11] -port sw[11] -pin sw_IBUF[11]_inst I
load net sw[12] -attr @rip(#000000) sw[12] -port sw[12] -pin sw_IBUF[12]_inst I
load net sw[13] -attr @rip(#000000) sw[13] -port sw[13] -pin sw_IBUF[13]_inst I
load net sw[14] -attr @rip(#000000) sw[14] -port sw[14] -pin sw_IBUF[14]_inst I
load net sw[15] -attr @rip(#000000) sw[15] -port sw[15] -pin sw_IBUF[15]_inst I
load net sw[1] -attr @rip(#000000) sw[1] -port sw[1] -pin sw_IBUF[1]_inst I
load net sw[2] -attr @rip(#000000) sw[2] -port sw[2] -pin sw_IBUF[2]_inst I
load net sw[3] -attr @rip(#000000) sw[3] -port sw[3] -pin sw_IBUF[3]_inst I
load net sw[4] -attr @rip(#000000) sw[4] -port sw[4] -pin sw_IBUF[4]_inst I
load net sw[5] -attr @rip(#000000) sw[5] -port sw[5] -pin sw_IBUF[5]_inst I
load net sw[6] -attr @rip(#000000) sw[6] -port sw[6] -pin sw_IBUF[6]_inst I
load net sw[7] -attr @rip(#000000) sw[7] -port sw[7] -pin sw_IBUF[7]_inst I
load net sw[8] -attr @rip(#000000) sw[8] -port sw[8] -pin sw_IBUF[8]_inst I
load net sw[9] -attr @rip(#000000) sw[9] -port sw[9] -pin sw_IBUF[9]_inst I
load net sw_IBUF[0] -pin op_a_32_reg[0] D -pin op_a_32_reg[16] D -pin op_b_32_reg[0] D -pin op_b_32_reg[16] D -pin sw_IBUF[0]_inst O
netloc sw_IBUF[0] 1 9 1 2510 90n
load net sw_IBUF[10] -pin op_a_32_reg[10] D -pin op_a_32_reg[26] D -pin op_b_32_reg[10] D -pin op_b_32_reg[26] D -pin sw_IBUF[10]_inst O
netloc sw_IBUF[10] 1 9 1 2450 2940n
load net sw_IBUF[11] -pin op_a_32_reg[11] D -pin op_a_32_reg[27] D -pin op_b_32_reg[11] D -pin op_b_32_reg[27] D -pin sw_IBUF[11]_inst O
netloc sw_IBUF[11] 1 9 1 2570 3090n
load net sw_IBUF[12] -pin op_a_32_reg[12] D -pin op_a_32_reg[28] D -pin op_b_32_reg[12] D -pin op_b_32_reg[28] D -pin round_mode_reg D -pin sw_IBUF[12]_inst O
netloc sw_IBUF[12] 1 9 1 2610 3240n
load net sw_IBUF[13] -pin mode_fp_reg D -pin mode_fp_reg_rep D -pin mode_fp_reg_rep__0 D -pin mode_fp_reg_rep__1 D -pin mode_fp_reg_rep__2 D -pin mode_fp_reg_rep__3 D -pin mode_fp_reg_rep__4 D -pin mode_fp_reg_rep__5 D -pin mode_fp_reg_rep__6 D -pin op_a_32_reg[13] D -pin op_a_32_reg[29] D -pin op_b_32_reg[13] D -pin op_b_32_reg[29] D -pin sw_IBUF[13]_inst O
netloc sw_IBUF[13] 1 9 1 2410 3390n
load net sw_IBUF[14] -pin op_a_32_reg[14] D -pin op_a_32_reg[30] D -pin op_b_32_reg[14] D -pin op_b_32_reg[30] D -pin op_code_reg[0] D -pin sw_IBUF[14]_inst O
netloc sw_IBUF[14] 1 9 1 2770 3540n
load net sw_IBUF[15] -pin op_a_32_reg[15] D -pin op_a_32_reg[31] D -pin op_b_32_reg[15] D -pin op_b_32_reg[31] D -pin op_code_reg[1] D -pin sw_IBUF[15]_inst O
netloc sw_IBUF[15] 1 9 1 2630 3690n
load net sw_IBUF[1] -pin op_a_32_reg[17] D -pin op_a_32_reg[1] D -pin op_b_32_reg[17] D -pin op_b_32_reg[1] D -pin sw_IBUF[1]_inst O
netloc sw_IBUF[1] 1 9 1 2670 240n
load net sw_IBUF[2] -pin op_a_32_reg[18] D -pin op_a_32_reg[2] D -pin op_b_32_reg[18] D -pin op_b_32_reg[2] D -pin sw_IBUF[2]_inst O
netloc sw_IBUF[2] 1 9 1 2650 390n
load net sw_IBUF[3] -pin op_a_32_reg[19] D -pin op_a_32_reg[3] D -pin op_b_32_reg[19] D -pin op_b_32_reg[3] D -pin sw_IBUF[3]_inst O
netloc sw_IBUF[3] 1 9 1 2690 990n
load net sw_IBUF[4] -pin op_a_32_reg[20] D -pin op_a_32_reg[4] D -pin op_b_32_reg[20] D -pin op_b_32_reg[4] D -pin sw_IBUF[4]_inst O
netloc sw_IBUF[4] 1 9 1 2710 1290n
load net sw_IBUF[5] -pin op_a_32_reg[21] D -pin op_a_32_reg[5] D -pin op_b_32_reg[21] D -pin op_b_32_reg[5] D -pin sw_IBUF[5]_inst O
netloc sw_IBUF[5] 1 9 1 2730 1590n
load net sw_IBUF[6] -pin op_a_32_reg[22] D -pin op_a_32_reg[6] D -pin op_b_32_reg[22] D -pin op_b_32_reg[6] D -pin sw_IBUF[6]_inst O
netloc sw_IBUF[6] 1 9 1 2470 1890n
load net sw_IBUF[7] -pin op_a_32_reg[23] D -pin op_a_32_reg[7] D -pin op_b_32_reg[23] D -pin op_b_32_reg[7] D -pin sw_IBUF[7]_inst O
netloc sw_IBUF[7] 1 9 1 2750 2190n
load net sw_IBUF[8] -pin op_a_32_reg[24] D -pin op_a_32_reg[8] D -pin op_b_32_reg[24] D -pin op_b_32_reg[8] D -pin sw_IBUF[8]_inst O
netloc sw_IBUF[8] 1 9 1 2430 2490n
load net sw_IBUF[9] -pin op_a_32_reg[25] D -pin op_a_32_reg[9] D -pin op_b_32_reg[25] D -pin op_b_32_reg[9] D -pin sw_IBUF[9]_inst O
netloc sw_IBUF[9] 1 9 1 2550 2790n
load netBundle @sw 16 sw[15] sw[14] sw[13] sw[12] sw[11] sw[10] sw[9] sw[8] sw[7] sw[6] sw[5] sw[4] sw[3] sw[2] sw[1] sw[0] -autobundled
netbloc @sw 1 0 9 NJ 6240 NJ 6240 NJ 6240 NJ 6240 NJ 6240 NJ 6240 NJ 6240 NJ 6240 2180
load netBundle @led 16 led[15] led[14] led[13] led[12] led[11] led[10] led[9] led[8] led[7] led[6] led[5] led[4] led[3] led[2] led[1] led[0] -autobundled
netbloc @led 1 13 1 3890 8470n
load netBundle @led_next 16 led_next[15] led_next[14] led_next[13] led_next[12] led_next[11] led_next[10] led_next[9] led_next[8] led_next[7] led_next[6] led_next[5] led_next[4] led_next[3] led_next[2] led_next[1] led_next[0] -autobundled
netbloc @led_next 1 11 1 3560 8480n
load netBundle @op_code_reg_n_0_ 2 op_code_reg_n_0_[1] op_code_reg_n_0_[0] -autobundled
netbloc @op_code_reg_n_0_ 1 10 1 3170 9690n
load netBundle @op_a_32_reg_n_0_ 32 op_a_32_reg_n_0_[31] op_a_32_reg_n_0_[30] op_a_32_reg_n_0_[29] op_a_32_reg_n_0_[28] op_a_32_reg_n_0_[27] op_a_32_reg_n_0_[26] op_a_32_reg_n_0_[25] op_a_32_reg_n_0_[24] op_a_32_reg_n_0_[23] op_a_32_reg_n_0_[22] op_a_32_reg_n_0_[21] op_a_32_reg_n_0_[20] op_a_32_reg_n_0_[19] op_a_32_reg_n_0_[18] op_a_32_reg_n_0_[17] op_a_32_reg_n_0_[16] op_a_32_reg_n_0_[15] m_add/conv_a_out[30] op_a_32_reg_n_0_[13] op_a_32_reg_n_0_[12] op_a_32_reg_n_0_[11] op_a_32_reg_n_0_[10] op_a_32_reg_n_0_[9] op_a_32_reg_n_0_[8] op_a_32_reg_n_0_[7] op_a_32_reg_n_0_[6] op_a_32_reg_n_0_[5] op_a_32_reg_n_0_[4] op_a_32_reg_n_0_[3] op_a_32_reg_n_0_[2] op_a_32_reg_n_0_[1] op_a_32_reg_n_0_[0] -autobundled
netbloc @op_a_32_reg_n_0_ 1 10 1 3190 80n
load netBundle @op_b_32_reg_n_0_ 32 op_b_32_reg_n_0_[31] op_b_32_reg_n_0_[30] op_b_32_reg_n_0_[29] op_b_32_reg_n_0_[28] op_b_32_reg_n_0_[27] op_b_32_reg_n_0_[26] op_b_32_reg_n_0_[25] op_b_32_reg_n_0_[24] op_b_32_reg_n_0_[23] op_b_32_reg_n_0_[22] op_b_32_reg_n_0_[21] op_b_32_reg_n_0_[20] op_b_32_reg_n_0_[19] op_b_32_reg_n_0_[18] op_b_32_reg_n_0_[17] op_b_32_reg_n_0_[16] op_b_32_reg_n_0_[15] m_add/conv_b_out[30] op_b_32_reg_n_0_[13] op_b_32_reg_n_0_[12] op_b_32_reg_n_0_[11] op_b_32_reg_n_0_[10] op_b_32_reg_n_0_[9] op_b_32_reg_n_0_[8] op_b_32_reg_n_0_[7] op_b_32_reg_n_0_[6] op_b_32_reg_n_0_[5] op_b_32_reg_n_0_[4] op_b_32_reg_n_0_[3] op_b_32_reg_n_0_[2] op_b_32_reg_n_0_[1] op_b_32_reg_n_0_[0] -autobundled
netbloc @op_b_32_reg_n_0_ 1 10 1 3150 530n
load netBundle @show_seq 2 show_seq[1] show_seq[0] -autobundled
netbloc @show_seq 1 8 3 2200 11620 NJ 11620 3230
levelinfo -pg 1 0 40 300 590 910 1190 1510 1790 2030 2250 2880 3380 3620 3740 3910
pagesize -pg 1 -db -bbox -sgen -100 0 4020 11820
show
zoom 0.0561151
scrollpos -500 -6
#
# initialize ictrl to current module top work:top:NOFILE
ictrl init topinfo |
