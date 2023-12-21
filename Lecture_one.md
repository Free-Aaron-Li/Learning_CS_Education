# 第1讲 课程概览与shell

## 课堂笔记

**shell通过空格分隔参数**。

shell，特别是Bash(Bourne Again Shell) 是本身类似于一种编程语言。

路径是描述计算机上文件位置的方式。

在Linux下所用空间都挂载在一个命名空间下。

`pwd`(print working directory)打印当前所在路径

`cd`(change directory)表示更改目录

`.`和`..`为特殊目录，分别表示为当前目录和父目录

`ls`列出当前目录中文件

`~`，特殊字符，表示扩展到主目录，`cd ~`回到主目录

`-`，特殊字符，表示返回之前目录，`cd -`将会回到上一个目录

大多数的程序都会采用所谓的参数，如标志（flags）或选项（options）。通常，称单个破折号（‘-’）和单个字符小写的组合为标志（flag），不带任何值的内容也是标志，带有值的成为选项。

```bash
drwxr-xr-x  2 aaron aaron  4096 12月 7日 19:37  MATLAB/
```

其中第一参数中,第一个字符表示是否是目录（含有`d`），第一组三个字符表示文件所有者设置的权限列表，第二组三个字符表示拥有该文件的组设置的权限列表，最后一组三个字符表示其他人的权限列表

每组的三个字符分别表示：read（读取）、write（写入）和execute（执行）

对于目录来说：

- 读取
	- 转换为“你是否被允许看到这个目录中的文件？”，将读取权限视为是否能查看目录的文件列表。
- 写入
	- 你是否被允许在该目录中重命名、创建或删除文件。对于没有某目录（或文件）写入权限来说，无法删除它，但是可以清空它。
- 执行
	- 目录上的执行权限是所谓的搜索权限，例如如果你想要`cd`某目录，你必须用用该目录及其所有父目录的执行权限。

`mv`(move)表示重命名文件、移动文件、移动目录

`cp`(copy)表示复制文件（或目录）

上述二者均需要两个参数，一个需要修改文件路径，一个目标路径。

`rm`(remove)表示删除文件（或目录）

> 需要注意：
>
> 在Linux下，默认情况下，删除不会递归进行，通过使用`-r`标志进行递归删除。

`rmdir`(remove a directory)表示删除一个目录（但是其只能删除空目录）

`mkdir`(make a directory)表示创建一个目录

`man`(manual page)表示手册页

`cat`(prints the content of a file)

shell的流概念：每个程序都有两个主要的流：`输入流`和`输出流`
，shell提供重定向二者流的方式以改变程序的输入/输出方向。最简单的方式是使用尖括号符号（‘< >’）。“<”表示将这个程序的**输入**
重定向为指定文件的内容，“>”表示将前面程序的**输出**重定向到指定文件中。

存在一种双向箭头（“>>”），它表示追加而不是覆盖。

`|`(pipelines)管道符。将左边程序的输出作为右边程序的输入。

`tail`，打印输入的最后n行

`root`用户，类似于windows中管理员，其用户ID为0。root用户是特殊的，其可以在系统上随意做任何事情。

`sudo`(do as su)，其中`su`指的是超级用户（super user)

`tee`表示将输入内容写入一个文件，同时它输出到标准输出

## 讲义笔记

shell的核心功能：它允许你执行程序，输入并获取某种半结构化的输出。

#### 使用shell

笔者使用的shell：fish shell：

````bash
aaron@aaron-PC ~> 
````

shell基于空格分割命令并进行解析。如果希望传递的参数中包含空格，则需要对空格进行转义。

`witch`程序可以打印指定程序的程序路径。

## 课后练习

**第一道题**

> 题目：本课程需要使用类Unix shell，例如 Bash 或 ZSH。如果您在 Linux 或者 MacOS 上面完成本课程的练习，则不需要做任何特殊的操作。如果您使用的是 Windows，则您不应该使用 cmd 或是 Powershell；您可以使用Windows Subsystem for Linux或者是 Linux 虚拟机。使用`echo $SHELL`命令可以查看您的 shell 是否满足要求。如果打印结果为`/bin/bash`

笔者使用的是fish shell，

```bash
aaron@aaron-PC ~> echo $SHELL
/usr/bin/fish
```

**第二道题**

> 题目：在`/tmp`下新建一个名为`missing`的文件夹。

```bash
aaron@aaron-PC ~> cd /tmp/
aaron@aaron-PC /tmp> mkdir missing
aaron@aaron-PC /tmp> find -L /tmp -name 'missing'
/tmp/missing
```

**第三道题**

> 题目：用`man`查看程序`touch`的使用手册。

```bash
aaron@aaron-PC ~> man touch
```

截图：

![man touch](https://s3.bmp.ovh/imgs/2023/12/20/a6cd9fe240bec3a4.png)

**第四道题**

> 题目：用`touch`在`missing`文件夹中新建一个叫`semester`的文件。

```bash
aaron@aaron-PC ~> cd /tmp/
aaron@aaron-PC /tmp> cd missing/
aaron@aaron-PC /t/missing> touch semester
```

**第五道题**

> 题目：将以下内容一行一行地写入`semester`文件：
> ```bash
> #!/bin/sh
> curl --head --silent https://missing.csail.mit.edu
> ```
> 第一行可能有点棘手，`#`在Bash中表示注释，而`!`即使被双引号（`"`）包裹也具有特殊的含义。 单引号（`'`）则不一样，此处利用这一点解决输入问题。更多信息请参考[Bash quoting](https://www.gnu.org/software/bash/manual/html_node/Quoting.html)手册

```bash
aaron@aaron-PC /t/missing> echo "#!/bin/sh" > semester 
aaron@aaron-PC /t/missing> echo "curl --head --silent https://missing.csail.mit.edu" >>semester 
aaron@aaron-PC /t/missing> cat semester
#!/bin/sh
curl --head --silent https://missing.csail.mit.edu
```

**第六道题**

> 题目：尝试执行这个文件。例如，将该脚本的路径（`./semester`）输入到您的shell中并回车。如果程序无法执行，请使用`ls`命令来获取信息并理解其不能执行的原因。

```bash
aaron@aaron-PC /t/missing> ./semester
fish: Unknown command. './semester' exists but is not an executable file.
aaron@aaron-PC /t/missing [126]> ls -l
总计 4
-rw-r--r-- 1 aaron aaron 61 12月20日 19:55 semester
```

由于`semester`程序不具备可执行权限，无法执行。

**第七道题**

> 题目：查看`chmod`的手册（例如，使用`man chmod`命令）

截图：

![man chmod](https://s3.bmp.ovh/imgs/2023/12/20/a6cd9fe240bec3a4.png)

**第八道题**

> 题目：使用`chmod`命令改变权限，使`./semester`能够成功执行，不要使用`sh semester`来执行该程序。您的`shell`是如何知晓这个文件需要使用`sh`来解析呢？更多信息请参考：[shebang](https://en.wikipedia.org/wiki/Shebang_(Unix))

```bash
aaron@aaron-PC /t/missing> chmod +744 semester 
aaron@aaron-PC /t/missing> ls -l
总计 4
-rwxr--r-- 1 aaron aaron 61 12月20日 19:55 semester*
aaron@aaron-PC /t/missing> ./semester 
HTTP/2 200 
server: GitHub.com
content-type: text/html; charset=utf-8
last-modified: Wed, 29 Nov 2023 09:35:41 GMT
access-control-allow-origin: *
etag: "656705ed-2015"
expires: Wed, 20 Dec 2023 12:19:11 GMT
cache-control: max-age=600
x-proxy-cache: MISS
x-github-request-id: 5346:2ABD8A:8B4A13:9013C4:6582D965
accept-ranges: bytes
date: Wed, 20 Dec 2023 12:09:11 GMT
via: 1.1 varnish
age: 0
x-served-by: cache-tyo11974-TYO
x-cache: MISS
x-cache-hits: 0
x-timer: S1703074151.037085,VS0,VE163
vary: Accept-Encoding
x-fastly-request-id: 96720c0dfe4e373311a9464c0e36931606e723eb
content-length: 8213
```

**第九道题**

> 题目：使用`|`和`>`，将`semester`文件输出的最后更改日期信息，写入主目录下的 `last-modified.txt`的文件中

```bash
aaron@aaron-PC /t/missing> ./semester | grep --ignore-case last-modified | cut --delimiter=' ' -f2- | tee /home/aaron/last-modified.txt
Wed, 29 Nov 2023 09:35:41 GMT
aaron@aaron-PC /t/missing> cat /home/aaron/last-modified.txt
Wed, 29 Nov 2023 09:35:41 GMT
```

**地十道题**

> 题目：写一段命令来从 /sys 中获取笔记本的电量信息，或者台式机 CPU 的温度。注意：macOS 并没有 sysfs，所以 Mac 用户可以跳过这一题。


在下面描述的目录中`capacity`文件存放着笔记本电量信息

````bash
aaron@aaron-PC /s/c/p/BAT1> cat /sys/class/power_supply/BAT1/capacity
57
````

通过阅读Linux内核文档[sysfs-interface](https://www.kernel.org/doc/Documentation/hwmon/sysfs-interface)
可以发现，`/sys/class/hwmon/`存放CPU状态信息。

笔者主机CPU为AMD，所以首先需要确定那个文件是用来监测CPU温度的。

```bash
aaron@aaron-PC /s/c/h/hwmon3> cd 
aaron@aaron-PC ~> cd /sys/class/hwmon/
aaron@aaron-PC /s/c/hwmon> tree ./
./
├── hwmon0 -> ../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/ACPI0003:00/power_supply/ACAD/hwmon0
├── hwmon1 -> ../../devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/PNP0C0A:00/power_supply/BAT1/hwmon1
├── hwmon2 -> ../../devices/pci0000:00/0000:00:08.1/0000:06:00.0/hwmon/hwmon2
└── hwmon3 -> ../../devices/pci0000:00/0000:00:18.3/hwmon/hwmon3

4 directories, 0 files
```

首先进入`/sys/class/hwmon`目录，在此目录下发现`hwmon2`和`hwmon3`目录下存在监测温度的文件`temp1_input`。

```bash
aaron@aaron-PC /s/c/hwmon> cd hwmon3
aaron@aaron-PC /s/c/h/hwmon3> ls -l
总计 0
lrwxrwxrwx 1 root root    0 12月20日 19:16 device -> ../../../0000:00:18.3/
-r--r--r-- 1 root root 4096 12月20日 19:16 name
drwxr-xr-x 2 root root    0 12月20日 20:52 power/
lrwxrwxrwx 1 root root    0 12月20日 19:16 subsystem -> ../../../../../class/hwmon/
-r--r--r-- 1 root root 4096 12月20日 19:16 temp1_input
-r--r--r-- 1 root root 4096 12月20日 19:16 temp1_label
-rw-r--r-- 1 root root 4096 12月20日 19:16 uevent
```

得到CPU温度：

```bash
aaron@aaron-PC /s/c/h/hwmon3> cat temp1_input 
46125
```

但是其单位为`毫摄氏度`，编写脚本可得：

```bash
aaron@aaron-PC /s/c/h/hwmon3> cat /sys/class/hwmon/hwmon3/temp1_input 
46625
```
