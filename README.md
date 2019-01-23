# Travis based Online Judge

![Build Status](https://www.travis-ci.org/c4pr1c3/TravisBasedOJ.svg?branch=master)

基于 Travis 的自动构建系统编写的一个在线自动判题系统。

## Getting Started

可以直接跑通的完整示例项目见：https://github.com/3c1rp4c/TravisBasedOJ

### Prerequisites

* Fork 当前项目
* 根据 [任务二：用bash编写一个文本批处理脚本，对以下附件分别进行批量处理完成相应的数据统计任务](http://sec.cuc.edu.cn/huangwei/course/LinuxSysAdmin/chap0x04.exp.md.print.html) 的要求，完成编写 [ex4/task2.sh](ex4/task2.sh)
* 自动测试框架基于 [bats-core](https://github.com/bats-core/bats-core)
* 一个符合[自动测试](ex4/test/t_task2.bats)脚本的示例输出格式标准如下：

```
-------- Skipped Lines --------
Col1\tCol2\tCol3
-------- Invalid Lines --------
Col1\tCol2\tCol3
-------- Age Statistics --------
Col1\tCol2\tCol3
-------- Positions Statistics --------
Col1\tCol2\tCol3
Col1\tCol2\tCol3
-------- Oldest Names --------
Col1\tCol2\tCol3
-------- Youngest Names --------
Col1\tCol2\tCol3
-------- Longest Names --------
Col1\tCol2\tCol3
-------- Shortest Names --------
Col1\tCol2\tCol3
```

## Deployment

* 如果需要构建属于自己的 travis 自动构建，需要预先在自己的 travis 仓库中预定义所需要[私有变量](https://docs.travis-ci.com/user/environment-variables/#defining-variables-in-repository-settings)
* 向当前仓库提交 Pull Request 会自动触发在我已经构建好的 travis 仓库中进行自动构建，无需在自己的 travis 仓库中进行任何配置

## Built With

* [Travis-CI](https://travis-ci.org) - Test and Deploy Your Code with Confidence
* [Bats-core](https://github.com/bats-core/bats-core) - Bash Automated Testing System (2018)

