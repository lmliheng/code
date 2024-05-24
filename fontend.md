## 单体架构和前后端分离区别

**前后端分离优点:**

1. **并行开发：** 前后端可以独立开发、测试，提高开发效率，特别适合大型项目和跨地域的团队协作。
2. **技术栈灵活：** 前端可以选择React、Vue、Angular等现代框架，后端可以专注于API开发，双方技术选型更加自由。
3. **可扩展性和维护性：** 模块化设计使得系统更易于扩展和维护，每个部分都可以独立升级或替换。
4. **优化用户体验：** 客户端渲染能够提供更丰富的交互体验，且对于动态内容加载和局部刷新更为高效。

**前后端分离缺点:**
. **SEO优化难题：** 纯前端渲染的应用可能对搜索引擎不友好，虽然有SSR（Server Side Rendering）等技术缓解，但增加了实施复杂度。
3. **逻辑分散：** 前后端分离可能导致业务逻辑分散，需要良好的API设计和文档来管理。
4. **网络延迟和性能问题：** 前端需要通过API调用后端数据，可能会增加首次加载时间和后续的网络请求延迟。



## 解决跨域问题
安装django-cors-headers中间件：
```bash
pip install django-cors-headers
```
在settings.py中添加corsheaders到INSTALLED_APPS：
```python
INSTALLED_APPS = [
    # ...
    'corsheaders',
    # ...
]
```
在settings.py中添加CORS_ORIGIN_ALLOW_ALL设置：
```python
CORS_ORIGIN_ALLOW_ALL = True
```
在settings.py中添加`corsheaders.middleware.CorsMiddleware`到`MIDDLEWARE`中间件：
```python
MIDDLEWARE = [
    # ...
    'corsheaders.middleware.CorsMiddleware',
    # ...
]
```

## API开发基础
### 重点
HTTP method
Path
Headers
Media types
Authentication
Parameters
### 序列化与反序列化

将程序中的一个数据结构类型转换为其他格式（字典、JSON、XML等），例如将Django中的模型类对象装换为JSON字符串，这个转换过程我们称为序列化。

如：

queryset = BookInfo.objects.all()
book_list = []
# 序列化
```python
for book in queryset:
    book_list.append({
        'id': book.id,
        'btitle': book.btitle,
        'bpub_date': book.bpub_date,
        'bread': book.bread,
        'bcomment': book.bcomment,
        'image': book.image.url if book.image else ''
    })
return JsonResponse(book_list, safe=False)
```
反之，将其他格式（字典、JSON、XML等）转换为程序中的数据，例如将`JSON`字符串转换为`Django`中的模型类对象，这个过程我们称为反序列化。

如：
```python
json_bytes = request.body
json_str = json_bytes.decode()

# 反序列化
book_dict = json.loads(json_str)
book = BookInfo.objects.create(
    btitle=book_dict.get('btitle'),
    bpub_date=datetime.strptime(book_dict.get('bpub_date'), '%Y-%m-%d').date()
)
```
我们可以看到，在开发REST API时，视图中要频繁的进行序列化与反序列化的编写。
在开发REST API接口时，我们在视图中需要做的最核心的事是：
将数据库数据序列化为前端所需要的格式，并返回；
将前端发送的数据反序列化为模型类对象，并保存到数据库中。

### HTTP method
#### 请求结构
在 HTTP 协议中，一个完整的请求通常由几个部分组成，包括请求行（Request Line）、请求头（Headers）、空行（一个CRLF，即回车换行符）以及可选的请求体。

特别地，当客户端需要向服务器发送数据时，比如在 POST、PUT、PATCH 等方法的请求中，请求体就变得非常重要。它通常包含表单数据、JSON 对象、多部分表单数据（用于文件上传）、XML 数据等格式的信息。

例如，在进行表单提交时，如果使用的是 application/x-www-form-urlencoded 编码类型，请求体可能看起来像这样：
```application
username=JohnDoe&password=123456
```
如果是发送 JSON 数据，请求体可能是这样的：
```json
{
    "username": "JohnDoe",
    "email": "johndoe@example.com"
}
```
请求体的内容和格式依赖于请求的内容类型（Content-Type）头部字段所指定的媒体类型。服务器端会根据这个类型解析请求体，以便正确处理客户端发送的数据。
```
Network
Request Headers
Response Headers
Response Body
```

#### 请求类型
常用的HTTP动词有下面四个(括号里是对应的SQL命令)。
GET (SELECT):从服务器取出资源(一项或多项)。
POST (CREATE):在服务器新建一个资源。
PUT (UPDATE):在服务器更新资源(客户端提供改变后的完整资源)。
DELETE (DELETE):从服务器删除资源。
还有三个不常用的HTTP动词。
PATCH (UPDATE):在服务器更新(更新)资源(客户端提供改变的属性)。 HEAD:获取资源的元数据。
OPTIONS:获取信息，关于资源的哪些属性是客户端可以改变的。



#### 如何发起请求

比如在在浏览器的地址栏输入URL（如http://127.0.0.1:8000/api/add_book）并按下回车键会发起GET请求。如果GET请求用于创建资源，这将违背REST架构风格的原则

#### CSRF
跨站请求伪造（CSRF）是一种广泛存在的网络攻击手段。与另一常见的攻击手段XSS（跨站脚本攻击）相比，CSRF并不试图窃取用户的数据，而是欺骗用户执行未授权的操作。这种攻击方式利用了web应用中用户会话的一个漏洞，让攻击者可以伪装成信任的用户来执行某些操作。考虑一下，如果你不小心点击了一个恶意链接，那么你可能会在不知情的情况下执行了一些不应该执行的操作，例如转账、更改密码等。

##### 简单解释
CSRF 令牌（Token）是一种防御CSRF攻击的策略。令牌是一个随机生成的字符串，通常在用户会话中与用户关联。当用户执行敏感操作时，服务器将检查请求中的令牌是否与会话中的令牌匹配。只有当令牌匹配时，服务器才会处理该请求

##### 需求场景模拟
让我们深入一个具体场景来了解CSRF令牌的工作原理。

场景描述：在线银行转账

假设你正在使用一个在线银行应用进行转账操作。这个应用已经进行了登录验证，服务器知道你是一个合法的用户。现在，你想转一笔钱给你的朋友。

步骤 1：登录和获取CSRF令牌

你登录银行网站，输入用户名和密码。服务器验证了你的身份后，会生成一个CSRF令牌，并将其存储在你的会话中。同时，该令牌也会作为隐藏字段嵌入到转账表单中。

步骤 2：填写转账表单

你填写了转账金额和朋友的银行账号。由于CSRF令牌已经嵌入到表单中，当你提交表单时，令牌也会一同发送到服务器。

步骤 3：服务器验证CSRF令牌

服务器收到转账请求后，会检查请求中的CSRF令牌是否与你会话中的令牌匹配。如果匹配，服务器会处理转账请求。如果不匹配，请求将被拒绝。

对比：没有CSRF令牌的情况

假设有一位攻击者知道转账的URL和参数。如果没有CSRF令牌，攻击者可以创建一个伪造的转账链接，并诱使你点击。一旦你点击了该链接，转账就会在你不知情的情况下发生。

但有了CSRF令牌，攻击者无法得知正确的令牌值，因此无法创建有效的伪造请求。


#### GET请求
```python
# GET请求示例view.py
from django.http import HttpResponse


def test_request(request):
    print('path info is : ', request.path_info)
    print('method is : ', request.method)
    print('querystring is : ', request.GET)
    print('full path is :', request.get_full_path())
    print('客户端IP is :', request.META['REMOTE_ADDR'])

    return HttpResponse('test request ok')
```

