# 本地开发命令
### 创建激活虚拟环境
```
python -m venv myenv
myenv\Scripts\activate
deactivate
```
### 使用requirement.txt
```
pip freeze > ./requirements.txt
pip install -r requirements.txt
```

### django-admin管理工具创建项目

```
 django-admin startproject HelloWorld
```
### 创建APP

```bash
 python manage.py startapp APP名
```
### 运行
```bash
python manage.py runserver 0.0.0.0:80
或者
python manage.py runserver
```

### 创建超级用户
```
python manage.py createsuperuser
```
### 生成迁移文件
```
python manage.py makemigrations
```
### 应用迁移文件实现迁移
```bash
python manage.py migrate
```

### 大致目录结构
```bash
django
└─ myproject
   ├─ db.sqlite3
   ├─ manage.py
   ├─ myproject
   │  ├─ asgi.py
   │  ├─ settings.py
   │  ├─ urls.py
   │  ├─ wsgi.py
   │  ├─ __init__.py
   │  └─ __pycache__
   │     ├─ settings.cpython-311.pyc
   │     ├─ urls.cpython-311.pyc
   │     ├─ wsgi.cpython-311.pyc
   │     └─ __init__.cpython-311.pyc
   └─ myapp
      ├─ admin.py
      ├─ apps.py
      ├─ models.py
      ├─ tests.py
      ├─ uris.py
      ├─ views.py
      ├─ __init__.py
      └─ migrations
         └─ __init__.py
```



