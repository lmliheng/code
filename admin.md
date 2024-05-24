
### 管理员站点页面美化
###### 找到django文件路径
```
python -c "import django; print(django.__path__)"
```
###### 配置html模板找寻路径

在setting.py文件里TEMPLATES修改
```
TEMPLATES = [
    {'DIRS': [BASE_DIR / 'templates'], 
     }
]
```
###### 修改base_site.html
并将base_site.html模板复制到templates目录下

 ```
 admin后台是一个内置的app，本质上和你的polls是一样的
直接修改Django源码不是好的做法，所以我们不直接修改base_site.html模板
我们复制了一份模板，在其中修改了站点名字
为了让修改的模板能够自动替换原来的模板，我们创建了一个templates目录
这个新建的template目录之所以能起作用，是因为我们在settings中配置了一个DIRS。
当render需要base_site.html的时候，Django执行机制会首先去寻找DIRS中是否有base_site.html模板，结果找到了！于是它不再继续寻找，所以admin源码中的base_site.html模板被忽视了，成功达到了我们的目的。
 ```
### admin页面注册模型

```python
from django.contrib import admin
from .models import Choice

admin.site.register(Choice)
```

### 外键
 ```
Django在admin站点中，自动地将所有的外键关系展示为一个select框

 ```

