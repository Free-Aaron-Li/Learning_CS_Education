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

在fish shell下，则需要将`foo=bar`命令修改为`set foo bar`。特别需要注意的是，bash下赋值命令不允许有空格。 对于字符串来说，如果需要对变量进行命令替换（command substitution），则需要使用双引号，如果使用单引号是是不会替换引用变量值的。

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

- 进程替换（process substitution），在上一讲我们提到过使用`<`符号可以改变程序的输入，那么我们可以通过命令`cat <(ls) `，在这里将`<(ls)`替换成临时文件名。通过这种方式将ls程序得到的输出传递给cat程序，以此完成进程的替换。需要注意必须为后者程序添加`()`
- 在shell命令行中，简化类似参数是一种常见行为
  > 可以使用`*`通配符表示任何字符（串），也可以通过`{}`使不同的字符（串）组合成数组形式，
  >
  > 例如，需要打印`a.md`和`a.markdown`文件，如果完全写明则为“cat a.md a.markdown”，有些麻烦，则可以通过`{}`改写为“cat a.{md,markdown}”形式。
  >
  > `{}`形式中还可以写成：`{a..d}`，意为`{a,b,c,d}`

- `history`，bash中命令。获取历史命令。也可以通过“Ctrl+R”快捷键获取

---

补充

1. `/dev/null`被称为黑洞文件，是UNIX/Linux下的一种特殊文件，对于任何写入该文件的数据都被丢弃。

2. 首先，bash中0，1，2三个数字分别代表STDIN_FILENO、STDOUT_FILENO、STDERR_FILENO，标准输入（一般是键盘），标准输出（一般是显示屏，准确的说是用户终端控制台），标准错误（出错信输出）。

   默认输入只有一个（0，STDIN_FILENO），而默认输出有两个（标准输出1 STDOUT_FILENO，标准误2 STDERR_FILENO）。因此默认情况下，shell输出的错误信息会被输出到2，而普通输出信息会出到1。[^1]

   例如：`grep foobar 1.txt 2> error.txt`就是在`1.txt`文件中寻找`foobar`字符串，如没有找到就将错误信息输入到`error.txt`
   文件中。

3. 在实现脚本`example.sh`时，需要注意到在if语句中`[[`和`]]`与表达式之间需要空格
4. shell由于很早就已经开发出来了，所以显得并不是太现代化。可以通过`shellcheck`程序对编写的shell脚本进行debug，在`Jebrains`
   系列产品中也可以使用`checkshell`插件。

> 推荐程序
>
> fd（替代find)
>
> rg(替代grep)
>
> fzf(模糊查询)

## 讲义笔记

shell脚本与其他脚本语言不同之处在在于，shell脚本针对shell所从事的相关工作来进行优化。这使得它比通用的脚本语言更易用。

返回码或退出状态是脚本/命令之间交流执行状态的方式。返回值0表示正常执行，其他所有非0的返回值都表示有错误发生。

同一行的多个命令可以用`;`分隔。

当执行脚本时，我们经常需要提供形式类似的参数。可以通过bash基于文件扩展名展开表达式，该技术被成为shell的通配（globbing）

- 通配符，通过`?`和`*`老匹配一个或任意个字符
- `{}`，当有一系列的指令，其中包含一段公共子串时，可以用花括号自动展开这些命令。（在批量移动或转换文件时非常方便）
- 脚本开头的第一行（以`#!`开头）被称为`shebang`，该行确定该用什么解释器运行该脚本
- shell函数与脚本有些许不同
    - 函数只能与shell使用相同语言，脚本可以使用任意语言。因此在脚本中包含shebang很重要
    - 函数仅在定义时被加载，脚本会在每次执行时加载。这让函数的加载比脚本略微快一些，但每次修改函数定义，都需要重新加载一次
    - 函数会在当前的shell环境中执行，脚本会在单独的进程中执行。因此，函数可以对环境变量进行更改，比如改变当前工作目录，脚本则不行。脚本需要使用到`export`将环境变量导出，并将值传递给环境变量
    - 与其他程序语言一样，函数可以提高代码模块化、代码复用性并创建清晰性的结构。shell脚本中往往也会包含它们自己的函数定义

**shell的哲学之一：寻找（更好用的）替代方案**

- `grep`程序中，参数`-C`获取查找结果的上下文（Context），`-v`对结果进行反选（Invert）

## 课后练习

---

**第一道题**

> 题目：阅读`man ls`，然后使用`ls` 命令进行如下操作：
>
> - 所有文件（包括隐藏文件）
> - 文件打印以人类可以理解的格式输出 (例如，使用454M 而不是 454279954)
> - 文件以最近访问顺序排序
> - 以彩色文本显示输出结果
> - 典型输出如下：
>
> ```bash
>   -rw-r--r-- 1 user group 1.1M Jan 14 09:53 baz
>   drwxr-xr-x   5 user group  160 Jan 14 09:53 .
>   -rw-r--r-- 1 user group  514 Jan 14 06:42 bar
>   -rw-r--r-- 1 user group 106M Jan 13 12:12 foo
>   drwx------+ 47 user group 1.5K Jan 12 18:08 ..
> ```
>

1. 打印所有文件（包括隐藏文件）

   ```bash
   aaron@aaron-PC ~/Downloads> ls -al
   总计 12
   drwxr-xr-x  3 aaron aaron 4096 12月22日 18:51 ./
   drwxr-x--- 52 aaron aaron 4096 12月22日 18:27 ../
   -rw-r--r--  1 aaron aaron    0 12月22日 18:51 .test
   drwxr-xr-x  2 aaron aaron 4096 12月22日 18:51 test/
   ```
2. 文件打印以人类可以理解的格式输出（例如，使用454M而不是454279954）

   ```bash
   aaron@aaron-PC ~/Downloads> ls -al -h
   总计 16K
   drwxr-xr-x  3 aaron aaron 4.0K 12月22日 18:57 ./
   drwxr-x--- 52 aaron aaron 4.0K 12月22日 18:27 ../
   -rwxr--r--  1 aaron aaron  613 12月21日 21:06 example.sh*
   -rw-r--r--  1 aaron aaron    0 12月22日 18:51 .test
   drwxr-xr-x  2 aaron aaron 4.0K 12月22日 18:51 test/
   ```

3. 文件以最近访问顺序排序

    ```bash
    aaron@aaron-PC ~/Downloads> ls -al -t
    总计 16
    drwxr-xr-x  3 aaron aaron 4096 12月22日 18:57 ./
    drwxr-xr-x  2 aaron aaron 4096 12月22日 18:51 test/
    -rw-r--r--  1 aaron aaron    0 12月22日 18:51 .test
    drwxr-x--- 52 aaron aaron 4096 12月22日 18:27 ../
    -rwxr--r--  1 aaron aaron  613 12月21日 21:06 example.sh*
    ```

4. 以彩色文本显示输出结果

   ```bash
   aaron@aaron-PC ~/Downloads> ls -al -t --color=auto
   总计 16
   drwxr-xr-x  3 aaron aaron 4096 12月22日 18:57 ./
   drwxr-xr-x  2 aaron aaron 4096 12月22日 18:51 test/
   -rw-r--r--  1 aaron aaron    0 12月22日 18:51 .test
   drwxr-x--- 52 aaron aaron 4096 12月22日 18:27 ../
   -rwxr--r--  1 aaron aaron  613 12月21日 21:06 example.sh*
   ```

---

**第二道题**

> 题目：编写两个bash函数`marco`和`polo`执行下面的操作。 每当你执行`marco`时，当前的工作目录应当以某种形式保存，当执行`polo`时，无论现在处在什么目录下，都应当`cd`回到当时执行`marco`的目录。 为了方便debug，你可以把代码写在单独的文件`marco.sh`中，并通过`source marco.sh`命令，（重新）加载函数。

marco.sh:

```bash
#!/usr/bin/env bash

save_file_path=~/.path
cat <(pwd) >$save_file_path
```

polo.sh:

```bash
#!/usr/bin/env bash

file_path=$(cat ~/.path)
cd "$file_path" || exit
rm ~/.path
```

---

**第三道题**

> 题目：假设您有一个命令，它很少出错。因此为了在出错时能够对其进行调试，需要花费大量的时间重现错误并捕获输出。 编写一段bash脚本，运行如下的脚本直到它出错，将它的标准输出和标准错误流记录到文件，并在最后输出所有内容。 加分项：报告脚本在失败前共运行了多少次。
>
>   ```bash
>   #!/usr/bin/env bash
>   n=$(( RANDOM % 100 ))
>   
>   if [[ n -eq 42 ]]; then
>   echo "Something went wrong"
>   &2 echo "The error was using magic numbers"
>   exit 1
>   fi
>   
>   echo "Everything went according to plan"
>   ```

检测该程序出错的程序test.sh:

```bash
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
while true
do
  counter=$((counter+1))
  if [[ $counter -eq 1 ]]; then
    $command_to_run > "$OUTPUT_FILE" 2>> "$ERROR_FILE"
  else
    $command_to_run >> "$OUTPUT_FILE" 2>> "$ERROR_FILE"
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
echo "Total iterations : $counter">   exit 1
>   fi
>   
>   echo "Everything went according to plan"
>   ```

检测该程序出错的程序test.sh:

```bash
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
while true
do
  counter=$((counter+1))
  if [[ $counter -eq 1 ]]; then
    $command_to_run > "$OUTPUT_FILE" 2>> "$ERROR_FILE"
  else
    $command_to_run >> "$OUTPUT_FILE" 2>> "$ERROR_FILE"
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
```
----

**第四道题**

> 题目：本节课我们讲解的`find`命令中的`-exec`参数非常强大，它可以对我们查找的文件进行操作。但是，如果我们要对所有文件进行操作呢？例如创建一个zip压缩文件？我们已经知道，命令行可以从参数或标准输入接受输入。在用管道连接命令时，我们将标准输出和标准输入连接起来，但是有些命令，例如`tar`则需要从参数接受输入。这里我们可以使用`xargs`命令，它可以使用标准输入中的内容作为参数。 例如`ls | xargs rm`会删除当前目录中的所有文件。
>
> 您的任务是编写一个命令，它可以递归地查找文件夹中所有的HTML文件，并将它们压缩成zip文件。注意，即使文件名中包含空格，您的命令也应该能够正确执行（提示：查看`xargs`的参数`-d`，译注：MacOS上的`xargs`没有`-d`，查看这个[issue](https://github.com/missing-semester/missing-semester/issues/93)）
>
> 如果您使用的是 MacOS，请注意默认的 BSD `find`与 GNU coreutils 中的是不一样的。你可以为`find`添加`-print0`选项，并为`xargs`添加`-0`选项。作为`Mac`用户，您需要注意 mac 系统自带的命令行工具和 GNU 中对应的工具是有区别的；如果你想使用 GNU 版本的工具，也可以使用[brew](https://formulae.brew.sh/formula/coreutils) 来安装。

命令为：

```bash
find ./ *.html -print0 |xargs -d '\0' tar czf target.tar
```

由于`xargs`程序默认以`\n`作为分隔符号，会把文件名中的空格视为分隔符。

首先需要在`find`程序中将文件名分隔方式由默认的`\n`改为`\0`，以`\0`作为`xargs`程序的分隔符号。这里使用到了`find`程序中的`-print0`参数。

之后，使用`xargs`程序中的`-d`参数，该参数确定以何种分隔符号进行划分，这里使用`\0`作为分隔符完成题目要求。

示例：
```bash
aaron@aaron-PC ~/Downloads> tree ./
./
├── a .html
├── b.html
├── c.html
├── d.html
└── test
    ├── e.html
    ├── f.html
    ├── g.html
    └── test1
        ├── h.html
        └── l.html

2 directories, 9 files
aaron@aaron-PC ~/Downloads> find ./ *.html -print0 |xargs -d '\0' tar czf target.tar
aaron@aaron-PC ~/Downloads> ls
a .html  b.html  c.html  d.html  target.tar  test
aaron@aaron-PC ~/Downloads> rm -r *.html test/
aaron@aaron-PC ~/Downloads> tar xvf target.tar
aaron@aaron-PC ~/Downloads> tree ./
./
├── a .html
├── b.html
├── c.html
├── d.html
├── target.tar
└── test
    ├── e.html
    ├── f.html
    ├── g.html
    └── test1
        ├── h.html
        └── l.html

2 directories, 10 files
```

----

**第五道题**

> 题目：（进阶）编写一个命令或脚本递归的查找文件夹中最近使用的文件。更通用的做法，你可以按照最近的使用时间列出文件吗？

命令：

```bash
find ./ -mtime -1
```

`find`程序中，`-mtime`参数用于文件修改时间，

`-mtime -1`：往前推一天，即昨天到现在。

`-mtime +1`：用来查找1天前的文件，就是昨天以及更加早的文件。

示例：

```bash
aaron@aaron-PC ~/Downloads> exa -al
.rwxr--r-- 613 aaron 21 Dec 21:06 example.sh
.rw-r--r-- 931 aaron 22 Dec 21:46 target.tar
.rw-r--r--   0 aaron 22 Dec 21:54 test.html
aaron@aaron-PC ~/Downloads> find ./ -mtime -1
./
./test.html
./target.tar
```

----

[^1]: [bash中 2>&1 & 的解释](https://blog.csdn.net/astonqa/article/details/8252791)

