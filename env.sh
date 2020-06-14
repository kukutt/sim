#!/bin/bash
# 获取工作路径
homePath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo work dir [$homePath]

# 检查系统工具是否安装
function isExist(){
    if ! type $1 >/dev/null 2>&1; then
        echo "$1 未安装,尝试以下命令";
        echo "sudo apt-get update";
        echo "sudo apt-get install -y build-essential gperf bison";
        exit 1;
    fi

}

isExist g++;
isExist gcc;
isExist make;
isExist gperf;
isExist bison;


# 准备工具
[ ! -f "$homePath/run/bin/iverilog" ] && {
    echo build iverilog
    cd $homePath/iverilog
    bash autoconf.sh
    ./configure --prefix=$homePath/run/
    make
    make install
    cd $homePath
}


[ ! -f "$homePath/run/toolchain/bin/riscv64-unknown-elf-gcc" ] && {
    echo gen toolchain for riscv
    # 打包命令：split -b 10m riscv64-elf-x86_64-20190731.tar.gz toolchain/riscv64-elf-x86_64-20190731.tar.gz_
    mkdir $homePath/run/toolchain/
    cat $homePath/wujian100/toolchain/riscv64-elf-x86_64-20190731.tar.gz_* | tar zxv -C $homePath/run/toolchain/
}

# 准备环境
export PATH=$homePath/run/bin:$PATH
export LD_LIBRARY_PATH=$homePath/run/lib:$LD_LIBRARY_PATH
export TOOL_PATH=$homePath/run/toolchain/
echo "env set ok"
