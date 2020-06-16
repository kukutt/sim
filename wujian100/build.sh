#!/bin/bash
#git clone https://github.com/T-head-Semi/wujian100_open.git src
#wujian100版本:c3e5722cb49562cf2b8af6a198ad364cbd964d2c
#./run_case -sim_tool iverilog ../case/timer/timer_test.c

rm -rf *.o *.pat *.elf *.obj *.hex

# 环境配置
homePath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKDIR="$homePath/src"
S_SRC="$WORKDIR/lib/crt0.s "
C_SRC="$WORKDIR/lib/newlib_wrap/__isnan.c "
C_SRC+="$WORKDIR/lib/newlib_wrap/vprintf.c "
C_SRC+="$WORKDIR/lib/newlib_wrap/sprintf.c "
C_SRC+="$WORKDIR/lib/newlib_wrap/snprintf.c "
C_SRC+="$WORKDIR/lib/newlib_wrap/fprintf.c "
C_SRC+="$WORKDIR/lib/newlib_wrap/__lltostr.c "
C_SRC+="$WORKDIR/lib/newlib_wrap/putc.c "
C_SRC+="$WORKDIR/lib/newlib_wrap/getchar.c "
C_SRC+="$WORKDIR/lib/newlib_wrap/getc.c "
C_SRC+="$WORKDIR/lib/newlib_wrap/printf.c "
C_SRC+="$WORKDIR/lib/newlib_wrap/vsprintf.c "
C_SRC+="$WORKDIR/lib/newlib_wrap/__v_printf.c "
C_SRC+="$WORKDIR/lib/newlib_wrap/vsnprintf.c "
C_SRC+="$WORKDIR/lib/newlib_wrap/__dtostr.c "
C_SRC+="$WORKDIR/lib/newlib_wrap/vfprintf.c "
C_SRC+="$WORKDIR/lib/newlib_wrap/puts.c "
C_SRC+="$WORKDIR/lib/clib/fputc.c "
C_SRC+="$WORKDIR/lib/newlib_wrap/__isinf.c "
C_SRC+="$WORKDIR/lib/newlib_wrap/putchar.c "
C_SRC+="$WORKDIR/lib/newlib_wrap/__ltostr.c "
C_SRC+="$WORKDIR/case/timer/timer_test.c "

# 编译&打包
build1="riscv64-unknown-elf-gcc -c -march=rv32emcxcki -mabi=ilp32e -De902 -Wa,--defsym=e902=1 -O3 -funroll-all-loops -fgcse-sm -finline-limit=500 -fno-schedule-insns -ffunction-sections -fdata-sections -o crt0.o $S_SRC"
build2="riscv64-unknown-elf-gcc -T$WORKDIR/lib/linker.lcf -nostartfiles -march=rv32emcxcki -mabi=ilp32e -De902 -O3 -funroll-all-loops -fgcse-sm -finline-limit=500 -fno-schedule-insns -ffunction-sections -fdata-sections -lc -lgcc -I $WORKDIR/lib/clib/  crt0.o $C_SRC -o timer_test.elf -lm"
pack1="riscv64-unknown-elf-objcopy -O srec timer_test.elf timer_test.hex"
pack2="$homePath/Srec2vmem.py -i timer_test.hex -o test.pat"

echo "[build1]" $build1 && $build1
echo "[build2]" $build2 && $build2
echo "[pack2]" $pack1 && $pack1
echo "[pack2]" $pack2 && $pack2
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
