## 如何运行Java程序
Java源码本质上是一个文本文件，我们需要先用javac把Hello.java编译成字节码文件Hello.class，然后，用java命令执行这个字节码文件：
```java
┌──────────────────┐
│    Hello.java    │◀── source code
└──────────────────┘
          │ compile
          ▼
┌──────────────────┐
│   Hello.class    │◀── byte code
└──────────────────┘
          │ execute
          ▼
┌──────────────────┐
│    Run on JVM    │
└──────────────────┘
```
因此，可执行文件`javac`是编译器，而可执行文件java就是虚拟机。

第一步，在保存`Hello.java`的目录下执行命令`javac Hello.java`：
```
javac Hello.java
或者加上字符编码参数
javac -encoding UTF-8 Hello.java
```
如果源代码无误，上述命令不会有任何输出，而当前目录下会产生一个Hello.class文件：
第二步，执行Hello.class，使用命令java Hello：
```
java Hello
```
注意：给虚拟机传递的参数Hello是我们定义的类名，虚拟机自动查找对应的class文件并执行。
有一些童鞋可能知道，直接运行java Hello.java也是可以的：
```
java Hello.java 
```
这是Java 11新增的一个功能，它可以直接运行一个单文件源码

### 代码

```java

public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, world");
    }
}
```
创建后jdk21目录结构为
```bash
├───javax/   /*项目的根目录，包含项目的配置文件和源代码*/
│   ├───.gitignore
│   ├───javax.iml  /* IntelliJ IDEA项目文件，用于存储项目的配置信息*/
│   ├───.idea/  /*IntelliJ IDEA的配置文件夹，包含项目的设置和配置信息*/
│   │   ├───.gitignore  
│   │   ├───misc.xml
│   │   ├───modules.xml
│   ├───src/     /*源代码文件夹，包含项目的Java源代码文件*/
│   │   ├───Main.java
```

运行后IDE(idea)
```bash
"C:\Program Files\Java\jdk-21\bin\java.exe" -agentlib:jdwp=transport=dt_socket,address=127.0.0.1:53700,suspend=y,server=n -javaagent:C:\Users\李恒\AppData\Local\JetBrains\IntelliJIdea2023.3\captureAgent\debugger-agent.jar -Dfile.encoding=UTF-8 -Dsun.stdout.encoding=UTF-8 -Dsun.stderr.encoding=UTF-8 -classpath "C:\Users\李恒\Desktop\javax\out\production\javax;C:\Program Files\JetBrains\IntelliJ IDEA 2023.3.5\lib\idea_rt.jar" Main
已连接到地址为 ''127.0.0.1:53700'，传输: '套接字'' 的目标虚拟机
Hello world!
已与地址为 ''127.0.0.1:53700'，传输: '套接字'' 的目标虚拟机断开连接

进程已结束，退出代码为 0
```


### 注释
Java有3种注释，第一种是单行注释，以双斜线开头，直到这一行的结尾结束：
```java
// 这是注释...
```
而多行注释以/*星号开头，以*/结束，可以有多行：
```java
/*
这是注释...
*/
```

### 打印
Java使用关键字`System.out.println()`打印输出。

### 基本数据类型
Java定义了以下几种基本数据类型：

- 整数类型：byte，short，int，long

- 浮点数类型：float，double

- 字符类型：char

- 布尔类型：boolean


```java
public class Main {   //浮点数精度
    public static void main(String[] args) {
        double x = 1.0 / 10;
        double y = 1 - 9.0 / 10;
        // 观察x和y是否相等:
        System.out.println(x);
        System.out.println(y);
    }
}
```

```java
public class Main {  //数组类型
    public static void main(String[] args) {
        // 5位同学的成绩:
        int[] ns = new int[5];
        ns[0] = 68;
        ns[1] = 79;
        ns[2] = 91;
        ns[3] = 85;
        ns[4] = 62;
    }
}

```
### 变量
```java
public class Main {
    public static void main(String[] args) {
        int n = 100; // 定义变量n，同时赋值为100
        System.out.println("n = " + n); // 打印n的值

        n = 200; // 变量n赋值为200
        System.out.println("n = " + n); // 打印n的值

        int x = n; // 变量x赋值为n（n的值为200，因此赋值后x的值也是200）
        System.out.println("x = " + x); // 打印x的值

        x = x + 100; // 变量x赋值为x+100（x的值为200，因此赋值后x的值是200+100=300）
        System.out.println("x = " + x); // 打印x的值
        System.out.println("n = " + n); // 再次打印n的值，n应该是200还是300？
   }
}

```

### 字符串

#### string

#### StringBuilder

#### StringJoiner






