#!/bin/bash
# 获取工作路径
homePath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
workPath=$PWD
echo work dir [$homePath]
ret=ok
# 检查系统工具是否安装
function isExist(){
    if ! type $1 >/dev/null 2>&1; then
        echo "$1 未安装,尝试以下命令";
        echo "sudo apt-get update";
        echo "sudo apt-get install -y build-essential gperf bison flex";
        ret=error;
    fi

}

[ "ok" == $ret ] && isExist g++;
[ "ok" == $ret ] && isExist gcc;
[ "ok" == $ret ] && isExist make;
[ "ok" == $ret ] && isExist gperf;
[ "ok" == $ret ] && isExist bison;
[ "ok" == $ret ] && isExist flex;

# 准备工具
[ "ok" == $ret ] && [ ! -f "$homePath/run/bin/iverilog" ] && {
    echo build iverilog
    cd $homePath/iverilog
    bash autoconf.sh
    ./configure --prefix=$homePath/run/
    make
    make install
    cd $homePath
}


[ "ok" == $ret ] && [ ! -f "$homePath/run/toolchain/bin/riscv64-unknown-elf-gcc" ] && {
    echo gen toolchain for riscv
    # 打包命令：split -b 10m riscv64-elf-x86_64-20190731.tar.gz toolchain/riscv64-elf-x86_64-20190731.tar.gz_
    mkdir $homePath/run/toolchain/
    cat $homePath/wujian100/toolchain/riscv64-elf-x86_64-20190731.tar.gz_* | tar zxv -C $homePath/run/toolchain/
}

# 准备环境
[ "ok" == $ret ] && {
    export PATH=$homePath/run/bin:$homePath/run/toolchain/bin/:$PATH
    export LD_LIBRARY_PATH=$homePath/run/lib:$LD_LIBRARY_PATH
    export TOOL_PATH=$homePath/run/toolchain/
    cd $workPath
    echo "env set ok"
}
