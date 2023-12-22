#!/bin/bash

echo "开始执行程序，当前时间为$(date)" # $(data)用于显示当前时间

echo "运行的程序名为$0，该程序获得$#参数，其PID为$$"

for file in "$@"; do # #@会接受所有参数，这里我们运行程序时传递参数为文件路径，该for语句意义为遍历所有文件
	grep foobar "$file" > /dev/null 2> /dev/null # 将找到的数据和错误数据都发送给黑洞文件
	# shellcheck disable=SC2181
	if [[ "$?" -ne 0 ]]; then
		echo "文件名为\"$file\"的文件中没有找到任何\"foobar\"，添加入该文件中"
		echo " # foobar" >> "$file"
	fi # 结束if语句
done # 结束for语句
