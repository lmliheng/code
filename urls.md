# 路由
### 命名空间
```
app_name = 'xxx' 
```
### 删除模板中硬编码的URLs

```
在polls/index.html文件中，还有一部分硬编码存在，也就是href里的“/polls/”部分：

<li><a href="/polls/{{ question.id }}/">{{ question.question_text }}</a></li>
它对于代码修改非常不利。设想如果你在urls.py文件里修改了路由表达式，那么你所有的模板中对这个url的引用都需要修改，这是无法接受的！

我们前面给urls定义了一个name别名，可以用它来解决这个问题。具体代码如下：

<li><a href="{% url 'detail' question.id %}">{{ question.question_text }}</a></li>
Django会在polls.urls文件中查找name='detail'的路由，具体的就是下面这行：

path('<int:question_id>/', views.detail, name='detail'),
举个栗子，如果你想将polls的detail视图的URL更换为polls/specifics/12/，那么你不需要在模板中重新修改url地址了，仅仅只需要在polls/urls.py文件中，将对应的正则表达式改成下面这样的就行了，所有模板中对它的引用都会自动修改成新的链接：

# 添加新的单词'specifics'
path('specifics/<int:question_id>/', views.detail, name='detail'),
```
### 路由设置范式
```python
from django.urls import path

from . import views

urlpatterns = [
    path('', views.index, name='index'),
]
```