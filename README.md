D语言
创建脚本文件syscall.d
跟可执行文件每次进入每个系统调用时的可执行文件名称：
```shell
$ vi syscall.d
```
输入脚本：
```shell
#!/usr/sbin/dtrace -s  #解释器调用行
syscall:::entry
{
  trace(execname);
}
```
执行脚本文件：
```shell
$ sudo dtrace -s syscall.d
CPU     ID                    FUNCTION:NAME
  3    264                      ioctl:entry   dtrace                           
  3    264                      ioctl:entry   dtrace                           
  0    560                     sysctl:entry   dtrace  
```

## 将脚本文件添加到xcode构建目标target中
