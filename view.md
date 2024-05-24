# 视图
Django的视图层包含下面一些主要内容：
 ```
URL路由
视图函数
快捷方式
装饰器
请求与响应
类视图
文件上传
CSV/PDF生成
内置中间件
 ```

 ```
 Django的视图类型可以分为函数视图和类视图，也就是FBV和CBV。
 大多数场景下，函数视图更简单易懂，代码量更少。
 但是在需要继承、封装某些视图的时候，CBV就能发挥优势。
 ```



### HTTP响应返回字符串
```python
from django.http import HttpResponse

def index(request):
    return HttpResponse("Hello, World!")
```


### 引入render函数
render函数来自django.shortcuts
```
from django.shortcuts import render

from .models import Question


def index(request):
    latest_question_list = Question.objects.order_by('-pub_date')[:5]
    context = {'latest_question_list': latest_question_list}
    return render(request, 'polls/index.html', context)
```    
### 返回错误
```
from django.http import HttpResponse, HttpResponseNotFound

def my_view(request):
    # ...
    if foo:
        return HttpResponseNotFound('<h1>Page not found</h1>')
    else:
        return HttpResponse('<h1>Page was found</h1>')
```
```
from django.http import HttpResponse

def my_view(request):
    # ...

    # Return a "created" (201) response code.
    return HttpResponse(status=201)
```
三、Http404异常
class django.http.Http404

当你返回错误，例如 HttpResponseNotFound ，你需要定义错误页面的 HTML 。

`return HttpResponseNotFound('<h1>Page not found</h1>')`
为了方便，Django 内置了 Http404 异常。（没有Http400、Http403等，只有这一个）

如果你在视图的任何地方引发了 Http404 ，Django 会捕捉到它并且返回标准的错误页面，连同 HTTP 错误代码 404 。
```
from django.http import Http404
from django.shortcuts import render
from polls.models import Poll

def detail(request, poll_id):
    try:
        p = Poll.objects.get(pk=poll_id)
    except Poll.DoesNotExist:
        raise Http404("Poll does not exist")  # 注意是raise，不是return
    return render(request, 'polls/detail.html', {'poll': p})
```    
为了在Django返回404时显示自定义的HTML，可以创建一个名为404.html的HTML模板，并将其放置在模板树的顶层。

只有当DEBUG设置为False时，此模板才会被自动使用。DEBUG为True表示开发模式，Django会展示详细的错误信息页面，而不是针对性的404页面。

实际上，当你raise了Http404后：

Django会首先读取django.conf.urls.handler404的值，默认为django.views.defaults.page_not_found()视图
执行page_not_found()视图
判断是否自定义了404.html，如果有，输出该HTML文件
如果没有，输出默认的404提示信息
上面的流程就给我们留下了两个自定义404页面的钩子：

第一个是在urls中重新指定handler404的值，也就是用哪个视图来处理404
第二个是在page_not_found视图中，使用自定义的404.html
一个是自定义处理视图，一个是自定义展示的404页面。

自定义的404.html页面应当位于模板引擎可以搜索到的路径。            

### 重定向
```
 return HttpResponseRedirect(reverse('polls:results', args=(question.id,)))
```
返回的是一个HttpResponseRedirect而不是先前我们常用的HttpResponse。HttpResponseRedirect需要一个参数：重定向的URL。这里有一个建议，当你成功处理POST数据后，应当保持一个良好的习惯，始终返回一个HttpResponseRedirect。这不仅仅是对Django而言，它是一个良好的WEB开发习惯。
参数to可以是：

一个模型实例：将调用模型的get_absolute_url()函数，反向解析出目的url；
URL的name名称：可能带有参数：reverse()将用于反向解析url；
一个绝对的或相对的URL：将原封不动的作为重定向的目标位置。
默认情况下是临时重定向，如果设置permanent=True将永久重定向。
 ```
 redirect()
redirect(to, args, permanent=False, *kwargs)

根据传递进来的url参数，返回HttpResponseRedirect。

参数to可以是：

一个模型实例：将调用模型的get_absolute_url()函数，反向解析出目的url；
URL的name名称：可能带有参数：reverse()将用于反向解析url；
一个绝对的或相对的URL：将原封不动的作为重定向的目标位置。
默认情况下是临时重定向，如果设置permanent=True将永久重定向。

范例：

1.调用对象的get_absolute_url()方法来重定向URL：
```
from django.shortcuts import redirect

def my_view(request):
    ...
    obj = MyModel.objects.get(...)
    return redirect(obj)
```    
2.传递URL的name名称，内部会自动使用reverse()方法反向解析url：
```
def my_view(request):
    ...
    return redirect('some-view-name', foo='bar')
```    
重定向到硬编码的URL：
```

def my_view(request):
    ...
    return redirect('/some/url/')
```    
重定向到一个完整的URL：
```
def my_view(request):
    ...
    return redirect('https://www.liujiangblog.com/')

#或者
def my_view(request):
    ...
    return redirect('/some/url/')
```    
所有上述形式都接受permanent参数，如果设置为True，将返回永久重定向：
```
def my_view(request):
    ...
    obj = MyModel.objects.get(...)
    return redirect(obj, permanent=True)
```    

### 类视图
如下例：

**app/urls.py**
```python
from django.urls import path

from . import views

app_name = 'polls'
urlpatterns = [
    path('', views.IndexView.as_view(), name='index'),
    path('<int:pk>/', views.DetailView.as_view(), name='detail'),
]
```  
**app/views.py**
```python
from django.http import HttpResponseRedirect
from django.shortcuts import get_object_or_404, render
from django.urls import reverse
from django.views import generic

from .models import Choice, Question


class IndexView(generic.ListView):
    template_name = 'polls/index.html'
    context_object_name = 'latest_question_list'

    def get_queryset(self):
        """Return the last five published questions."""
        return Question.objects.order_by('-pub_date')[:5]


class DetailView(generic.DetailView):
    model = Question
    template_name = 'polls/detail.html'
```    
 
### 视图装饰器
Django内置了一些装饰器，用来对视图函数进行一些控制。
```
require_http_methods()
```
此装饰器位于 django.views.decorators.http模块，用于限制可以访问该视图的HTTP方法。

如果请求的HTTP方法，不是指定的方法之一，则返回django.http.HttpResponseNotAllowed响应。

看例子：

```
from django.views.decorators.http import require_http_methods

@require_http_methods(["GET", "POST"])             # 注意参数的提供方式
def my_view(request):
    # 我们决定只有GET或者POST请求可以访问这个视图
    # ...
    pass
```
参数必须是大写字符串。

require_GET()
上面的狭隘版本，只允许GET请求访问。位于 django.views.decorators.http模块。

require_POST()
只允许POST请求访问。位于 django.views.decorators.http模块。

require_safe()
只允许安全的请求类型，也就是GET和HEAD访问。位于 django.views.decorators.http模块。

gzip_page()
对视图的响应内容进行压缩，如果浏览器支持。位于 django.views.decorators.gzip模块。

更多的装饰器如下所示，有兴趣的可以自行研究：

condition(etag_func=None, last_modified_func=None)
etag(etag_func)
last_modified(last_modified_func)
vary_on_cookie(func)
vary_on_headers(*headers)
cache_control()
never_cache(view_func)
### serve()视图
Django开发过程中，出了Python代码、前端静态文件，还有一类媒体文件，比如用户上传的图片、文件等等，统称为MEDIA。

这些MEDIA都是有用的资源，我们往往希望根据某个URL，从浏览器上直接获取它们，比如：

访问https://www.liujiangblog.com/logo.jpg，浏览器会显示logo图片
访问https://www.liujiangblog.com/document.doc，浏览器会自动下载document文档
这些功能，一般都是在代码上线后，通过类似Ngnix的Web服务器代理实现的。

为了方便在开发过程中，对MEDIA资源的使用和测试，Django内置了一个serve()视图，帮我们实现了同样的功能。

但是要谨记：serve()视图只能用于开发环境！

使用步骤：

首先，在根路由urls中添加下面的代码：
```
from django.conf import settings
from django.urls import re_path
from django.views.static import serve              # 以上三个导入不能忘

# ... 你原来的URLconf放这里...

if settings.DEBUG:
    urlpatterns += [
        re_path(r'^media/(?P<path>.*)$', serve, {
            'document_root': settings.MEDIA_ROOT,
        }),
    ]
然后：
```
确认settings.DEBUG配置项为True，也就是出于开发模式
在settings中添加下面的配置
```
MEDIA_URL = '/media/'
MEDIA_ROOT = '/media/'
```
如果是windows操作系统，在你的Django项目所在的盘符的根目录下，新建一个media文件夹，将你的MEDIA资源全部拷贝进去，比如c:\media或者d:\media等等。
启动开发服务器
访问类似127.0.0.1:8000/media/logo.jpg的地址可以看到图片
访问类似127.0.0.1:8000/media/blog.md的地址会自动下载blog.md文件

## HttpRequest对象


每当一个用户请求发送过来，Django将HTTP数据包中的相关内容，打包成为一个HttpRequest对象，并传递给视图函数作为第一位置参数，也就是request，供我们调用。

HttpRequest对象中包含了非常多的重要的信息和数据，应该熟练掌握它。

所有的请求和响应对象都位于`django.http`模块内。

一、属性
----

HttpRequest对象的大部分属性是只读的，除非特别注明。

#### 1\. HttpRequest.scheme

字符串类型，表示请求的协议种类，'http'或'https'。

#### 2\. HttpRequest.body

bytes类型，表示原始HTTP请求的正文。它对于处理非HTML形式的数据非常有用：二进制图像、XML等。如果要处理常规的表单数据，应该使用`HttpRequest.POST`。

还可以使用类似读写文件的方式从HttpRequest中读取数据，参见HttpRequest.read()。

### 3\. HttpRequest.path

字符串类型，表示当前请求页面的完整路径，但是不包括协议名和域名。例如："/music/bands/the_beatles/"。

这个属性，常被用于我们进行某项操作时，如果不通过，返回用户先前浏览的页面。非常有用！

### 4\. HttpRequest.path_info

在某些Web服务器配置下，主机名后的URL部分被分成脚本前缀部分和路径信息部分。`path_info` 属性将始终包含路径信息部分，不论使用的Web服务器是什么。使用它代替path可以让代码在测试和开发环境中更容易地切换。

例如，如果应用的WSGIScriptAlias设置为`/minfo`，那么`HttpRequest.path`等于`/music/bands/the_beatles/` ，而`HttpRequest.path_info`为`/minfo/music/bands/the_beatles/`。

### 5\. HttpRequest.method

字符串类型，表示请求使用的HTTP方法。默认为大写。 像这样：

if request.method == 'GET':
    do_something()
elif request.method == 'POST':
    do\_something\_else()

通过这个属性来判断请求的方法，然后根据请求的方法不同，在视图中执行不同的代码。

### 6\. HttpRequest.encoding

字符串类型，表示提交的数据的编码方式（如果为None 则表示使用`DEFAULT_CHARSET`设置）。 这个属性是可写的，可以通过修改它来改变表单数据的编码。任何随后的属性访问（例如GET或POST）将使用新的编码方式。

### 7\. HttpRequest.content_type

表示从`CONTENT_TYPE`头解析的请求的MIME类型。

### 8\. HttpRequest.content_params

包含在`CONTENT_TYPE`标题中的键/值参数字典。

### 9 HttpRequest.GET

一个类似于字典的对象，包含GET请求中的所有参数，也就是类似http://example.com/?name=jack&age=18之中的name=jack和age=18。 详情参考QueryDict文档。

### 10\. HttpRequest.POST

包含所有POST表单数据的键值对字典。 详情请参考QueryDict文档。 如果需要访问请求中的原始或非表单数据，可以使用`HttpRequest.body`属性。

注意：请使用`if request.method == "POST"`来判断一个请求是否POST类型，而不要使用`if request.POST`。

POST中不包含上传文件的数据。

### 11\. HttpRequest.COOKIES

包含所有Cookie信息的字典。 键和值都为字符串。可以类似字典类型的方式，在cookie中读写数据，但是注意cookie是不安全的，因此，不要写敏感重要的信息。

### 12\. HttpRequest.FILES

一个类似于字典的对象，包含所有上传的文件数据。 HttpRequest.FILES中的每个键为`<input type="file" name="" />`中的name属性值。 HttpRequest.FILES中的每个值是一个`UploadedFile`对象。

要在Django中实现文件上传，就要靠这个属性！

如果请求方法是POST且请求的`<form>`中带有`enctype="multipart/form-data"`属性，那么HttpRequest.FILES将包含上传的文件的数据。 否则，FILES将为一个空的类似于字典的对象，属于被忽略、无用的情形。

### 13\. HttpRequest.META

包含所有HTTP头部信息的字典。 可用的头部信息取决于客户端和服务器，下面是一些示例：

*   CONTENT_LENGTH —— 请求正文的长度（以字符串计）。
*   CONTENT_TYPE —— 请求正文的MIME类型。
*   HTTP_ACCEPT —— 可接收的响应`Content-Type`。
*   HTTP\_ACCEPT\_ENCODING —— 可接收的响应编码类型。
*   HTTP\_ACCEPT\_LANGUAGE —— 可接收的响应语言种类。
*   HTTP_HOST —— 客服端发送的Host头部。
*   HTTP_REFERER —— Referring页面。
*   HTTP\_USER\_AGENT —— 客户端的`user-agent`字符串。
*   QUERY_STRING —— 查询字符串。
*   REMOTE_ADDR —— 客户端的IP地址。想要获取客户端的ip信息，就在这里！
*   REMOTE_HOST —— 客户端的主机名。
*   REMOTE_USER —— 服务器认证后的用户，如果可用。
*   REQUEST_METHOD —— 表示请求方法的字符串，例如"GET" 或"POST"。
*   SERVER_NAME —— 服务器的主机名。
*   SERVER_PORT —— 服务器的端口（字符串）。

以上只是比较重要和常用的，还有很多未列出。

从上面可以看到，除`CONTENT_LENGTH`和`CONTENT_TYPE`之外，请求中的任何HTTP头部键转换为META键时，都会将所有字母大写并将连接符替换为下划线最后加上`HTTP_`前缀。所以，一个叫做`X-Bender`的头部将转换成META中的`HTTP_X_BENDER`键。

### 13.HttpRequest.headers

一个不区分大小写、类似dict的对象，包含请求中HTTP头部的所有信息。

你在访问的时候，可以不区分大小写。

>>> request.headers
{'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10\_12\_6', ...}

>>> 'User-Agent' in request.headers
True
>>> 'user-agent' in request.headers
True

>>> request.headers\['User-Agent'\]
Mozilla/5.0 (Macintosh; Intel Mac OS X 10\_12\_6)
>>> request.headers\['user-agent'\]
Mozilla/5.0 (Macintosh; Intel Mac OS X 10\_12\_6)

>>> request.headers.get('User-Agent')
Mozilla/5.0 (Macintosh; Intel Mac OS X 10\_12\_6)
>>> request.headers.get('user-agent')
Mozilla/5.0 (Macintosh; Intel Mac OS X 10\_12\_6)

在模板系统中，可以通过下面的方式访问：

{{ request.headers.user_agent }}

### 14\. HttpRequest.resolver_match

对请求中的URL进行解析，获取一些相关的信息，比如namespace。

在视图中通过request.resolver_match.namespace的方式访问。

二、app带来的属性
----------

下面的属性是app带来的：

### 1\. HttpRequest.current_app

表示当前app的名字。url模板标签将使用它的值作为`reverse()`方法的`current_app`参数。

### 2\. HttpRequest.urlconf

设置当前请求的根`URLconf`，用于指定不同的url路由进入口，这将覆盖settings中的`ROOT_URLCONF`设置。

将它的值修改为None，可以恢复使用`ROOT_URLCONF`设置。

### 3\. HttpRequest.exception\_reporter\_filter

用于替代当前请求的 `DEFAULT_EXCEPTION_REPORTER_FILTER` 。

### 4.HttpRequest.exception\_reporter\_class

用于替代当前请求的`DEFAULT_EXCEPTION_REPORTER`。

三、中间件带来的属性
----------

Django的contrib应用中包含的一些中间件会在请求上设置属性。

### 1\. HttpRequest.session

来自`SessionMiddleware`中间件：一个可读写的，类似字典的对象，表示当前会话。我们要保存用户状态，回话过程等等，靠的就是这个中间件和这个属性。

### 2\. HttpRequest.site

来自`CurrentSiteMiddleware`中间件：`get_current_site()`方法返回的Site或RequestSite的实例，代表当前站点是哪个。

Django是支持多站点的，如果你同时上线了几个站点，就需要为每个站点设置一个站点id。

### 3\. HttpRequest.user

来自`AuthenticationMiddleware`中间件：表示当前登录的用户的`AUTH_USER_MODEL`的实例，这个模型是Django内置的Auth模块下的User模型。如果用户当前未登录，则user将被设置为`AnonymousUser`的实例。

可以使用`is_authenticated`方法判断当前用户是否合法用户，如下所示：

if request.user.is_authenticated:
    ... \# Do something for logged-in users.
else:
    ... \# Do something for anonymous users.

四、方法
----

### 1\. HttpRequest.get_host()

根据`HTTP_X_FORWARDED_HOST`和`HTTP_HOST`头部信息获取请求的原始主机。 如果这两个头部没有提供相应的值，则使用`SERVER_NAME`和`SERVER_PORT`。

例如："127.0.0.1:8000"

注：当主机位于多个代理的后面，`get_host()`方法将会失败。解决办法之一是使用中间件重写代理的头部，如下面的例子：

class MultipleProxyMiddleware:
    FORWARDED\_FOR\_FIELDS = \[
        'HTTP\_X\_FORWARDED_FOR',
        'HTTP\_X\_FORWARDED_HOST',
        'HTTP\_X\_FORWARDED_SERVER',
    \]

    def \_\_init\_\_(self, get_response):
        self.get_response = get_response

    def \_\_call\_\_(self, request):
        """
 Rewrites the proxy headers so that only the most
 recent proxy is used.
 """
        for field in self.FORWARDED\_FOR\_FIELDS:
            if field in request.META:
                if ',' in request.META\[field\]:
                    parts = request.META\[field\].split(',')
                    request.META\[field\] = parts\[-1\].strip()
        return self.get_response(request)

### 2\. HttpRequest.get_port()

使用META中`HTTP_X_FORWARDED_PORT`和`SERVER_PORT`的信息返回请求的始发端口。

### 3\. HttpRequest.get\_full\_path()

返回包含完整参数列表的path。例如：`/music/bands/the_beatles/?print=true`

### 4\. HttpRequest.build\_absolute\_uri(location)

返回location的绝对URI形式。 如果location没有提供，则使用`request.get_full_path()`的值。

例如："https://example.com/music/bands/the_beatles/?print=true"

注：不鼓励在同一站点混合部署HTTP和HTTPS，如果需要将用户重定向到HTTPS，最好使用Web服务器将所有HTTP流量重定向到HTTPS。

### 5\. HttpRequest.get\_signed\_cookie(key, default=RAISE\_ERROR, salt='', max\_age=None)

从已签名的Cookie中获取值，如果签名不合法则返回django.core.signing.BadSignature。

可选参数salt用来为密码加盐，提高安全系数。 `max_age`参数用于检查Cookie对应的时间戳是否超时。

范例：

>>> request.get\_signed\_cookie('name')
'Tony'
>>> request.get\_signed\_cookie('name', salt='name-salt')
'Tony' \# assuming cookie was set using the same salt
>>> request.get\_signed\_cookie('non-existing-cookie')
...
KeyError: 'non-existing-cookie'
>>> request.get\_signed\_cookie('non-existing-cookie', False)
False
>>> request.get\_signed\_cookie('cookie-that-was-tampered-with')
...
BadSignature: ...
>>> request.get\_signed\_cookie('name', max_age=60)
...
SignatureExpired: Signature age 1677.3839159 > 60 seconds
>>> request.get\_signed\_cookie('name', False, max_age=60)
False

### 6\. HttpRequest.is_secure()

如果使用的是Https，则返回True，表示连接是安全的。

### 7\. HttpRequest.accepts(mime_type)

Django3.1新增。

如果请求头部接收的类型匹配mime_type参数，则返回True，否则返回False：

>>> request.accepts('text/html')
True

大多数浏览器默认的头部Accept设置是：`Accept: */*`，也就是说使用上面的accepts方法进行测试基本都会返回True。

### 8\. HttpRequest.read(size=None)

### 9\. HttpRequest.readline()

### 10\. HttpRequest.readlines()

### 11\. `HttpRequest.__iter__()`

上面的几个方法都是从HttpRequest实例读取文件数据的方法。

可以将HttpRequest实例直接传递到XML解析器，例如ElementTree：

import xml.etree.ElementTree as ET
for element in ET.iterparse(request):
    process(element)
