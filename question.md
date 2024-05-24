## FAQ
解释（未解决）和解决方案（已解决）

1) background.js:1  Uncaught (in promise) Error: Could not establish connection. Receiving end does not exist.

解释:这个错误信息表明在尝试建立连接时出现了问题。在这种情况下，接收端（可能是一个扩展、应用程序或服务）不存在或无法访问。这可能是由于以下原因之一：

接收端未正确安装或配置。
接收端的代码中存在错误，导致它无法正常运行。
网络问题，例如防火墙阻止了连接。
要解决此问题，您可以尝试以下方法：

检查接收端的安装和配置，确保它们正确无误。
检查接收端的代码，确保没有错误或遗漏的部分。
检查网络设置，确保没有防火墙或其他安全设置阻止了连接。


2) 客户端象django的服务器提交post请求时。会得到403，权限异常。因为django针对提交的请教，有校验。所以会如此。

解决办法：

导入模块：`from django.views.decorators.csrf import csrf_exempt`
在接收post请求的函数前面添加修饰器：`@csrf_exempt`

3) POST http://localhost:8000/api/add_book net::ERR_FAILED 200 (OK)