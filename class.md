# 对象
### 初体验
#### 基本参数绑定
```java
public class Main {
    public static void main(String[] args) {
        Person p = new Person();
        int n = 15; // n的值为15
        p.setAge(n); // 传入n的值
        System.out.println(p.getAge()); // 15
        n = 20; // n的值改为20
        System.out.println(p.getAge()); // 15还是20?
    }
}

class Person {
    private int age;

    public int getAge() {
        return this.age;
    }

    public void setAge(int age) {
        this.age = age;
    }
}
```

#### 引用参数绑定
```java
public class Main {
    public static void main(String[] args) {
        Person p = new Person();
        String bob = "Bob";
        p.setName(bob); // 传入bob变量
        System.out.println(p.getName()); // "Bob"
        bob = "Alice"; // bob改名为Alice
        System.out.println(p.getName()); // "Bob"还是"Alice"?
    }
}

class Person {
    private String name;

    public String getName() {
        return this.name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
```
#### 综合使用
引用绑定参数和构造方法method,并在主函数中调用

```java
public class Main {
    public static void main(String[] args) {
        Person p = new Person("Xiao Ming", 15);
        System.out.println(p.getName()); //调用method
        System.out.println(p.getAge());
    }
}


class Person {
    private String name;// 默认值为null，可初始化
    private int age;// 默认值为0


    public Person() {  // 默认构造方法，无参数，无执行语句，可与自定义构造函数一起使用
    }


    public Person(String name, int age) { // 自定义构造方法，有参数，有执行语句
        this.name = name;
        this.age = age; 
    }

        public Person(String name) {//本案例使用多构造方法
        this.name = name;
        this.age = 12;  //在自定义构造函数中初始化age，以此为最终值
    }
    
    public String getName() {
        return this.name; //构造方法中的执行语句
    }

    public int getAge() {
        return this.age;
    }
}
```

#### 方法重载

```java
class Hello {
    public void hello() {
        System.out.println("Hello, world!");
    }

    public void hello(String name) {
        System.out.println("Hello, " + name + "!");
    }

    public void hello(String name, int age) {
        if (age < 18) {
            System.out.println("Hi, " + name + "!");
        } else {
            System.out.println("Hello, " + name + "!");
        }
    }
}
```

#### 重载调用
一是自定义，二是官方提供
```java
public class Main {
    public static void main(String[] args) {
        String s = "Test string";
        int n1 = s.indexOf('t');//int indexOf(int ch)：根据字符的Unicode码查找
        int n2 = s.indexOf("st");//int indexOf(String str)：根据字符串查找；
        int n3 = s.indexOf("st", 4);//根据字符串查找，但指定起始位置。
        int n4 = s.indexOf("t", 2);//根据字符查找，指定起始位置2,输出略
        System.out.println(n1);
        System.out.println(n2);
        System.out.println(n3);
        System.out.println(n4);
    }
}
```

### 继承
我们让Student从Person继承时，Student就获得了Person的所有功能，我们只需要为Student编写新增的功能。
Java使用extends关键字来实现继承

```java
class Student extends Person {
    // 不要重复name和age字段/方法,
    // 只需要定义新增score字段/方法:
    private int score;
    public int getScore() { … }
    public void setScore(int score) { … }
}
```
注意:因为在Java中，任何class的构造方法，第一行语句必须是调用父类的构造方法。如果没有明确地调用父类的构造方法，编译器会帮我们自动加一句super();，所以，Student类的构造方法实际上是这样：
```java
class Student extends Person {
    protected int score;

    public Student(String name, int age, int score) {
        super(); // 自动调用父类的构造方法
        this.score = score;
    }
}
```
但是，Person类并没有无参数的构造方法，因此，编译失败。

解决方法是调用Person类存在的某个构造方法。例如：
```java
class Student extends Person {
    protected int score;

    public Student(String name, int age, int score) {
        super(name, age); // 调用父类的构造方法Person(String, int)
        this.score = score;
    }
}
```

### 多态
在继承关系中，子类如果定义了一个与父类方法签名完全相同的方法，被称为覆写（Override）。
Override和Overload不同的是，如果方法签名不同，就是Overload，Overload方法是一个新方法；如果方法签名相同，并且返回值也相同，就是Override。
```java
public class Main {
    public static void main(String[] args) {
        Person p = new Student();  //继承
        p.run(); // 应该打印Person.run还是Student.run?
        System.out.println(p.hello());
    }
}

class Person {
    public void run() {
        System.out.println("Person.run");
    }
    public String hello() {
        return "Hell";
    }
}

class Student extends Person {
    @Override
    public void run() {
        System.out.println("Student.run");
    }

    public String hello() {
        // 调用父类的hello()方法:
        return super.hello() + "!";
    }
}

```
运行一下上面的代码就可以知道，实际上调用的方法是Student的run()方法。因此可得出结论：
Java的实例方法调用是基于运行时的实际类型的动态调用，而非变量的声明类型。
这个非常重要的特性在面向对象编程中称之为多态。它的英文拼写非常复杂：Polymorphic。

#### super
在子类的覆写方法中，如果要调用父类的被覆写的方法，可以通过super来调用。这段代码就调用了父类的hello()方法，所以打印出Hell!
```java
    public String hello() {
        // 调用父类的hello()方法:
        return super.hello() + "!";
    }
```

#### final
继承可以允许子类覆写父类的方法。如果一个父类不允许子类对它的某个方法进行覆写，可以把该方法标记为final。用final修饰的方法不能被Override。

#### 抽象
如果父类的方法本身不需要实现任何功能，仅仅是为了定义方法签名，目的是让子类去覆写它，那么，可以把父类的方法声明为抽象方法：
```java
abstract class Person {
    public abstract void run();
}
```
把一个方法声明为`abstract`，表示它是一个抽象方法，本身没有实现任何方法语句.
编译器会告诉我们，无法编译Person类，因为它包含抽象方法。必须把Person类本身也声明为abstract，才能正确编译它,使用abstract修饰的类就是抽象类。我们`无法实例化一个抽象类`：
```java
Person p = new Person(); // 编译错误
```
无法实例化的抽象类有什么用？
因为抽象类本身被设计成`只能用于被继承`，因此，抽象类可以强迫子类实现其定义的抽象方法，否则编译会报错。因此，抽象方法实际上相当于定义了“`规范`”.例如，Person类定义了抽象方法run()，那么，在实现子类Student的时候，就必须覆写run()方法
```java
public class Main {
    public static void main(String[] args) {
        Person p = new Student();
        p.run();
    }
}

abstract class Person {
    public abstract void run();
}

class Student extends Person {
    @Override
    public void run() {
        System.out.println("Student.run");
    }
}
```
所以使用父类方法名即可调用子类中方法，无需关注子类中再次重写的父类方法。
这种尽`量引用高层类型，避免引用实际子类型`的方式，称之为面向抽象编程
`不需要子类`就可以实现业务逻辑（正常编译），具体的业务逻辑由不同的子类实现，调用者并不关心



#### 接口

在抽象类中，抽象方法本质上是定义接口规范：即规定高层类的接口，从而保证所有子类都有相同的接口实现，更多实现面向抽象编程

如果一个抽象类没有字段，所有方法全部都是抽象方法：
```java
abstract class Person {
    public abstract void run();
    public abstract String getName();
}
```
就可以把该抽象类改写为接口：interface。

在Java中，使用interface可以声明一个接口：
```java
interface Person {
    void run();
    String getName();
}
```
##### 接口使用
`interface`就是比抽象类还要抽象的纯抽象接口，因为它连字段都不能有。因为接口定义的所有方法默认都是`public abstract`的，所以这两个修饰符不需要写出来。
当一个具体的`class`去实现一个`interface`时，需要使用`implements`关键字。举个例子：
```java
class Student implements Person {
    private String name;

    public Student(String name) {
        this.name = name;
    }

    @Override
    public void run() {
        System.out.println(this.name + " run");
    }

    @Override
    public String getName() {
        return this.name;
    }
}
```
在Java中，一个类只能继承自另一个类，不能从多个类继承。但是，一个类可以实现多个`interface`，例如：
```java
class Student implements Person,knowledge // 实现了两个interface
```
##### 接口继承
一个interface可以继承自另一个interface。interface继承自interface使用`extends`，它相当于扩展了接口的方法。例如：
```java
interface Hello {
    void hello();
}

interface Person extends Hello {
    void run();
    String getName();
}
```
此时，`Person`接口继承自Hello接口，因此，Person接口现在实际上有3个`抽象方法签名`，其中一个来自继承的Hello接口

#### 接口增加方法
实现类可以不必覆写default方法。default方法的目的是，当我们需要给接口新增一个方法时，会涉及到修改全部子类。如果新增的是default方法，那么子类就不必全部修改，只需要在需要覆写的地方去覆写新增方法。
```java
public class Main {
    public static void main(String[] args) {
        Person p = new Student("Xiao Ming");
        p.run();
    }
}

interface Person {
    String getName();
    default void run() {
        System.out.println(getName() + " run");
    }
}

class Student implements Person {
    private String name;

    public Student(String name) {
        this.name = name;
    }

    public String getName() {
        return this.name;
    }
}
```

default方法和抽象类的普通方法是有所不同的。因为interface没有字段，default方法无法访问字段，而抽象类的普通方法可以访问实例字段。


#### 静态字段和方法

在一个class中定义的字段，我们称之为实例字段。实例字段的特点是，每个实例都有独立的字段，各个实例的同名字段互不影响。

还有一种字段，是用static修饰的字段，称为静态字段，定义`public static int 变量`

实例字段在每个实例中都有自己的一个独立“空间”，但是静态字段只有一个共享“空间”，所有实例都会共享该字段。可以得到下面代码结果,可以理解"所有实例共享一个静态字段"吗
```
88
99
```
```java
public class Main {
    public static void main(String[] args) {
        Person ming = new Person("Xiao Ming", 12);
        Person hong = new Person("Xiao Hong", 15);
        ming.number = 88;
        System.out.println(hong.number);
        hong.number = 99;
        System.out.println(ming.number);
    }
}

class Person {
    public String name;
    public int age;

    public static int number;

    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
}

```
调用实例方法必须通过一个实例变量，而调用静态方法则不需要实例变量，通过类名就可以调用。静态方法类似其它编程语言的函数。（略）
```java
public class Main {  //该例
    public static void main(String[] args) {
        Person.setNumber(99);  
        System.out.println(Person.number);
    }
}

class Person {
    public static int number;

    public static void setNumber(int value) {
        number = value;
    }
}

```



#### 接口的静态方法

因为interface是一个纯抽象类，所以它不能定义实例字段。但是，interface是可以有静态字段的，并且静态字段必须为final类型：
```java
public interface Person {
    public static final int MALE = 1;
    public static final int FEMALE = 2;
}
```
实际上，因为interface的字段只能是public static final类型，所以我们可以把这些修饰符都去掉，上述代码可以简写为：
```java
public interface Person {
    // 编译器会自动加上public statc final:
    int MALE = 1;
    int FEMALE = 2;
}
```
编译器会自动把该字段变为public static final类型。

#### 导入类的静态字段和静态方法

import static的语法，它可以导入一个类的静态字段和静态方法：
```java
package main;

// 导入System类的所有静态字段和静态方法:
import static java.lang.System.*;

public class Main {
    public static void main(String[] args) {
        // 相当于调用System.out.println(…)
        out.println("Hello, world!");
    }
}
```
import static很少使用
### 包
ava定义了一种名字空间，称之为包：`package`。一个类总是属于某个包，类名（比如Person）只是一个简写，真正的完整类名是`包名.类名`
在定义class的时候，我们需要在第一行声明这个class属于哪个包。
如小明，小红和小军的Person.java文件，可以看到`mr.jun`多级包结构
```java
package ming; // 申明包名ming

public class Person {
}
package hong; // 申明包名ming

public class Person {
}
package mr.jun; // 申明包名mr.jun，包的多级结构

public class Arrays {
}
```
在生成字节码的时候文件结构是
```
 src
    |- hong
    │  └─ Person.java
    |- ming
    │  └─ Person.java
    └─ mr
       └─ jun
          └─ Arrays.java
```          
编译后一样
```
└─ bin
   ├─ hong
   │  └─ Person.class
   │  ming
   │  └─ Person.class
   └─ mr
      └─ jun
         └─ Arrays.class
```         
#### 包作用域
##### 相同包
```java
package hello;

public class Main {
    public static void main(String[] args) {
        Person p = new Person();
        p.hello(); // 可以调用，因为Main和Person在同一个包
    }
}

public class Person {
    // 包作用域:
    void hello() {
        System.out.println("Hello!");
    }
}
```
##### 不同包

引用其他的class
第一种，直接写出完整类名，例如：
```java
// Person.java
package ming;

public class Person {
    public void run() {
        mr.jun.Arrays arrays = new mr.jun.Arrays();
    }
}
```
很显然，每次写完整类名比较痛苦。

因此，第二种写法是用import语句，导入小军的Arrays，然后写简单类名：
```java
// Person.java
package ming;

// 导入完整类名:
import mr.jun.Arrays;//import mr.jun.*;导入该类下所有包

public class Person {
    public void run() {
        Arrays arrays = new Arrays();
    }
}
```
在写import的时候，可以使用*，表示把这个包下面的所有class都导入进来（`但不包括子包的class`）

### 编译时多结构包编译
#### inux环境
首先，确保当前目录是work目录，即存放src和bin的父目录：
```bash
$ ls
bin src
```
然后，编译src目录下的所有Java文件：
```bash
$ javac -d ./bin src/**/*.java
```
命令行-d指定输出的class文件存放bin目录，后面的参数src/**/*.java表示src目录下的所有.java文件，包括任意深度的子目录。

#### windows环境
注意：Windows不支持**这种搜索全部子目录的做法，所以在Windows下编译必须依次列出所有.java文件：
```bash
C:\work> javac -d bin src\com\itranswarp\sample\Main.java src\com\itranswarp\world\Persion.java
```
如果编译无误，则javac命令没有任何输出。可以在bin目录下看到如下class文件：
```
bin
└── com
    └── itranswarp
        ├── sample
        │   └── Main.class
        └── world
            └── Person.class
```            
现在，我们就可以直接运行class文件了。根据当前目录的位置确定classpath，例如，当前目录仍为work，则classpath为bin或者./bin：
```bash
$ java -cp bin com.itranswarp.sample.Main 
Hello, world!
```

### 内部类
内部类（Inner Class）是定义在另一个类内部的类。


### JavaBean

JavaBean是一种符合`命名规范的class`，它通过getter和setter来定义属性；

属性是一种通用的叫法，并非Java语法规定；

可以利用IDE快速生成getter和setter；

使用Introspector.getBeanInfo()可以获取属性列表。