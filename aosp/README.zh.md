“阻止运行”支持非Xposed模式，但是需要改动系统，由于作者本人主要使用Android 6.0，所以暂时只提供android 6.0的补丁。改动有两种方式，一是源码方式，二是直接smali方式。

# smali 方式

## 需求
- [java](http://www.oracle.com/technetwork/java/javase/downloads/index.html) 运行smali/baksmali需要Java，JRE就够了。
- [smali](http://github.com/JesusFreke/smali) 把smali源码编译成dex，二进制下载在 [smali ‐ Bitbucket](https://bitbucket.org/JesusFreke/smali/downloads) 上。
- [baksmali](http://github.com/JesusFreke/smali) 把dex反编译成smali，二进制下载也在 [smali ‐ Bitbucket](https://bitbucket.org/JesusFreke/smali/downloads) 上。
- patch 打补丁，Linux/Mac OS X下自带，windows需要下载[Patch for Windows](http://gnuwin32.sourceforge.net/packages/patch.htm)，另外[Git for Windows](https://git-for-windows.github.io/)也自带。
- [api-23.smali.patch](api-23.smali.patch)

## 从系统中获取 `services.jar`

```
shell> adb pull /system/framework/services.jar
```

如果`services.jar`很小，只有几百个字节的话，那么系统是经过优化的，需要下载`services.odex`以及`boot.oat`。

## 反编译 `services.jar`

`baksmali`加上`-b -s`参数是为了去掉调试信息，因为补丁文件也是这样生成的。

```
shell> java -jar baksmali.jar -a 23 -b -s services.jar -o services
```

## 打补丁

```
shell> patch -p0 < api-23.smali.patch
```

在Windows的某些版本下(如windows 7)，名称中含`patch`的程序，必须额外加上特定的`manifest`，否则不能运行，所以换个名字吧。此外，由于Windows下的一些换行符问题，参数还必须加上`--binary`。
```
cmd> move patch.exe dabuding.exe
cmd> dabuding.exe --binary -p0 < api-23.smali.patch
```

需要检查是否有打成功。

## 重新打包 `services.jar`

`smali`加上`-j 1`参数可以保证每次生成的dex文件一样。

```
shell> java -jar smali.jar -a 23 -j 1 -o classes.dex services
shell> jar -cvf services.jar classes.dex
```

## 把打包好的`services.jar`放入系统，重启。

## 进阶方式

把改过后的文件，打成一个包 `pr.jar`，然后改动 `boot.img` 中的 `init.environ.rc`，在这个前面加入 `pr.jar`，可以不用改动系统分区。

# 源码 方式

这个方式适合从头开始编译的ROM系统，只需要在 `frameworks/base` 下应用 `api-23.patch` 补丁即可。

```
shell> cd frameworks/base
shell> patch -p1 < /path/to/api-23.patch
shell> mmm services/:services
```