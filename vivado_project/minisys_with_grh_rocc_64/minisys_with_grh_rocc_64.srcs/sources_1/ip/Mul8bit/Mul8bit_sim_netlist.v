// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (lin64) Build 2708876 Wed Nov  6 21:39:14 MST 2019
// Date        : Sat May 16 20:29:54 2020
// Host        : ubuntu running 64-bit Ubuntu 18.04.4 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/wolf/rocket-chip/rocc-accelerator/vivado_project/minisys_with_grh_rocc_64/minisys_with_grh_rocc_64.srcs/sources_1/ip/Mul8bit/Mul8bit_sim_netlist.v
// Design      : Mul8bit
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tfgg484-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "Mul8bit,mult_gen_v12_0_16,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "mult_gen_v12_0_16,Vivado 2019.2" *) 
(* NotValidForBitStream *)
module Mul8bit
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
  Mul8bit_mult_gen_v12_0_16 U0
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
(* C_VERBOSITY = "0" *) (* C_XDEVICEFAMILY = "artix7" *) (* ORIG_REF_NAME = "mult_gen_v12_0_16" *) 
(* downgradeipidentifiedwarnings = "yes" *) 
module Mul8bit_mult_gen_v12_0_16
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
  Mul8bit_mult_gen_v12_0_16_viv i_mult
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
YRGb0DNKt2142sDYALK6CGgtx2j3G9gAySPWLee6oDavQ5uqaDPxKcLuK/8Wo6h2P0x/8CtxE1G5
HX4x7YjkwR3C5QiHf84comx/x6cA64ZXXxNisEFjFi61C7dJLDrXZOsqwUf8QOuIhbxh26wLp6fW
ddbHnBX+IFORoXunM/ovWNvynGPHMvcqzfbU7aajcTQ/vX8SYAQNDZlGIXe4I2KQtJuxhgM1WtGe
b9VsS9E8SgI5Dozy4x0WWoLDh1yy44uhlnoANKdXBSsnRVrSCRg7odEPqEboMQA1vE8f5S3eXDdr
Jt7F8klthhjs1OFN4lgSAOC47ofUPVCBVS6A/w==

`pragma protect key_keyowner="Synplicity", key_keyname="SYNP15_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
Ordr0bTwvyc55sQb8AgensZ9lHrVTlpjyFMVMUfnVA8FQHwMXlb57s/lj/HndXXftoLbPy1D4Mfb
jfB4dwAJ1Umezalg2igNrH6Q4gnNg1kl5IzWH5PlDLiNx7Ip6rVVHo0MRe756MOMtc1s2ZnXH2hF
7h+l0Yi+4bc233qic8jSJqzThp9cl4xUlQo33/dTly9QEWpP52HcuosgxBP9VnqpdealLM6AqOD6
OhCLtDPVNrDP8DTll78M27AqXvZckLw2ZfZIRIsd5cHMZD2eJHjMi6/XLd9Xs/N4KThybaGjozCN
fG1AM2jhZLKKYMp5hWqbjtgFtbKq4ZoI+j7/fg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 7360)
`pragma protect data_block
A8uKiqVA8qN/o+Od+6ML7YpugqZeek1rXbkbrFBq4h5SHQfQ3XoU5gko6dlXcKzhuQQKiU4ADbdQ
7s7eXoFsuy19OyXTV6diP1FB/4fNl7/35a8soYm3ZdLg3QaCoOy9kpeRoalJBV+aL8GuUEYQjsYA
aqwBMYS/iMGkoD9ieBHApiLREQueO4mp7p6OaKIdxh81N2FXBjMsKp3wrEAj9glUvJ9k18J12VPW
j0fENHP6KQI363WyRXxEa6HjwC+y6gxFOOIW6uyZSvbd3qIwTIlQWvbzAhP8aO+3q+YkDHE/mnqX
XlUHjTdR6dGWT+7YpuBqtrXV/zMTtgY+LYsL4w0en7Vq/T7SXbMvdrsncUFCGSm757r8H9SpuQnB
rf9PSfFgyCoOU6TO8ANW5i/JjyNuNRvxC7cqIbBLZWLWx69FppJVwNJ9Tr7GxQdmzwJgIarnbu7i
wFm+HznmNBfanermzcmOIX3tchfMYgByjMv4c5VHUW1+u9VlxNyEc89Gdw++I055ASstun81t4tV
wXnOZeYFP+TGlIBZ362X0PfgtUw2+l37rjdxMmRaAAoHZwqzbXDjaveSlFKmrcLb/ckOEdyKQ+Zs
/hbhj5jm4L1ZPD/v8sSu3VhxxkaP8Awt6XV9BSYFovlNrFAiq0SOdi1n1mSAnJsQg3+ce7zqqBLH
RmXemBQLPrNigWdOtVw7sr9mky6XRYSOrZItnULW8YGoHukSJXo4aV3nVdiJcr47cINKuCAnSSQs
niWZgcSCBdno8j16LJ4M3BjwHu8TnYiZ5yfSc0fPAx71khiT1Q/So4cuyyMjb3P809Ona+b5RLT8
nrBQJ1ssNVdXUFhMCl8HEZgdFjsHhpZ1/7TuX+xv17ePMTB7tmiKGSFVO9MMrbVfbJpXC1FmR0/c
julN0wQKjfhdZRlqZJTK3iehQqvXwvoNNDCY1VM1y0K+TqBOWEeW5hanc4fBkx/tdCszEdqDxD4r
6CQn8zmvATwZBjk/6WQ0nlEioE8RLM5jkkCbu8wgiZ8AJPBS0n/lRpwn8TTLcQCpIZ6ZcJPTvJKV
zXZEhBfdkIS6+r/wEy/HqYcqLm7d7ZNvtBOpuhsQQ5QPehakTIpmaCnxC1pGSb/ZehjBFZwt5hb5
quhJJPYWZL9dXAtaO9RtmmKZBpbQ9FMnhUdqtfNVCQaT53Lg80trLXCKQwRekz0ab2XwIrW3M0tg
w4KtGFDwqvkJMOSteUuUzLzolzbzQUWMjc/TTdSBTMEIr0S0KALoMXbjdtcpWiVZrkttm1E5Rl9v
NMX0VajpEZ06XrWEPTgQBH0xYPNS9tJaDmTQxJf0M9Or2pmAzt8WbIVgNX8yjBe7pWokSRyq1qx2
wdUk1zJtXSdK4CngInBs1SK/aPR2i7XwvvFnADBLWWT23yVvW0BFnNcpuLaVFjiG1i6luIMv8vuN
1XkFQdsSys90I3M2zvE08iEv4MW7cBESaBUvtP/GoVV8PPupO0f3nvjH7KWS2JzmegMmz+vP8eJP
Mcd08gWX0UqOCvWig2LXfHCRz+ckQyNVKMHHA76R+eKLgPBY6LXuAIYWX9RFpttQ5/yEybjZU+YZ
ZI80mQFc7hzeZbl8rHnyw/FUucraOoDRiT46zfN9nF9NFm/zEwNkdg5h1Xcljr8DY+eY8ogJnQUY
NI7iwtbQGvx321jG89aKUuMntTgr8/9RXs2IMaTioRA9Z150HaGzfJ8SXwETBKTgmi9ilfMN+G5X
LMeq3+zRI/hDMB3rfps8TnnP+H004uYL0enKDaaHLKtUXWqBVnG6KWFTmlgibfAAwSK0LctfPb3p
g3diimohjG1TC+mVJrH8ZJP6pOe0KNcHYIOBtbU85nTR004Vok4zdHXHtp4GTIV4xK6z8+9OCSFj
xNBsWYQrWr4TQFfFWqlTf8E1/7xxNIrtn3B4YLYlJjyRcukJzAY+7DsvHIfSuWPsoI4E8H4d03NZ
9TkT3PKmi+pOwWyjtiefohQJ+5Rv1y5Fpgiu5ZirUMKAKldgeq+Y4Ela6uIMolFDTIrYzt3tKMte
jlY6eT7QCgKu/YPIpkmLsLJBHYhLtdIzJJHAyF+LwTrQeQIjlbDk/oIW1T896WFjL+TZ55ipE6W3
0fO05apgAllKg2VvGwmdakyVnlVKOoAXXhLF0+Mz3dTHihGF5nIGevfiEGd2HUs7ig6lj4pJgcKX
urYisVqzRZXTVwUlJUyCeXaC32IpyJEL/rltjoNnRmGib+pXEnpeUUaSOpJiPe+/VZdVm+PzN80Y
vMLDW0ezLeKCkTfmIvs7DGfYPlDgCfCKJU+es9yFmBXrf/v/XPzj+/ZnPCB564OE1Fqagk0H9LC/
ErvqgWD/awKHvMaT1FLx71gE8gZDlT+kBcuSGphwm3odVzUbAZkrgruSQ2As9G5/1kTMT6czE73k
C1G5VvtSb5DP+kFQ5rfBqSkNsqkbD2+DUTqxWqbuwO1qPmXn5dUsIa7v2APDYdX9vjhGVAu8WwOC
bs+M9DARAXH2NYRYoXWwP9J5AHgVXnsByfoPhuxBauNS5CKxjGfvK7z9VhYPfozLHywPj/Xoqj3T
tGnF2nbZb5IclE8gV+dHHi81d5t3H24KPhqKsaojq+oS0BWHXTvbu6NN/o31cVFyqIYG0CvwGOqY
nuhNQxz/AgX6rPYXjj7LntMhoLKLXQk3iUUQfgLL5lZI4KGvGnEFd91kxUjI7V6uYvZQzdsYVJk5
LLg0p8iOxlaygH1k7b1BcwJjPRj43kM2ZI15LjnBnlsXEIyqWqstIOqEurezarrthJYxI058xPaU
QCw4TE+PY6Am0biXhv3+wlilZbVpwDHy2ZVrk2UnZdYnvSP3Wqzes/ryAmfzUNEl8v66AWfGANWm
pbVDFlIesGBXOO+lsbBREL7rce1lbExZEcrPsANc4hGD1j0ht3AVXp4AcbwILK+lqq66tNHtU4jR
5BT9pitIaIGxM41NYlJkm4qxXnY2sdlZT6KRFIsJcQ4djDwI1QKE59PTXFR/uZ7RNz64yWqxCq9N
uJErkUuA1WKvhyT/yarn6sewENSifeAE3aa4TS2e5si2PWbimYEF+muKAUyLp3Yn8w4gIRZMYD1h
sIIw74q2FtIjex/sloo81TQr/8eGD7Qoda3la252hZr2yw8zUlNG4s4m69I1OpwWlePmbvhF4bZO
ia8fpzZ8LUJXjkPQT5GW1MYdQMiRIAET68bvAll91891lZpF8VGq5EQ9IPjKa4CdWADzgcLZqso0
GuDLjNcVIBlaEJWtx75MDWCckVZz5BWir4QWv9PhRORZsANvh5sKqJ5KvrpbMuy03on+Ra7NcBa9
F/M1Pmw+DPQhej8xdcqkSHK+fujHjZlAnfN5aFBqhj/mIg3A8/QPA7uwMq1x8fDf6pPqvXfUgvRf
+ltiXnrI1V5TEGYniI/AVdkZUB0jLzNgH0Mrd76dW4gSej1QQ9AEbSemGi4B6lBhxUnFLJIb1z27
kKJ+zI1MHIRdf2DmKamERYtUxBpLMHvaJu0qOOynsJbtFufsAzd99VdM0/rWo4NDLlUrW62T9j3P
8e1OfLOZy9Fi5YMSVd0RBs7uzzffxZxoiW2PSBSdjbfjF2pmajL3WKRBTnD8lEL3hXsHWP35S7AR
+nXnpEZTyIFLbu+dbCAUhIYOjDEtGCIO122Pj57lrnkNBhftmAC0FaNtoTMSdc1QzaX9WhvQfZuG
dECmYmgE5wmmJjDZXW9L4bPL/eP7nzJ6bSas0AXJuGbZy4w/U9iAF2bdSgImhBeqcUyOFIlXO44P
gNV3EttiROHQ9LjlQdh0WpZIb8CblEAJbWmGn5M3vPiIUxy6aUv+rLjFACjILHKznai1zmF2d+LY
KxFy6zDI1u9dVSzgUavuKBXN1aFPDyIkCkDUhceBCf6C3LE7zHA97Hwwo0g2SJx1+ZujGE25MCv+
9ernWxFtkhMVHIOIzXnCTJ6Bzrt3zEqV3MAiJ66h1diIlYCcTQyMLTeYlXgDWJE1izvY7gdjAlWQ
qtCH5GM6G2T18bBCMk5yYESpE2W/DyxbfeogD+ocHLMO1u5pv5o5zRuHatm0wk9phpHK4PFJB1WF
ClabDZp+fA5uvBQjhnSctpwH1s0oHnZkfQvOKZFLXxwqYMM4O3Ukgm6T+6aheQpFJ/n9CIErD+M4
UBcx2HhinbBBHp3IEybLVvNCHTeoB1Z4WYXJglHXklrtRZkTlJviTROS1jgcqblNcUASjuM2T/TH
6rzLy8cGsWtfyJeqnn3i58CNVxUg4H1zQ5VXbf/Ivdd0mjA4umWa5l+1ppynABIWO8oqFMWScgJw
tWcQ8rbkGj/ZNkoQT7GJlwfVGSdg4yivmkF+Xo6U1ds2cxVvDGaaB4N+LNaW31OAr3VxAMwDzNVU
O4SC0RLbohAEOdM2n0eCtXVhE/ueGhzSrQtLFBjw0yBwTuzewMjrJxTJ/MmxnE4cBu/NZF5WSliW
Goql14njfAvtC+E9/aEkheoYSOSwMqg0PNW4VwpWbRkfV1x93xUu5aKbl0vpOa9EtYWSJaITlgH3
XohDPMMTUf9peWN3XKoGAICiFpiORgAp4Ei2buWJQNqTueYDVENwZhY0uzycZ32fvVNnvEVQACsr
hYCru3cnnGDfIRZhwaegJb8jGNfe0Bb2KfHkw9pTFYcpLiYvsTYOyel8WDTsy6V0og/+gsuQILcR
R558vtEDRv5Xg8LDvOyxFFHgsRGSQcpbC0R4LlHgWNmbeXul+n5eQfE/qi/3e2wV6DY7CXYHp8kK
B5qeXt2xJxiAHxrDGUYF67O1ZqZV7W19MORiLCuiwelwEbWhiHIAIwdlbtCp8yRWrDyFzJt5a9ZP
J8hv4X5zzOTdMYwq9t5oGn9MGUxjugFb0x7egDU2NvC9kfrOmxyGBV25zlVbMAjfxCyvpr8x82+d
vOnbyjh7X2eCCl9TrfARnDjPsoSNsXsJY/rGrES74qj0A5OYn/XIWTgU7H9A+M4BW0H/tOUB3FEO
24Ta0i1C+Ac9VDsDAQfY/KvCbtcs8aT01SEb2X1KoXFHTyFwBIPdUShwij6eAP/4GhoQylGugVrj
IcI9qeJc8JoCb8hzGumRzY1VsyPV29yFtzOqeGdUmKIuody2PvRDIgrniuZM+bZosX0Lt6Y5G8yp
HbY19mOfcuKIrSNNI/oTh/Tc8MWJP3UgnXuviRZPE7/c1bCVhmV8bh8N6FvFDjDDby/jknv09ZMu
ZOm4FbuPmD+L8DtEkzjUrraydZ210D4JoGqthWHSq1kaWlg1Fh0t+naCNefb4zpsbF03y2+YewSy
hI5qSQOfEtGlknvXYJrtlNMcd2Vyk+G8zWewq83FB/hS01+TFaY2tVMLk3n59aFb0E6uLo4P9hgY
2yF5cTUcD1A187sSZY93FpgMrt4Ygd7nupEhYA1k6gBJNCK+9Xe4S+KtCDkHSuDu6r30B6h30lnk
d8Uu1iD/RxpIIXhl0+NPbZFw8Io61VlMxW+kukUnYJE4ryJL67SmhIYk1AYcb2HMflF9PQFXtcdn
oUFPiJUK9NN2ORTX7ZtG8RsUCwqn3WIbBGkDk6YTcELaSN7gFy8Xjj7NvKmeThZ+T4vAGyC3yKfs
okSfIxKsWwzDQ3HwbqNnFJWom+17hlowTY70D/XE/h9MGwoJRFrL/HX3RFyexA3FU183aoHUKKdN
SfHPK/unhKRSZE7UXD7jASNy9EPjr4KnDbLBFz/aaGm3shWqh0X4xaNtLWqF+fnU0+WuBxtRc4Gm
185Kn+D2pT6rZDaiwKUONTa5sr1icdL2XsW/gITODGBxqM8059HoTVu7c5+vAQOuD4X/WMqRCg73
j9WcQuyHaqtcu5LN/tHfNdYH5MM6ZVAUQSlYpekG41CFiqyGY4+Ku5E8mL3KR3LYJPeM1cf081sG
aIrdQIyXvI3LH1oHM1xbg6Dq83XV5RDFYrVJf8IDeBB+pK7MO2uscQhW+ChryBylNd+NqtfmOhfL
VWau5m11P/6xNzZrv1XqCuSM62rD92PpvjuNLT1jAuchL64sSzeExGhez18q0b+GyIgTJh0D+KIH
uWuJKAYi5FneWfmVsr5EnkvEdMKcPja3zk4Oda11vegx+RRsdy9MJE3yMLME9drLI70n5a7kzHSq
ZDh0Wf+Ibr8hBHlVimGqwqXjJ6w9qyXsz3M3SJ2ecDdgePdvn+MKuSlQfBP65lUdTVGDUBHd+TX3
x6N/M5B39OtW9vubM4QzaDkxkACvxNHEJoGiA0ZPOwd4U7fGlqJp/BPkz2HMU2iTNIGTm9mnN81d
7EDpMq9VxzCspeOpBC4ZoDNjIZ1YmQ9071R7wsyaGyu4OwkKzICE+K4iidouGAYb+3KOXzKREgbx
KMi+u7dEuGKqdLgpA+JX11QakOgiC0f8ftkff6kjaiESnsyR8mP/l8jVkyinRb2ao2Y0yeepk9Rv
sBEoBqHhI8JrZDlQD+pBTQICkZZNGGhs0CKCeqKvWY/FeS8USCFmdielASNedN7xMmROoJrAxtPX
I5dZiI30nBdZfN5Uk0rld2IkZdmiluJqgYCT0m90tXd2mnwzLkmVbWJ+tPI3rTFqT99Z7nn3G1s0
ds5jsVpz0XnlpLnhok7ofYs6kte6GcfsFG2XCuW15IvsgqP2ICLuaxWsObLtMR6AqzRul10MhYeW
KFxCPSigAE1DcolFJrt4dYw8h2WK91ddkTXdRvknCDtea/ddUiXQ0Q+dED5ynbKXddkMFz0+Yif1
0GRBnqy0aS8FJfhNc9G1MMNp/51Va70FAaHBMR8fLV/xY+2X1G3kXMMzxsisnxcwgdDW3opDN2bk
xX+psK1V44N0r4DwU0QKibYk7Tr9H79H59Wvd4DW7PK3gNcQ+eXX3XRcUaDiT4RNI/oJdKvG13KJ
wyeKuQx+wALif2V/rnjPlvdDwUM5RU/UPr/CfcAqV9cqVmCI0InvTxlrbLENoCsuP9OdtojKlek1
QuanGHiK5VV2G9fn+yRrPcbD+bAzq9rkThC2QVP0lhTQnphs1uPflfnmScRywtaJ4lsE3UwVUVXn
boPxza5/TFMU8cPAh5nHvGK6rk9wVnKMm1Qf+AvWCVch6TncOwiL+NKet3Yd3Wfrn1SEXn6Sq561
cMgRDkWiJtk3HQVMMdbGO2YHKY6xDedbzA7b1DYcrjnJAl8cS+BvYuzvJDeUcpHfUITo2xt4cTFe
EJeGNlcYkXxKk0LIbR4pW51PReX0HhOC9LFwtoA69ENJrFUrtPA4a9uKPkg3tSegvTz5CzRRX0Nk
koevKg1E17sXXWVlRoVAVBHXewreG48SOqJqnUm8XFjqMTm1knilGCxnyBxUEKUBiSMovxxLRUJG
W0xIjlPgjYOrx0kM6C+gf9DFRLFO1ytQkNlWjdxdms625ojBp7+sDKPUjroEXAxwksuupuPu0eKq
JJWeom8EY1320z1ZNUV/uCO01LMgcnUcLLgr94u6BQmJEM0IeXAjUJbSPqAXnWKukEcL3Ai9BgaL
lj+m//ge3v6P+PbILAlrcOd/y5GFpdWloBKOtnlcCc6t2I8IAK6i/Oo/jLkdnmM7t7Z8phtw7JwZ
2QY3ld0Ixg32uSBrgrGx5fdO3beh9c0SPy83aJeTohf/MSHtcScbExPwqnBpnmKo9Qvnobf+2m5v
f12FsVtBdz80KBuLJ8OMWDz1vnQH2KKPQlry6NlG/Lhl6UMf+1+svX3Qb7Js0FU3UtJ18C4i1R4J
XSVX/oQUhdNpYFvJkZAFTqOgpfWR57rInIfiXYnpMgr9gsXgeq3vWmmiQgaw5gGHSvJ/UQ3KMVKT
ks+TW/S0+MYwipwM7R909GPaxCdiTIMYn6LUOmTlD+i7Ljof9L+gxIWf4ky8UpzRvJUZrTfIPnoL
/CUK4Yufyw752sNmZqmWQsJpoUuSTz/iT+cR//260cO3qQHb6lrmEH5etf3+hbfvXS8IhUHN9I2P
4qcNHM22gQjuqMygBcbpZOVYCzEadiiUkoEm3eEiRo9orLn99l5lyUKRXn6pPap8tKHYALg/3qUJ
Rnlr8NlV1XftJgNLVYAuuCk3J7ALmIEMNHaKK+hlfFTzBQw/G+smZTjUABCeaGgxQLj8fCd8atuA
DUVjMNh4exQztDeWbNrZfPvoAiSL9mmZ46jFUKux6pGsJCZMjnbHVzAvMcIZNS0RfvmgSAOBi7jI
Fn6/C04nETbnWx3yFe6LLUw5zsnsQ/gI7sREIDOzsyWTR9qY5BJoyy1N2YE6NC8X323GpHQUhCts
Ep1cAgvBDHwJG6UtGEZarFFYMPWBAiu4ZjMlN5mRp4O0Se9e4Z1SE+3d24GoVvaV11V4gb1WjU4T
Mt/DMilvyTCmluOBQnNsqORXAgOKiQDymVtd8TfSHRLms4WQws0RRc/07cr5gRAKzpBm61QULjy0
ms2qQSE/SBQN2sE8LLWx51EcqenbjbSb8zr5jC23C7ciD4Ng2V4MVfjBVl41NGeLQW+9LmeUaLGg
BUCTfOw7UAkPcoD+x4cCBuuUmv/9+a/DQn2HpV5XOf95aSIPND2hUBg3/Tl5ix1N1juTEWW7HY92
M0igS56VpXAZsljeIsFEho1g04FUPAWrgz6AzqXe1kcruwfKbjjp0Q7QnHDOh5VGdexdtSjJ9Czt
MYOlDEPDA40y7Bd7ezsLBpmo2TxwTi1q++X2ylQ4oBE5Apwltc7ikBvbgOlM8c8DpgoKQyy9iIA2
jlOWZ1VkqFj+0GHazQZzeNH1aDAbMd8Kcqlk5VhryG9qu4gEdctZpsiwhSY9phDlKVJJ9ZyOHmNq
eh8bixoMggdLSLy0S+Cmvc2+yFPlH4p5iW2Xgu7Yr+ZqCp6XrvrqUxS7BYMr6FgyJ2o74k+4Ip10
WvI4uisDq6E77rIUIXAAayjrfv5kXV7ZZZR/n6pRBnMDe/mX9JMGLxPvGtr5Yiuc6baVNKvEhhQ8
pErEYYmPlUe43IOKKO+w887nCV1SbcUA8cqd9UJHs8oDeQAjwf0F1Bw+oezjdQqNHJYEnnfyWdTf
2+LaqiNrjC3xQGAxdgsH0W/YjksZesDMOct65kvFpomcQiqPFU89bqCTKdYzyeLLXzFv7iYP+6Bn
Fbc/CRDtfvhubXBKmqtAzPE3XwyixYUNkCAJTkYwYhIW07aN8DvSi1NZT1yBbuxx4dHHGqzHtOP+
0XfyjNxCfmaOE+LCO709lGFzyec9sgTsG3DgsyMVcjpsOD3TEAYns2vAeDCF3b2e5oD//WCHM+ER
UgIzazyMvUDOGjs30UV/O6i63eBpNIUxFx0i3w9IVNgmo6h85p7KmiftnPFzhqY+SIS2jlBU1zvK
/W0EOe00K9Y1RGpUEYpYRzeJQytBId2ljYUi/4mYf3Tex7PFD/FiqACpVAfAOGWRxWrsFAaTitEz
vCPazDv5FweQv7krq3GLOSDWKHNOKOxOljAoil1+AWb8b9WV+0KT0wRjJUZYXkYXf1cVbvyaV8H6
xTubY/ZFSBCO1ESc2omi2JhoOSNPx9wWO4Kypzx4apNYJlKhgrcK8SY4ccZlObCERJCIVH41wsHK
HiJkwCrKCphsKPnN6Vl2oTV6RbE6Uz9CRY6X9J4QSM63i4vbRya/ui8q4kbo5hxp7lsZoQUybjFi
LZN6nT6tKgoV2U6P627I2+9t1Hhmm5jRJySBTTXd7NnR2bqnzJptXv4hAfLKPZPqbygNR1sy/VYw
PfkEBW65V31HJcfb5ITTHfq8gXNR70njVXUgZVM6tue487V49hKd1t1CHBPliSzD1m3eEkRB+GHb
YPBbyWA88w==
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
