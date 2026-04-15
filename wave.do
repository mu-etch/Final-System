onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {testbench signals} -color Violet /SYS_tb/RST_N_tb
add wave -noupdate -expand -group {testbench signals} -color Cyan /SYS_tb/UART_CLK_tb
add wave -noupdate -expand -group {testbench signals} -color {Pale Green} /SYS_tb/REF_CLK_tb
add wave -noupdate -expand -group {testbench signals} /SYS_tb/UART_RX_IN_tb
add wave -noupdate -expand -group {testbench signals} /SYS_tb/UART_TX_O_tb
add wave -noupdate -expand -group {testbench signals} /SYS_tb/par_err_tb
add wave -noupdate -expand -group {testbench signals} /SYS_tb/stop_err_tb
add wave -noupdate -expand -group {testbench signals} /SYS_tb/captured_bits
add wave -noupdate -expand -group {testbench signals} /SYS_tb/ALU_frame_1
add wave -noupdate -expand -group {testbench signals} /SYS_tb/ALU_frame_2
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/ALU_OUT
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/OUT_Valid
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/RX_P_DATA
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/RX_D_VLD
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/RdData
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/RdData_Valid
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/FIFO_FULL
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/ALU_EN
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/ALU_FUN
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/CLK_EN
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/Address
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/WrEn
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/RdEn
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/WrData
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/TX_P_DATA
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/TX_D_VLD
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/clk_div_en
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/current_state
add wave -noupdate -expand -group {sys_ctrl signals} /SYS_tb/DUT/U_SYS_CTRL/next_state
add wave -noupdate -expand -group {reg_file signals} /SYS_tb/DUT/U_RegFile/REG0
add wave -noupdate -expand -group {reg_file signals} /SYS_tb/DUT/U_RegFile/REG1
add wave -noupdate -expand -group {reg_file signals} /SYS_tb/DUT/U_RegFile/REG2
add wave -noupdate -expand -group {reg_file signals} /SYS_tb/DUT/U_RegFile/REG3
add wave -noupdate -expand -group SYNC_RST_1 /SYS_tb/DUT/U0_RST_SYNC/SYNC_RST
add wave -noupdate -expand -group SYNC_RST_2 /SYS_tb/DUT/U1_RST_SYNC/SYNC_RST
add wave -noupdate -expand -group FIFO /SYS_tb/DUT/U_UART_FIFO/W_CLK
add wave -noupdate -expand -group FIFO /SYS_tb/DUT/U_UART_FIFO/W_RST
add wave -noupdate -expand -group FIFO /SYS_tb/DUT/U_UART_FIFO/W_INC
add wave -noupdate -expand -group FIFO /SYS_tb/DUT/U_UART_FIFO/R_CLK
add wave -noupdate -expand -group FIFO /SYS_tb/DUT/U_UART_FIFO/R_RST
add wave -noupdate -expand -group FIFO /SYS_tb/DUT/U_UART_FIFO/R_INC
add wave -noupdate -expand -group FIFO /SYS_tb/DUT/U_UART_FIFO/WR_DATA
add wave -noupdate -expand -group FIFO /SYS_tb/DUT/U_UART_FIFO/FULL
add wave -noupdate -expand -group FIFO /SYS_tb/DUT/U_UART_FIFO/EMPTY
add wave -noupdate -expand -group Busy_Pulse /SYS_tb/DUT/U_PULSE_GEN/PULSE_SIG
add wave -noupdate -expand -group UART /SYS_tb/DUT/U_UART/TX_IN_P
add wave -noupdate -expand -group UART /SYS_tb/DUT/U_UART/TX_IN_V
add wave -noupdate -expand -group UART /SYS_tb/DUT/U_UART/PAR_TYP
add wave -noupdate -expand -group UART /SYS_tb/DUT/U_UART/PAR_EN
add wave -noupdate -expand -group UART -color Cyan /SYS_tb/DUT/U_UART/TX_CLK
add wave -noupdate -expand -group UART -color Violet /SYS_tb/DUT/U_UART/RX_CLK
add wave -noupdate -expand -group UART /SYS_tb/DUT/U_UART/RST
add wave -noupdate -expand -group UART /SYS_tb/DUT/U_UART/RX_IN_S
add wave -noupdate -expand -group UART /SYS_tb/DUT/U_UART/prescale
add wave -noupdate -expand -group UART /SYS_tb/DUT/U_UART/TX_OUT_V
add wave -noupdate -expand -group UART /SYS_tb/DUT/U_UART/TX_OUT_S
add wave -noupdate -expand -group UART /SYS_tb/DUT/U_UART/RX_OUT_P
add wave -noupdate -expand -group UART /SYS_tb/DUT/U_UART/RX_OUT_V
add wave -noupdate -expand -group ALU /SYS_tb/DUT/U_ALU/A
add wave -noupdate -expand -group ALU /SYS_tb/DUT/U_ALU/B
add wave -noupdate -expand -group ALU /SYS_tb/DUT/U_ALU/CLK
add wave -noupdate -expand -group ALU /SYS_tb/DUT/U_ALU/RST
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {99679 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {2019662970 ps} {2020059770 ps}
