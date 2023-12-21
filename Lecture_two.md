# 第2讲 shell工具和脚本

在上一讲的基础上，更加详细地介绍shell的变量语法、流程控制和函数等内容。

## 课堂笔记

### 变量赋值

在bash下，对变量赋值可以这样：

```bash
$ foo=bar # is you enter 'foo = bar', you get a error information
$ echo $foo
bar
```

在fish shell下，则需要将`foo=bar`命令修改为`set foo bar`。特别需要注意的是，bash下赋值命令不允许有空格。

对于字符串来说，如果需要对变量进行命令替换，则需要使用双引号，如果使用单引号是是不会替换引用变量值的。

```bash
$ foo=hello
$ echo "$foo world!"
hello world
$ echo '$foo world'
$foo world
```

mcd.sh文件示例：

```bash
mcd(){
    mkdir -p "$1"
    cd "$1"
}
```

运行结果：

```bash
$ source mcd.sh 
$ ls
mcd.sh  
$ mcd test
$ cd ..
$ ls
mcd.sh  test
```

在编写mcd.sh文件的过程中，我们使用到了`$1`关键词，在bash脚本中，

- `$0`表示脚本的名称，
- `$2~9`是bash脚本接收到的第二到第九个参数
- `$?`可以获取上一个命令的错误代码
  ```bash
  $ echo "hello"
  hello
  $ echo $?
  0 # The program runs normally and returns 0. 
  $ cat mcd.sh
  mcd(){
  mkdir -p "$1"
  cd "$1"
  }
  $ grep hello mcd.sh 
  $ echo $?
  1 # returns 1, because don't have 'hello' in mcd.sh
  ```
- `$_`可以获取上一个命令的最后一个参数
  ```bash
  $ mkdir test
  cd $_ # 将会跳转到test目录
  ```
- `$#`获取给定某程序的参数数量
- `$@`展开所有的参数，例如当不知道有多少个参数时，可以通过该关键词指定所有参数
- `#!`用于指定默认情况下运行指定脚本的解释器，后跟解释器路径，如`#!/bin/bash`
- `!!`当创建某些东西某有足够权限时，!!将会替换上一次的命令。bangbang~~
  ```bash
  $ mkdir /mnt/new
  mkdir: 无法创建目录 "/mnt/new": 权限不够
  $ sudo !!
  sudo mkdir /mnt/new
  请输入密码:
  ```
- `$$`获取指定程序的进程ID（也简称为PID），每个运行进程都具有唯一的PID，用于在操作系统中标识该进程
- 形似`$(pwd)`的方式，将会将`pwd`的输出存放并赋值给指定变量，例如：`foo=$(pwd)`

- 进程替换，在上一讲我们提到过使用`<`符号可以改变程序的输入，那么我们可以通过命令`cat <(ls) `
  的方式将ls程序得到的输出传递给cat程序，以此完成进程的替换。需要注意必须为后者程序添加`()`
- 在shell命令行中，简化类似参数是一种常见行为
  > 可以使用`*`通配符表示任何字符（串），也可以通过`{}`使不同的字符（串）组合成数组形式，
  >
  > 例如，需要打印`a.md`和`a.markdown`文件，如果完全写明则为“cat a.md a.markdown”，有些麻烦，则可以通过`{}`改写为“cat a.{md,markdown}”形式。
  >
  > `{}`形式中还可以写成：`{a..d}`，意为`{a,b,c,d}`

---

补充

1. `/dev/null`被称为黑洞文件，是UNIX/Linux下的一种特殊文件，对于任何写入该文件的数据都被丢弃。

2. 首先，bash中0，1，2三个数字分别代表STDIN_FILENO、STDOUT_FILENO、STDERR_FILENO，标准输入（一般是键盘），标准输出（一般是显示屏，准确的说是用户终端控制台），标准错误（出错信输出）。
   
   默认输入只有一个（0，STDIN_FILENO），而默认输出有两个（标准输出1 STDOUT_FILENO，标准误2
   STDERR_FILENO）。因此默认情况下，shell输出的错误信息会被输出到2，而普通输出信息会出到1。[^1]
   
   例如：`grep foobar 1.txt 2> error.txt`就是在`1.txt`文件中寻找`foobar`字符串，如没有找到就将错误信息输入到`error.txt`
   文件中。

3. 在实现脚本`example.sh`时，需要注意到在if语句中`[[`和`]]`与表达式之间需要空格
4. shell由于很早就已经开发出来了，所以显得并不是太现代化。可以通过`shellcheck`程序对编写的shell脚本进行debug，在`Jebrains`系列产品中也可以使用`checkshell`插件。

----

[^1]: [bash中 2>&1 & 的解释](https://blog.csdn.net/astonqa/article/details/8252791)



