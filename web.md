### jdk环境变量
```
[root@iZ7xvavc793m36sybr4bw4Z javaServer]# vim ~/.bashrc
[root@iZ7xvavc793m36sybr4bw4Z javaServer]# source ~/.bashrc
[root@iZ7xvavc793m36sybr4bw4Z javaServer]# java -version
java version "1.8.0_371"
Java(TM) SE Runtime Environment (build 1.8.0_371-b11)
Java HotSpot(TM) 64-Bit Server VM (build 25.371-b11, mixed mode)
```
在.bashrc中增加
```
export JAVA_HOME=/www/server/java/jdk1.8.0_371 
export PATH=$JAVA_HOME/bin:$PATH
```

### 配置文件
项目根目录下创建一个名为manifest.txt的文件，其中包含以下内容：
```
Main-Class: SimpleWebServer
```
这个文件告诉Java虚拟机在运行jar文件时要执行哪个类的main方法。

### 打包jar
```
jar cvfm WebServer.jar manifest.txt WebServer.class index.html
```
在服务器上运行WebServer.jar文件
```
java -jar WebServer.jar
```


