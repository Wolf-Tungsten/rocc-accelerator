#!/bin/bash
BASEPATH=$(dirname $(readlink -f "$0"))
sudo $BASEPATH/bin/openocd -f $BASEPATH/riscv.cfg
