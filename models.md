# 创建模型
等价于SQL语句创建表
```python
from django.db import models

class Person(models.Model):
    first_name = models.CharField(max_length=30)

```   
### 模型方法
 ```
常见如Django还内置了一些模型方法，如__str__()、get_absolute_url()和__hash__()。__str__()方法用于返回实例的可读字符串表示，get_absolute_url()方法返回模型实例的URL，__hash__()方法返回模型实例的哈希值。
 ```

讲讲__str__()方法,在Python中，__str__()方法是一个特殊的方法，用于返回对象的字符串表示。当你尝试打印一个对象或将其转换为字符串时，Python会**自动**调用这个方法。比如这是优化后的_str_

```python
class Person(models.Model):
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    birth_date = models.DateField()

    def __str__(self):
        return self.first_name + self.last_name
``` 

调用如下：

 ```
在使用时如在HTML中插入{{Person.heng}}
会如果heng实例的first_name为"John"，last_name为"Doe"，
那么在HTML模板中插入{{ Person.heng }}将显示为"JohnDoe"。
 ```   

#### 模型方法进阶（了解）
```python
#模型的方法其实就是Python的实例方法。#Django内置了一些，我们也可以自定义一些。

#在模型中添加自定义方法会给你的模型提供#自定义的“行级”数据操作能力，也就是说每个模型的实例都可以调用模型方法。与之对应的是类 Manager 的方法提供的是“表级”的数据操作。

#在后面的章节有对Django内置API方法的详细介绍。

#建议：如果你有一段需要针对每个模型实例都有效的业务代码，应该把它们抽象成为一个函数，放到模型中成为模型方法，而不是在大量视图中重复编写这段代码，或者在视图中抽象成一个函数。

#下面的例子展示了如何自定义模型方法：

class Person(models.Model):
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    birth_date = models.DateField()

    def baby_boomer_status(self):
        "Returns the person's baby-boomer status."
        import datetime
        if self.birth_date < datetime.date(1945, 8, 1):
            return "Pre-boomer"
        elif self.birth_date < datetime.date(1965, 1, 1):
            return "Baby boomer"
        else:
            return "Post-boomer"

    @property
    def full_name(self):
        "Returns the person's full name."
        return '%s %s' % (self.first_name, self.last_name)
#baby_boomer_status作为一个自定义的模型方法，可以被任何Person的实例调用，进行生日日期判断
#full_name模型方法被Python的属性装饰器转换成了一个类属性
#具体使用操作：

#>>>jack = Person.objects.get(pk=1)
#>>>jack.baby_boomer_status()    # 以执行函数的方式调用
# ...
#>>>jack.full_name   # 以属性的方式调用
# jack Tomas
```
### 主键primary_key
 ```
Django会自动创建自动增一的主键id，当然也可以自己指定主键
 ```
如果你没有给模型的任何字段设置这个参数为True，Django将自动创建一个AutoField自增字段，名为‘id’，并设置为主键。也就是
`id = models.AutoField(primary_key=True)。`

如果你为某个字段设置了`primary_key=True`，则当前字段变为主键，并关闭Django自动生成id主键的功能。

`primary_key=True`隐含`null=False`和`unique=True`的意思。一个模型中只能有一个主键字段
### 字段
#### 常见字段类型
模型中的每一个字段都应该是某个 Field 类的实例，字段类型具有下面的作用：

- 决定数据表中对应列的数据类型(例如：`INTEGER`, `VARCHAR`, `TEXT`)
- HTML中对应的表单标签的类型，例如```<input type=“text” />```
- 在admin后台和自动生成的表单中进行数据验证
Django内置了许多字段类型，它们都位于`django.db.models`中，例如`models`.`CharField`，它们的父类都是Field类。这些类型基本满足需求，如果还不够，你也可以自定义字段。

下表列出了常用Django内置的字段类型，但不包括关系字段类型（字段名采用驼峰命名法)

类型 | 说明 
------------ | ----------
AutoField | 一个自动增加的整数类型字段。通常你不需要自己编写它，Django会自动帮你添加字段：id = models.AutoField(primary_key=True)，这是一个自增字段，从1开始计数
CharField | 最常用的类型，字符串类型。必须接收一个max_length参数，表示字符串长度不能超过该值。默认的表单标签是text input。 
EmailField|邮箱类型，默认max_length最大长度254位。使用这个字段的好处是，可以使用Django内置的EmailValidator进行邮箱格式合法性验证。
FileField|class FileField(upload_to=None, max_length=100, **options)上传文件类型
ImageField|图像类型
TextField|用于储存大量的文本内容，在HTML中表现为Textarea标签，最常用的字段类型之一！如果你为它设置一个max_length参数，那么在前端页面中会受到输入字符数量限制，然而在模型和数据库层面却不受影响。只有CharField才能同时作用于两者。
URLField|一个用于保存URL地址的字符串类型，默认最大长度200



##### ImageField
```
class ImageField(upload_to=None, height_field=None, width_field=None, max_length=100, **options)
```
用于保存图像文件的字段。该字段继承了`FileField`，其用法和特性与`FileField`基本一样，只不过多了两个属性`height`和width。默认情况下，该字段在HTML中表现为一个`ClearableFileInput`标签。在数据库内，我们实际保存的是一个字符串类型，默认最大长度100，可以通过`max_length`参数自定义。真实的图片是保存在服务器的文件系统内的。

height_field参数：保存有图片高度信息的模型字段名。 width_field参数：保存有图片宽度信息的模型字段名。

使用Django的ImageField需要提前安装pillow模块，`pip install pillow`即可。

#### 关系类型字段
##### 一对多关系ForeignKey

例如：
```
class Car(models.Model):
    # 定义一个外键字段，表示汽车的制造商
    # 'production.Manufacturer' 是指向 Manufacturer 模型的外键
    # on_delete=models.CASCADE 表示当关联的 Manufacturer 对象被删除时，同时删除所有关联的 Car 对象
    manufacturer = models.ForeignKey(
        'Manufacturer',  
        on_delete=models.CASCADE,
    )
```
- 若Manufacturer在production应用中，则外键字段为：`manufacturer = models.ForeignKey('production.Manufacturer', on_delete=models.CASCADE)`


###### on_delete参数
1. `CASCADE`：模拟SQL语言中的ON DELETE CASCADE约束，将定义有外键的模型对象同时删除
2. `PROTECT`:阻止上面的删除操作，但是弹出`ProtectedError`异常
3. `SET_NULL`：将外键字段设为null，只有当字段设置了`null=True`时，方可使用该值。
4. `SET_DEFAULT`:将外键字段设为默认值。只有当字段设置了`default`参数时，方可使用。
5. `DO_NOTHING`：什么也不做
6. `SET()`：设置为一个传递给SET()的值或者一个回调函数的返回值。注意大小写。

###### related_name
用于关联对象反向引用模型的名称

##### 多对多关系ManyToManyField


##### 字段的参数

- 模型字段都可以接收一定数量的参数，比如CharField至少需要一个max_length参数。在此列出三种。具体需求根据官方文档使用
###### null
该值为True时，Django在数据库用NULL保存空值。默认值为False。对于保存字符串类型数据的字段，请尽量避免将此参数设为True，那样会导致两种‘没有数据’的情况，一种是NULL，另一种是空字符串''。Django 的惯例是使用空字符串而不是 NULL。

###### blank
True时，字段可以为空。默认False。和null参数不同的是，null是纯数据库层面的，而blank是验证相关的，它与表单验证是否允许输入框内为空有关，与数据库无关。所以要小心一个null为False，blank为True的字段接收到一个空值可能会出bug或异常。

###### choices
用于页面上的选择框标签，需要先提供一个二维的二元元组，第一个元素表示存在数据库内真实的值，第二个表示页面上显示的具体内容。在浏览器页面上将显示第二个元素的值。例如：
```
  YEAR_IN_SCHOOL_CHOICES = (
        ('FR', 'Freshman'),
        ('SO', 'Sophomore'),
        ('JR', 'Junior'),
        ('SR', 'Senior'),
        ('GR', 'Graduate'),
    )
```

### 元数据Meta

### 模型的继承

### 模型验证器