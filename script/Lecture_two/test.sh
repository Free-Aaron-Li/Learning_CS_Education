#!/bin/bash

# 定义变量
counter=0
OUTPUT_FILE="output.log"
ERROR_FILE="error.log"
command_to_run="./target.sh"

##!/bin/bash

# 定义变量
counter=0
OUTPUT_FILE="output.log"
ERROR_FILE="error.log"
command_to_run="./target.sh"

# 设置权限
chmod +744 $command_to_run

# 运行脚本并捕获输出
while true; do
  counter=$((counter + 1))
  if [[ $counter -eq 1 ]]; then
    $command_to_run >"$OUTPUT_FILE" 2>>"$ERROR_FILE"
  else
    $command_to_run >>"$OUTPUT_FILE" 2>>"$ERROR_FILE"
  fi
  # shellcheck disable=SC2181
  if [ $? -ne 0 ]; then # 检查命令是否失败
    echo "Command failed at iteration is: $counter" | tee -a "$ERROR_FILE"
    break
  fi
done

# 输出所有内容
echo "--------------------------"
echo "All output:"
cat "$OUTPUT_FILE"
echo "--------------------------"
echo "All errors:"
cat "$ERROR_FILE"
echo "--------------------------"
echo "Total iterations : $counter"
