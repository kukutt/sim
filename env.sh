#!/bin/bash
# 获取工作路径
homePath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo work dir [$homePath]

# 检查系统工具是否安装
function isExist(){
    if ! type $1 >/dev/null 2>&1; then
        echo "$1 未安装";
        exit 1;
    fi

}

isExist gperf;
isExist bison;


# 准备工具
[ ! -f "$homePath/run/bin/iverilog" ] && {
    echo build iverilog
    cd iverilog
    bash autoconf.sh
    ./configure --prefix=$homePath/run/
    make
    make install
    cd ..
}

# 准备环境
export PATH=$homePath/run/bin:$PATH
export LD_LIBRARY_PATH=$homePath/run/lib:$LD_LIBRARY_PATH
export TOOL_PATH=$homePath/run/toolchain/
echo "env set ok"
