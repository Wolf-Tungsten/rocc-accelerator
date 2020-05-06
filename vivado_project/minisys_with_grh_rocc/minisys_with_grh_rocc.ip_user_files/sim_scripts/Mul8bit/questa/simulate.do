onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib Mul8bit_opt

do {wave.do}

view wave
view structure
view signals

do {Mul8bit.udo}

run -all

quit -force
