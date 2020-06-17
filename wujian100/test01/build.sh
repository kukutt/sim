#!/bin/bash
#git clone https://github.com/T-head-Semi/wujian100_open.git src
#wujian100版本:c3e5722cb49562cf2b8af6a198ad364cbd964d2c
#./run_case -sim_tool iverilog ../case/timer/timer_test.c

rm -rf *.o *.pat *.elf *.obj *.hex

# 环境配置
homePath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKDIR="$homePath/../src"
S_SRC="$WORKDIR/../test01/crt0.s "

# 编译&打包
build1="riscv64-unknown-elf-gcc -c -march=rv32emcxcki -mabi=ilp32e -o crt0.o $S_SRC"
build2="riscv64-unknown-elf-gcc -T$WORKDIR/lib/linker.lcf -nostartfiles -march=rv32emcxcki -mabi=ilp32e crt0.o -o timer_test.elf"
pack1="riscv64-unknown-elf-objcopy -O srec timer_test.elf timer_test.hex"
pack2="riscv64-unknown-elf-objdump -S -d timer_test.elf"
pack3="$homePath/../Srec2vmem.py -i timer_test.hex -o test.pat"

echo "[build1]" $build1 && $build1
echo "[build2]" $build2 && $build2
echo "[pack1]" $pack1 && $pack1
echo "[pack2]" $pack2 " > dump.txt" && $pack2 > dump.txt
echo "[pack3]" $pack3 && $pack3
rm -rf *.o *.elf *.obj *.hex

# 仿真
V_SRC="$WORKDIR/tb/busmnt.v "
V_SRC+="$WORKDIR/tb/tb.v "
V_SRC+="$WORKDIR/tb/virtual_counter.v "

## soc/wujian100_open_syn_for_iverilog.filelist
### include
V_SRC+="-I $WORKDIR/soc/params/ "
### file 
V_SRC+="$WORKDIR/soc/ahb_matrix_top.v "
V_SRC+="$WORKDIR/soc/wujian100_open_top.v "
V_SRC+="$WORKDIR/soc/smu_top.v "
V_SRC+="$WORKDIR/soc/sms.v "
V_SRC+="$WORKDIR/soc/ls_sub_top.v "
V_SRC+="$WORKDIR/soc/retu_top.v "
V_SRC+="$WORKDIR/soc/tim5.v "
V_SRC+="$WORKDIR/soc/tim.v "
V_SRC+="$WORKDIR/soc/dmac.v "
V_SRC+="$WORKDIR/soc/pdu_top.v "
V_SRC+="$WORKDIR/soc/tim2.v "
V_SRC+="$WORKDIR/soc/usi1.v "
V_SRC+="$WORKDIR/soc/aou_top.v "
V_SRC+="$WORKDIR/soc/matrix.v "
V_SRC+="$WORKDIR/soc/dummy.v "
V_SRC+="$WORKDIR/soc/pwm.v "
V_SRC+="$WORKDIR/soc/usi0.v "
V_SRC+="$WORKDIR/soc/apb0_sub_top.v "
V_SRC+="$WORKDIR/soc/common.v "
V_SRC+="$WORKDIR/soc/wdt.v "
V_SRC+="$WORKDIR/soc/tim1.v "
V_SRC+="$WORKDIR/soc/rtc.v "
V_SRC+="$WORKDIR/soc/E902_20191018.v "
V_SRC+="$WORKDIR/soc/tim7.v "
V_SRC+="$WORKDIR/soc/apb0.v "
V_SRC+="$WORKDIR/soc/apb1_sub_top.v "
V_SRC+="$WORKDIR/soc/gpio0.v "
V_SRC+="$WORKDIR/soc/tim4.v "
V_SRC+="$WORKDIR/soc/tim3.v "
V_SRC+="$WORKDIR/soc/clkgen.v "
V_SRC+="$WORKDIR/soc/core_top.v "
V_SRC+="$WORKDIR/soc/tim6.v "
V_SRC+="$WORKDIR/soc/apb1.v "

## soc/wujian100_open_lib_for_iverilog.filelist
V_SRC+="$WORKDIR/soc/sim_lib/PAD_DIG_IO.v "
V_SRC+="$WORKDIR/soc/sim_lib/PAD_OSC_IO.v "
V_SRC+="$WORKDIR/soc/sim_lib/STD_CELL.v "
V_SRC+="$WORKDIR/soc/sim_lib/fpga_byte_spram.v "
V_SRC+="$WORKDIR/soc/sim_lib/fpga_spram.v "

sim1="iverilog -o test.vvp -Diverilog=1 -g2012 $V_SRC"
#sim1="iverilog -o test.vvp -Diverilog=1 -g2012 $WORKDIR/tb/busmnt.v  $WORKDIR/tb/tb.v $WORKDIR/tb/virtual_counter.v -f $WORKDIR/soc/wujian100_open_syn_for_iverilog.filelist -f $WORKDIR/soc/wujian100_open_lib_for_iverilog.filelist"
sim2="vvp test.vvp"
echo "[sim1]" $sim1 && $sim1
echo "[sim2]" $sim2 && $sim2
