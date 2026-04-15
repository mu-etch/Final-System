vlib work
vlog *.*v
vsim -voptargs=+acc work.SYS_tb
do wave.do
run -all