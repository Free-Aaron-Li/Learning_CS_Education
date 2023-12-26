#第1讲 数据整理

## 课堂笔记

数据整理（Data Wrangling）的基本思想是：存在某种格式的数据，需要转换成另一种格式的数据。

## 讲义笔记

### 正则表达式

**Regular expressions are notoriously hard to get right, but they are also very handy to have in your toolbox!**

数据整理需要能够明确哪些工具可以被用来达成特定数据整理的目的，并且明白如何组合使用这些工具。

`sed`是一个基于文件编辑器`ed`构建的“流编辑器”。在`sed`中，可以利用一些简短的命令来修改文件，而不是直接操作文件的内容。其中常见的命令是`s`，即
*替换命令*，语法为：`s/REGEX/SUBSTITUTION/`，其中`REGEX`部分是所需使用地正则表达式，`SUBSTITUTION`是用来替换匹配结果的文本。

正则表达式通常以（尽管并不总是）`/`开始和结束。不同字符所表示的含义，根据正则表达式的实现方式不同有所变化。

- `.` 除换行符之外的“任意单个字符”
- `*` 匹配前面字符零次或多次
- `+` 匹配前面字符一次或多次
- `[abc]` 匹配`a`，`b`和`c`中的任意一个
- `(RX1|RX2)` 任何能够匹配`RX1`或`RX2`的结果
- `^` 行首
- `$` 行尾

由于`sed`出现的时间已经比较旧了，所以在某些情况下，所设计的正则表达式可能并不能很好地完成匹配，需要在这些模式前添加`\`才能具有特殊意义，或者，也可以添加`-E`参数来支持这些匹配。

需要注意到的是：正则表达式的“贪婪模式”，正则表达式中`*`和`+`在默认情况下为贪婪模式，其会尽可能多的匹配文本，而如果在二者后缀一个`?`则会变成非贪婪模式，会尽可能少的匹配。示例：

- 测试示例
```text
Only when you understand the true meaning of life can you live truly. Bittersweet as life is, it's still wonderful, and it's fascinating even in tragedy. If you're just alive, try harder and try to live wonderfully.
```

- 正则表达式为`.*try`得到如下：

```text
Match 1:
Only when you understand the true meaning of life can you live truly. Bittersweet as life is, it's still wonderful, and it's fascinating even in tragedy. If you're just alive, try harder and try
```

- 正则表达式为`.*?try`得到如下：

```text
Match 1:
Only when you understand the true meaning of life can you live truly. Bittersweet as life is, it's still wonderful, and it's fascinating even in tragedy. If you're just alive, try
Match 2:
 harder and try
```

有时候希望保留某些信息，可以使用“捕获组（capture groups）”来完成。被圆括号内的正则表达式匹配的文本，都会被存入一系列以编号区分的捕获组中。捕获组的内容可以在替换字符串时使用。

### 数据整理

`sord`程序对输入数据进行排序。该会按照数字顺序对输入进行排序（默认情况下是按照字典序排序）

`uniq`程序会对连续出现的行折叠一行并以使用出现次数作为前缀。

### awk

`awk`程序，其本身可以作为一个编程语言，它非常善于处理文本。

### 分析数据

R是一种编程语言，它非常适合被用来进行数据分析和绘制图表。

## 课后练习

---

**第一道题**

> 题目：学习一下这篇简短的[交互式正则表达式教程](https://regexone.com/).

---

**第二道题**

> 题目：统计words文件 (`/usr/share/dict/words`) 中包含至少三个`a`且不以`'s`结尾的单词个数。这些单词中，出现频率前三的末尾两个字母是什么？`sed`的`y`命令，或者`tr`程序也许可以帮你解决大小写的问题。共存在多少种词尾两字母组合？还有一个很 有挑战性的问题：哪个组合从未出现过？

/* TODO 23-12-26 完成本题及后续题目 */

