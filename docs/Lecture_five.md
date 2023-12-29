# 第5讲 命令行环境

## 课堂笔记

tmux、ssh、dotfiles

> dotfiles git管理
>
> 通过软链接方式将.dotfiles中的文件链接到指定配置目录下，通过通过git管理.dotfile。

## 讲义笔记

在这一讲中将会学习

1. 如何同时执行多个不同的进程并追踪它们的状态、如何停止或暂停某个进程以及如何使进程在后台运行。
2. 学习改善shell及其他工具的工作流的方法（通过定义别名或基于配置文件）
3. 如何使用ssh操作远端机器

### 任务控制

shell通过使用UNIX提供的`信号`机制执行进程间通信。通过信号实现进行的停止执行、改变执行等，从上述而言，**信号是一种软件中断**。

在此之间，常用`ctrl+c`的方式停止进行，实际上当我们输入`ctrl+c`,shell会发送一个`SIGINT`信号给进程。

通过讲义给定Python程序来展示捕获`SIGINT`信号所发生的反应。
```python
#!/usr/bin/env python
import signal, time  # 导包


def handler(signum,time):  # 函数“处理程序”
    print("\nI got a SIGINT, but I am not stopping")


signal.signal(signal.SIGINT, handler)  # 捕获
i = 0
while True:
    time.sleep(.1)
    print("\r{}".format(i), end="")
    i += 1
```


执行结果：

```bash
aaron@aaron-PC ~/Downloads> python3 capture.py 
21^C
I got a SIGINT, but I am not stopping
30^C
I got a SIGINT, but I am not stopping
49^\fish: Job 1, 'python3 capture.py' terminated by signal SIGQUIT (Quit request from job control with core dump (^\))
```

`SIGINT`和`SIGQUIT`都是常用于终止程序的信号，但是`SIGTERM`更为的通用、优雅。该信号需要使用到`kill`程序，其语法：`kill -TERM <PID>`

---

当我们输入`ctrl+z`时，会发出`SIGTSTP`信号用于进程暂停：
```bash
aaron@aaron-PC ~/Downloads> python3 capture.py
17^Zfish: Job 1, 'python3 capture.py' has stopped
```

信号`SIGSTOP`会使进程暂停，其中`SIGTSTP`信号是Terminal Stop的缩写，表示`terminal`版本下的`SIGSTOP`信号。

对于已经暂停的进行，可以使用`fg`或`bg`命令恢复。其分别表示在前台继续或在后台继续。

---

`jobs`命令会列出当前终端会话中尚未完成（结束）的全部任务，通过使用pid引用这些任务，也可以通过`%+任务编号`方式选取该任务。如果需要选择最近任务，则可以使用`$!`参数。

`&`命令后缀可以让命令直接在后台运行，但是此时依旧会使用shell的标准输出显示在shell终端中，对于这一点可以使用shell重定向方式。

尽管将某进程转到后台运行，但是其后台进程仍然属于当前终端进行的**子进程**，一旦关闭终端（将发送`SIGHUP`信号），这些后台进程也会终止。对于这种情况，可以使用`nohup`程序来对某些进程实现忽略`SIGHUP`的封装。针对已经运行中的程序，则使用`disown`解决。

`SIGKILL`其不能被进程捕获且立刻结束该进程，该信号会带来一些副作用，例如：孤儿进程。

---

关于**终端多路复用**，笔者选择使用[zellij](https://zellij.dev/)，而非使用讲座上使用的`tmux`。

终端的多路复用这一概念由tmux提出，本质上其允许我们基于面板（plane）和标签（tab）分割出多个终端窗口（window），这样实现同时与多个shell会话（session）进行交互。

终端多路复用通过分离终端会话方式改善我们的工作流，无需使用`nohup`和其他类似技巧方式。

---

通过`alias`程序为命令起别名。

---

许多程序的配置文件都是纯文本格式且以“.”作为开头（在Linux下*点文件*默认隐藏）的形式，所以将这些*点文件*集中在一起就形成了**dotfiles**文件夹。

我们可以对常见的点文件进行集中管理，例如：
- bash ~/.bashrc, ~/.bash_profile
- git ~/.gitconfig
- vim ~/.vimrc
- ssh ~/.ssh/config
- ...

同时对于`dotfile`可以通过git管理，例如：推送到github上。

----

ssh部分留在后续讲座中