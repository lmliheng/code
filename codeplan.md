## 计划表
> Hello , 我是"小恒不会java"。考虑到django官网案例的代码对新手不太友好  
> 那我将一个案例从思路到代码都简单完整的摆出来，  
> 使用过django的各位可cv即可，不会django跟着走操作就能跑起来

### 项目展示

本案例在[GitHub](https://so.csdn.net/so/search?q=GitHub&spm=1001.2101.3001.7020)已经开源，可在后台自行设置计划

    https://github.com/lmliheng/plan
    

### 分析

建立模型：计划Plan,该表内有天数（标题）和具体实例  
[前端模板](https://so.csdn.net/so/search?q=%E5%89%8D%E7%AB%AF%E6%A8%A1%E6%9D%BF&spm=1001.2101.3001.7020)：我选取了GitHub上某开源的计划表前端项目，原生js  
创建视图函数：通过路由映射至模板文件

### 上手

##### 基本环境

python3.5以上，django5以上，集成开发环境（我推荐vscode)

##### 创建django项目(根目录）

    django-admin startproject HelloWorld
    

HelloWorld是根目录名，这是django-admin管理工具创建项目  
此时目录结构如下  
───HelloWorld/  
│ ├───manage.py  
│ ├───HelloWorld/  
│ │ │ ├───asgi.py  
│ │ │ ├───settings.py  
│ │ │ ├───urls.py  
│ │ │ ├───wsgi.py  
│ │ │ ├───\_\_init\_\_.py  
具体知识还是得看官方文档，我在此只是带头写项目

##### 创建应用

    python manage.py startapp APP名
    

此时目录结构  
├───HelloWorld/  
│ ├───manage.py  
│ ├───codeplan/  
│ │ ├───admin.py  
│ │ ├───apps.py  
│ │ ├───models.py  
│ │ ├───tests.py  
│ │ ├───views.py  
│ │ ├───\_\_init\_\_.py  
│ │ ├───migrations/  
│ │ │ ├───\_\_init\_\_.py  
│ ├───HelloWorld/  
│ │ ├───asgi.py  
│ │ ├───settings.py  
│ │ ├───urls.py  
│ │ ├───wsgi.py  
│ │ ├───\_\_init\_\_.py  
│ │ ├───\_\_pycache\_\_/  
│ │ │ ├───settings.cpython-311.pyc  
│ │ │ ├───\_\_init\_\_.cpython-311.pyc

##### 设置settings.py

找到HelloWolrd/HelloWorld/settings.py.增加’codeplan’,以及增加static设置，并导入os模块

    INSTALLED_APPS = [
        'django.contrib.admin',
        'django.contrib.auth',
        'django.contrib.contenttypes',
        'django.contrib.sessions',
        'django.contrib.messages',
        'django.contrib.staticfiles',
    
        'codeplan',
    ]
    

    import os
    STATIC_URL = 'static/'
     #在模板中调用static函数时，会自动帮你在路径前补全'/static/'
    STATICFILES_DIRS = (
        os.path.join(BASE_DIR, 'static'),
    )
    
    

##### 创建模型

在HelloWolrd/codeplan/models.py下创建模型

    from django.db import models
    
    # Create your models here.
    
    
    class Plan(models.Model):
        title = models.CharField(max_length=10)
        one = models.CharField(max_length=20)
        two = models.CharField(max_length=20)
        three = models.CharField(max_length=20)
        four = models.CharField(max_length=20)
        five = models.CharField(max_length=20)
        six = models.CharField(max_length=20)
        seven = models.CharField(max_length=20)
        
    
        def __str__(self):
            return self.title
    

##### 书写视图函数

在HelloWolrd/codeplan/views.py下创建模型

    from django.shortcuts import render
    
    # Create your views here.
    
    from django.http import HttpResponse
    from .models import Plan
    
    def index(request):
        plans = Plan.objects.all()
        
        return render(request, 'index.html', {'plans': plans})
    

##### 路由配置

在HelloWorld/HelloWorld/urls.py下

    from django.contrib import admin
    from django.urls import path,include
    
    urlpatterns = [
        path('admin/', admin.site.urls),
        path('codeplan/', include('codeplan.urls')),
    ]
    

在HelloWorld/codeplan下创建urls.py，并写入

    from django.urls import path,include
    from . import views
    
    app_name = 'codeplan'
    
    urlpatterns = [
        path('', views.index, name='codeplan'),
    ]
    

##### 静态资源

在根目录HelloWorld下创建文件夹static

##### 模板文件

在codeplan下创建templates文件夹  
在GitHub里面拉取静态资源和模板文件


##### 跑通项目

###### 迁移数据

    python manage.py makemigrations
    python manage.py migrate
    

###### 创建管理员账号，提示在输入密码时不会显示密码，直接输入即可

    python manage.py createsuperuser
    

###### 启动

    python manage.py runserver
    

###### 访问

http://127.0.0.1/admin进入管理员登陆界面  
http://127.0.0.1/codeplan进入主页

 

