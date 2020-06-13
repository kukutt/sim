#!/bin/bash
homePath="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo $homePath  

export PATH=$homePath/run/bin:$PATH
export LD_LIBRARY_PATH=$homePath/run/lib:$LD_LIBRARY_PATH
export TOOL_PATH=$homePath/run/toolchain/
