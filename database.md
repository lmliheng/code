# 数据库
## 使用不同数据库
### sqlite
sqlite是内置数据库，不需要安装任何第三方库，属于setings.py初始化配置·(如果使用则不用修改)
```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}
```
### Mysql
安装第三方库pymysql，并修改settings.py中的SQL配置
```python
import pymysql
pymysql.install_as_MySQLdb()
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'two',
        'USER': 'two',  # 用户名，可以自己创建用户
        'PASSWORD': '13551458597a',  # 密码
        'HOST': '8.134.79.236',  # mysql服务所在的主机ip
        'PORT': '3306',
    }
}
```


## 查询
想要从数据库内检索对象，你需要基于模型类，通过管理器（Manager）操作数据库并返回一个查询结果集（QuerySet）。

每个QuerySet代表一些数据库对象的集合。它可以包含零个、一个或多个过滤器（filters）。Filters缩小查询结果的范围。在SQL语法中，一个QuerySet相当于一个SELECT语句，而filter则相当于WHERE或者LIMIT一类的子句。

每个模型至少具有一个Manager，默认情况下，Django自动为我们提供了一个，也是最常用最重要的一个，99%的情况下我们都只使用它。它被称作objects，可以通过模型类直接调用它，但不能通过模型类的实例调用它，以此实现“表级别”操作和“记录级别”操作的强制分离。

### 检索所有对象
使用all()方法，可以获取某张表的所有记录。
```python
all_entries = Entry.objects.all()
```
### 过滤方法
有两种方法可以用来过滤`QuerySet`的结果，分别是：

`filter(**kwargs)`：返回一个根据指定参数查询出来的`QuerySet`
`exclude(**kwargs)`：返回除了根据指定参数查询出来结果的`QuerySet`
其中，`**kwargs`参数的格式必须是Django设置的一些字段格式。

例如要获取2020年的所有文章：
```
Entry.objects.filter(pub_date__year=2020)
```
`链式过滤`
```
>>> Entry.objects.filter(
...     headline__startswith='What'
... ).exclude(
...     pub_date__gte=datetime.date.today()
... ).filter(
...     pub_date__gte=datetime(2020, 1, 30)
... )
```
`检索单一对象`
```
>>> one_entry = Entry.objects.get(pk=1)
```
`QuerySet的切片`
使用类似Python对列表进行切片的方法可以对QuerySet进行范围取值
```
>>> Entry.objects.all()[:5]      # 返回前5个对象
>>> Entry.objects.all()[5:10]    # 返回第6个到第10个对象
```

### 字段查询