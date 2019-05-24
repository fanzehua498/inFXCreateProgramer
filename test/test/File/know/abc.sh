#!/bin/bash
echo "hello world"
my_name="fanzehua"
str="hello \"$my_name\"!\n"
echo "字符串长度： ${#str}"
#echo $str
echo -e $str
#提取子字符串
echo ${str:1:100}

#查找子字符串
echo `expr index "$my_name" zu`  # 输出 4 以上脚本中 ` 是反引号，而不是单引号 '

#shell数组
#bash 支持一维数组(不支持多维数组)，并且没有限定数组的大小


