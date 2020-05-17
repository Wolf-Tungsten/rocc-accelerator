// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Sat May 16 20:29:53 2020
// Host        : ubuntu running 64-bit Ubuntu 18.04.4 LTS
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ Mul8bit_sim_netlist.v
// Design      : Mul8bit
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tfgg484-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "Mul8bit,mult_gen_v12_0_16,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_16,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (CLK,
    A,
    B,
    CE,
    SCLR,
    P);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 clk_intf CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME clk_intf, ASSOCIATED_BUSIF p_intf:b_intf:a_intf, ASSOCIATED_RESET sclr, ASSOCIATED_CLKEN ce, FREQ_HZ 10000000, PHASE 0.000, INSERT_VIP 0" *) input CLK;
  (* x_interface_info = "xilinx.com:signal:data:1.0 a_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME a_intf, LAYERED_METADATA undef" *) input [7:0]A;
  (* x_interface_info = "xilinx.com:signal:data:1.0 b_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME b_intf, LAYERED_METADATA undef" *) input [7:0]B;
  (* x_interface_info = "xilinx.com:signal:clockenable:1.0 ce_intf CE" *) (* x_interface_parameter = "XIL_INTERFACENAME ce_intf, POLARITY ACTIVE_HIGH" *) input CE;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 sclr_intf RST" *) (* x_interface_parameter = "XIL_INTERFACENAME sclr_intf, POLARITY ACTIVE_HIGH, INSERT_VIP 0" *) input SCLR;
  (* x_interface_info = "xilinx.com:signal:data:1.0 p_intf DATA" *) (* x_interface_parameter = "XIL_INTERFACENAME p_intf, LAYERED_METADATA undef" *) output [15:0]P;

  wire [7:0]A;
  wire [7:0]B;
  wire CE;
  wire CLK;
  wire [15:0]P;
  wire SCLR;
  wire [47:0]NLW_U0_PCASC_UNCONNECTED;
  wire [1:0]NLW_U0_ZERO_DETECT_UNCONNECTED;

  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "8" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "8" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "3" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "1" *) 
  (* C_OPTIMIZE_GOAL = "1" *) 
  (* C_OUT_HIGH = "15" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_mult_gen_v12_0_16 U0
       (.A(A),
        .B(B),
        .CE(CE),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_U0_PCASC_UNCONNECTED[47:0]),
        .SCLR(SCLR),
        .ZERO_DETECT(NLW_U0_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule

(* C_A_TYPE = "0" *) (* C_A_WIDTH = "8" *) (* C_B_TYPE = "0" *) 
(* C_B_VALUE = "10000001" *) (* C_B_WIDTH = "8" *) (* C_CCM_IMP = "0" *) 
(* C_CE_OVERRIDES_SCLR = "0" *) (* C_HAS_CE = "1" *) (* C_HAS_SCLR = "1" *) 
(* C_HAS_ZERO_DETECT = "0" *) (* C_LATENCY = "3" *) (* C_MODEL_TYPE = "0" *) 
(* C_MULT_TYPE = "1" *) (* C_OPTIMIZE_GOAL = "1" *) (* C_OUT_HIGH = "15" *) 
(* C_OUT_LOW = "0" *) (* C_ROUND_OUTPUT = "0" *) (* C_ROUND_PT = "0" *) 
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* downgradeipidentifiedwarnings = "yes" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_mult_gen_v12_0_16
   (CLK,
    A,
    B,
    CE,
    SCLR,
    ZERO_DETECT,
    P,
    PCASC);
  input CLK;
  input [7:0]A;
  input [7:0]B;
  input CE;
  input SCLR;
  output [1:0]ZERO_DETECT;
  output [15:0]P;
  output [47:0]PCASC;

  wire \<const0> ;
  wire [7:0]A;
  wire [7:0]B;
  wire CE;
  wire CLK;
  wire [15:0]P;
  wire SCLR;
  wire [47:0]NLW_i_mult_PCASC_UNCONNECTED;
  wire [1:0]NLW_i_mult_ZERO_DETECT_UNCONNECTED;

  assign PCASC[47] = \<const0> ;
  assign PCASC[46] = \<const0> ;
  assign PCASC[45] = \<const0> ;
  assign PCASC[44] = \<const0> ;
  assign PCASC[43] = \<const0> ;
  assign PCASC[42] = \<const0> ;
  assign PCASC[41] = \<const0> ;
  assign PCASC[40] = \<const0> ;
  assign PCASC[39] = \<const0> ;
  assign PCASC[38] = \<const0> ;
  assign PCASC[37] = \<const0> ;
  assign PCASC[36] = \<const0> ;
  assign PCASC[35] = \<const0> ;
  assign PCASC[34] = \<const0> ;
  assign PCASC[33] = \<const0> ;
  assign PCASC[32] = \<const0> ;
  assign PCASC[31] = \<const0> ;
  assign PCASC[30] = \<const0> ;
  assign PCASC[29] = \<const0> ;
  assign PCASC[28] = \<const0> ;
  assign PCASC[27] = \<const0> ;
  assign PCASC[26] = \<const0> ;
  assign PCASC[25] = \<const0> ;
  assign PCASC[24] = \<const0> ;
  assign PCASC[23] = \<const0> ;
  assign PCASC[22] = \<const0> ;
  assign PCASC[21] = \<const0> ;
  assign PCASC[20] = \<const0> ;
  assign PCASC[19] = \<const0> ;
  assign PCASC[18] = \<const0> ;
  assign PCASC[17] = \<const0> ;
  assign PCASC[16] = \<const0> ;
  assign PCASC[15] = \<const0> ;
  assign PCASC[14] = \<const0> ;
  assign PCASC[13] = \<const0> ;
  assign PCASC[12] = \<const0> ;
  assign PCASC[11] = \<const0> ;
  assign PCASC[10] = \<const0> ;
  assign PCASC[9] = \<const0> ;
  assign PCASC[8] = \<const0> ;
  assign PCASC[7] = \<const0> ;
  assign PCASC[6] = \<const0> ;
  assign PCASC[5] = \<const0> ;
  assign PCASC[4] = \<const0> ;
  assign PCASC[3] = \<const0> ;
  assign PCASC[2] = \<const0> ;
  assign PCASC[1] = \<const0> ;
  assign PCASC[0] = \<const0> ;
  assign ZERO_DETECT[1] = \<const0> ;
  assign ZERO_DETECT[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  (* C_A_TYPE = "0" *) 
  (* C_A_WIDTH = "8" *) 
  (* C_B_TYPE = "0" *) 
  (* C_B_VALUE = "10000001" *) 
  (* C_B_WIDTH = "8" *) 
  (* C_CCM_IMP = "0" *) 
  (* C_CE_OVERRIDES_SCLR = "0" *) 
  (* C_HAS_CE = "1" *) 
  (* C_HAS_SCLR = "1" *) 
  (* C_HAS_ZERO_DETECT = "0" *) 
  (* C_LATENCY = "3" *) 
  (* C_MODEL_TYPE = "0" *) 
  (* C_MULT_TYPE = "1" *) 
  (* C_OPTIMIZE_GOAL = "1" *) 
  (* C_OUT_HIGH = "15" *) 
  (* C_OUT_LOW = "0" *) 
  (* C_ROUND_OUTPUT = "0" *) 
  (* C_ROUND_PT = "0" *) 
  (* C_VERBOSITY = "0" *) 
  (* C_XDEVICEFAMILY = "artix7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_mult_gen_v12_0_16_viv i_mult
       (.A(A),
        .B(B),
        .CE(CE),
        .CLK(CLK),
        .P(P),
        .PCASC(NLW_i_mult_PCASC_UNCONNECTED[47:0]),
        .SCLR(SCLR),
        .ZERO_DETECT(NLW_i_mult_ZERO_DETECT_UNCONNECTED[1:0]));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2019.1"
`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="cds_rsa_key", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=64)
`pragma protect key_block
HPMPLvpmoX7LOmPj78BMT9X1rCnPz6PdhVGZQ307N9haGfAdMGVirvGR3e0Glyn2ieoWqXA6qOQL
t0xn28+h0g==

`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
Nxv/BnutRgdmHnLyK7kvDGjm7WGfFKW2mxQ6xUKF14zS4ziz5pSV0ueW4VqAzUyEPsErIAEuyV6F
m5KCqRBB197Q2NbZa7O7tdAqboX6tPAJzbB6u4U/MmNS1AQcSgtfj5srMbdBzDa5pR4V3HrI0MRj
0xhV1BWf725FYPP4av0=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
F5KGJgEDQsX2btdjtRUlSmNtuyodIhGXEa3/AXv1Y7qgSO8gknBfiqj5HcIaVA9b4npQpDnNcmq+
1ONAqLeLhdOm9TES+GsTAkh/lClvl89bzfqgOV33iqwQHYIHwSsWMRXT9JSUx+YWu+g6xKpT1Ycn
8BCPsq4QUJIqL6W16fheEHB/lkMgnespIWEYJJG6R6zvv2zG8GiU6cG8zHrRjdvAj8kOkhmiMvSd
YjGXJSMfjw7ojCPSUF+nb6WWhUEmoMA/6lgSVaXRm00YHSZ09k7rKTJWSXFSpTmkL2WOsQhNS0ek
jdTK2KF5K6z2YOK4zkfHgZ+fB0KJyANaLLJH/Q==

`pragma protect key_keyowner="ATRENTA", key_keyname="ATR-SG-2015-RSA-3", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
lFuQXeJ0hi7qnIKAR+37XCSOwp8bGLukonngcICceOVpL87+rxvhP5TyNJ/zXpAWDF0BaRYlGr7d
isPiUStrvUthNyOqCr4vFZyhCdY8n+Mrv3OCvLoLQSarxVXbaKbXb0tPsXJCUdXTrCt9mr5x0Nda
6DAI8FBPlFMAiqnFXnYMwlUiSlkNWUpInuNw7+1eD8kUdckEUV1PDwZ0yjpFqMokMH9oJjN6z0Yy
65D8Tqo288ZMfZQuIimjski+X6EK157XbpyuoZIuYLJ7j6oaATdintgfZpgGzVvhCZtMbx6/SJtR
efW5vLBGiGs7rPBPE2T8fosHGOvmeC9QBSj8Ww==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2019_02", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Q8VVvHzTNgU3tZr4+8ia7ylST+kbNPWskONHDOT1dTkB7cHZIAWyzXpQZPuEgk2wJq21PoqmVlG9
t08IYzkfC8vYQ2LRf2Co3SXc7p3gF2OFMC68J9Nf9D+/PXJCJy3QO4H8oO39l6bn8c56K2ARnK0R
mMIALbCWSBDGCWGQmXWZJ+xmDGs1KgTeiSW3bZRftWJ6K8l8BhMit8BLOY2Mi3jJ0WRhN8kKd6JT
D4NU1jTZT6jEtmI7Gnj/AXG6auTqDPHsVQzf+ZzBsLTfw83CFoO70xM997L5cZXlqz8fEDmxezkr
wWxPwJbJeVkRV3tUxlo2Bs2x1uVkXQeNVMI8jg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
oUeTLA0HA2uKORUHo1HidNC3lw54gxwlLUkv28qRPv1pz7AEVUbIJ7wsyu2Scju+EkC2Ivi8HbBn
jxkeqRDTAwAbAqIKnY3AdyfojN9Hb8SMLcLnpWLLCpb6E0vwA09r7uqKRZ8wYAgT9CPFvzpQ3zKt
9DTLgQ3rZtFxx2nfCug=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Fayrlym1l14Y48yZ195XboT9ZQmp/mAzUyHby3Y9qJTzDF+m6mRQ/ZbebObo8bu4VAm45JeETPx1
YI4UZNOK4IqKv0BZsAlzUfAYAmqmkmIJYbn2gWUCwXyKX5AoA4ONnlxEHxzZhqtsmEXvxwTEs25/
R7iLzeoMfmwwNHgPNQkteiR4zDlB76CYmgu6EOSUX5Nnitq1oh7qRuU8WqWN7lLfgIC6T7qNHwGD
RPze2yiP06fSG45jPrOn2fvBX9SRbUXjNtiFgmqim4anwJU46v7y3ubit/I6giZhz5PJMZfkDaFX
ag+uCMq4Q8ZEolqMBmjUjat86BdVd4Nmr0yUaA==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kIpxh3qIIkWUg8aLJSPKvKhKTPFH7T8fisti5RtNaftS7xh3KDsGLYnF1lYhH2RVXgzbdaVqvtED
5QJazVo6wUFI91xgFeOR5jX+Ny5UBUX2MngsK+UZyZg5+EdtSiDtiJNtQqgjq1Rn+XQCGF3xP80n
7YvuVMbgRHCAfWrWw7ZJ7Y3raRzeIkx+koPFio7XnC+QdRJ0ItO1YtQgF4Sg1Ihr5TH8/RrNn903
kPa+anH9spo3SFCf2Ts11UXAGLdIBmOLMtEAKjjCUbtmjGSeSc0gn2q2I+xRTFcegLevlr/iuLTw
3lFndBAoW40xOiCDjWZ6Rz7J+jZhsRl3D0Bhwg==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-PREC-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
n9sRZxMEBoJgp2NBRZ3/65YhubL4BDMh/uhmGyB72dG+9boJ9CdWHYecBeFsqtEo5mkbMLTRgaY7
sMeHoSGbled1pID5L9ihZmdwKXuCYpXUA58+4/lhlfegF5LAUk6kM1tcHKsSkDiv/j5232/La14x
IogzgJrgfGyJ0tO2BB7shmQUFG6lz03kK91XHCNPW566Yf9fWcx/tIDZz8Ds0aSLdAjJDSTWZOHq
fST/HN/z924Wg1Zt6MbIDZTXlSEXq1cgdhxoFZbqToNhkvKrnEG14OFgN4jRstdew5NH+Gsq9XeY
UzLE9MKb51mf3b7lvP5vif4SDTQNc/Er75Ho8g==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
GbvKAfIv4E2L72bOF+QAvf1QB4u5UZ+AUUnaK7T1YBD7KK8H5QRTClEWYqP9RC2b+9R1YWbXI492
oecbk5SP19OCHNcxP6Ig7vWF39zOaNdx+WMzSM9bVSPHLsnpkBcUy28McN63oU0o0liD6dhy6WPo
Hv+ENRSJt7cysiD5cQHJnS1iBk0He+cJM/sV6sCfGxzYJF0BGgPbvg3wkJEdZAaD1DMW/y0x8qCX
KO3RnI9jGvkTVDQkkEKwbzb0R+SPLHZNs6jSumacMbApljNkc8EJg6uu2riZ8qR0fkX+KU36F449
uMjdWN5FMQtYX3+pFs36E5ISb/KngFpnhgumdg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 7392)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
