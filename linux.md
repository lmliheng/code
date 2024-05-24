## linux部署django笔记
### 坑点：
1.每个app都得有迁移入口文件 migrations/__init__.py
```
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

首先，确保您的系统已安装了 wget 和 tar 工具。如果没有，请使用以下命令安装它们：
`sudo yum install wget tar`
使用 wget 下载最新版本的 Python 源代码。您可以在 Python 官方下载页面 上找到最新版本的下载链接。例如，要下载 Python 3.11.0，请运行以下命令：
使用 curl 下载 Python 源代码：
`curl -O https://www.python.org/ftp/python/3.11.0/Python-3.11.0.tgz`
请注意，您可能需要根据最新版本的 Python 更改 URL。
如果您仍然遇到速度慢的问题，可以尝试使用国内的镜像源。例如，您可以使用阿里云的镜像源：
`wget https://mirrors.aliyun.com/python/3.11.0/Python-3.11.0.tgz`
或者使用腾讯云的镜像源：
`wget https://mirrors.cloud.tencent.com/python/3.11.0/Python-3.11.0.tgz`
`wget https://www.python.org/ftp/python/3.11.0/Python-3.11.0.tgz`
请注意，您可能需要根据最新版本的 Python 更改 URL。
解压下载的源代码文件：
`tar xvf Python-3.11.0.tgz`
进入解压后的目录：
`cd Python-3.11.0`
配置Python 3.11以准备编译：
`./configure --prefix=/opt/python3.11`
这将配置Python 3.11以便在/opt/python3.11目录中安装。您可以根据需要更改--prefix选项的值。
编译Python 3.11：
`make`
这将编译Python 3.11。编译过程可能需要一些时间，具体取决于您的系统性能。
安装Python 3.11：
`sudo make install`
这将将Python 3.11安装到之前配置的目录中。
将新安装的Python 3.11添加到PATH环境变量中。您可以通过将以下内容添加到您的.bashrc文件中来实现这一点：
`export PATH=/opt/python3.11/bin:$PATH`
然后，运行以下命令使更改生效：
`source ~/.bashrc`
现在，您应该可以使用新安装的Python 3.11了。要验证Python 3.11是否已成功安装并可以使用，请运行以下命令：
`python3.11 --versio`
使用cd命令导航到包含虚拟环境的目录。例如，如果您的虚拟环境位于/home/user/venv目录中，请运行以下命令：
`cd /home/user/venv`
激活虚拟环境。对于Python 3，您可以使用以下命令：
`source bin/activate`
这将激活虚拟环境，并将您的命令提示符更改为显示虚拟环境的名称。
现在，您已经激活了虚拟环境，可以在其中安装和使用Python包。要退出虚拟环境，请运行以下命令：
`deactivate`
是在虚拟环境中使用python3.11命令似乎不起作用。这是因为虚拟环境默认不会使用系统中安装的Python版本。要在虚拟环境中使用Python 3.11，您需要在创建虚拟环境时指定Python 3.11的路径。
首先，退出当前虚拟环境：
`deactivate`
然后，使用以下命令创建一个新的虚拟环境，并指定Python 3.11的路径：
`python3.11 -m venv venv`
这将使用Python 3.11创建一个名为venv的新虚拟环境。
接下来，激活新创建的虚拟环境：
`source venv/bin/activate`
现在，您应该可以在虚拟环境中使用Python 3.11了。要验证Python 3.11是否已成功安装并可以使用，请运行以下命令：
`python --version`
输出应显示Python 3.11的版本信息。请注意，在虚拟环境中，您可以使用python命令而不是python3.11来运行Python 3.11。这是因为虚拟环境会自动将python命令映射到指定的Python版本。



## 其他
增加执行权限：` chmod +x mysql_install.sh`

## 迁移mysql
```
MySQL服务器密码和数据库密码是两个不同的概念，它们分别用于不同的目的：
MySQL服务器密码：这是用于登录到MySQL服务器的root用户的密码。当您安装MySQL服务器并进行初始配置时，您需要设置此密码。您可以使用此密码登录到MySQL服务器，以便执行管理任务，例如创建新的数据库、用户和权限。MySQL服务器密码与特定数据库无关，它允许您访问整个MySQL服务器。
数据库密码：这是针对特定数据库用户的密码。在MySQL中，每个数据库用户都有一个与之关联的密码。当您为特定数据库创建用户并授予访问权限时，您需要为该用户设置密码。数据库密码仅允许该用户访问与其关联的数据库，而不是整个MySQL服务器。
这两种密码的主要区别在于它们的作用范围。MySQL服务器密码用于访问整个服务器，而数据库密码仅允许访问特定数据库。在实际应用中，通常会为不同的应用程序或服务创建不同的数据库用户，并为每个用户分配适当的权限和密码。这有助于提高安全性，因为即使某个用户的密码被泄露，攻击者也只能访问与该用户关联的数据库，而不是整个MySQL服务器。
```
检查MySQL是否已安装：`mysql --version`
检查MySQL服务是否正在运行：
对于基于Systemd的系统（如CentOS 7及更高版本、Ubuntu 16.04及更高版本）
`systemctl status mysqld`

对于基于SysVinit的系统（如CentOS 6、Ubuntu 14.04及更低版本）
`service mysqld status`
如果MySQL服务正在运行，您将看到类似于Active: active (running)的状态信息。如果服务未运行，您将看到类似于Active: inactive (dead)的状态信息。
如果MySQL服务未运行，您可以使用以下命令启动它：
对于基于Systemd的系统（如CentOS 7及更高版本、Ubuntu 16.04及更高版本）
`systemctl start mysqld`
对于基于SysVinit的系统（如CentOS 6、Ubuntu 14.04及更低版本）
`service mysqld start`
要检查MySQL服务是否正在监听端口（默认为3306），您可以使用netstat命令：
`netstat -tuln | grep 3306`
登录到MySQL服务器：
`mysql -u root -p`
在此命令中，-u参数指定要使用的用户名（在本例中为root），-p参数表示将提示输入密码。输入密码后，您将进入MySQL命令行界面。
创建一个新的数据库：
`CREATE DATABASE my_database;`
将my_database替换为您要创建的数据库名称。
选择要使用的数据库：
`USE my_database;`
将my_database替换为您要使用的数据库名称。
退出MySQL命令行界面：
`EXIT;`

如果您忘记了root用户的密码，可以通过以下步骤重置密码：
停止MySQL服务：
对于基于Systemd的系统（如CentOS 7及更高版本、Ubuntu 16.04及更高版本）
`sudo systemctl stop mysqld`

对于基于SysVinit的系统（如CentOS 6、Ubuntu 14.04及更低版本）
`sudo service mysqld stop`
启动MySQL服务，跳过权限检查：
`sudo mysqld_safe --skip-grant-tables &`
登录到MySQL服务器：
`mysql -u root`
重置root用户的密码：
`FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'new_password';`
将new_password替换为您要设置的新密码。
退出MySQL命令行界面：
`EXIT;`
停止跳过权限检查的MySQL服务：
`sudo killall mysqld`
重新启动MySQL服务：
对于基于Systemd的系统（如CentOS 7及更高版本、Ubuntu 16.04及更高版本）
`sudo systemctl start mysqld`
对于基于SysVinit的系统（如CentOS 6、Ubuntu 14.04及更低版本）
`sudo service mysqld start`
现在，您应该能够使用新密码登录到MySQL服务器：
`mysql -u root -p`
## uwsgi
如果你使用了虚拟环境，那么你必须使用虚拟环境的Python解释器安装uWSGI！也就是说，你的Django代码使用的哪个Python解释器，你的uWSGI服务器也必须使用同一个解释器。
解压文件
`tar -zxvf uwsgi `
进入解压目录
`sudo python3 setup.py install`
对于 CentOS/RHEL 系统：
`sudo yum install python3-devel`
安装完成后，重新编译 uWSGI。如果您已经编译过 uWSGI，请确保先清理之前的编译结果，然后重新编译。在 uWSGI 源码目录中执行以下命令：
`make clean`
`python3 setup.py install	`
编译完成后，您应该可以在虚拟环境中找到 uwsgi 命令。如果仍然找不到，请确保您的虚拟环境已激活，并检查 uwsgi 是否已安装在虚拟环境的 bin 目录中。如果不在那里，您可能需要将其添加到您的 PATH 环境变量中。例如：
`export PATH=$PATH:/path/to/your/virtualenv/bin`
将 /path/to/your/virtualenv 替换为实际的虚拟环境路径。然后，您应该能够运行 uwsgi 命令。

检查进程`ps aux | grep uwsgi`
杀死uwsgi进程
`sudo killall -9 uwsgi`
## settings配置
ALLOWED_HOSTS = ['plan.yunduanjianzhan.cn', 'www.plan.yunduanjianzhan.cn']

## linux安装djangorestframework
pip3 install -i https://pypi.org/simple/ djangorestframework



## 虚拟环境
创建虚拟环境：
在你的项目目录中，运行以下命令来创建一个虚拟环境。将myenv替换为你想要的环境名称：

对于Python 3.3及更高版本：
python -m venv myenv
对于Python 2.7：
virtualenv myenv
这将在当前目录下创建一个名为myenv的文件夹，其中包含Python解释器和库。

激活虚拟环境：
对于Windows：
myenv\Scripts\activate
对于macOS/Linux：
source myenv/bin/activate
激活虚拟环境后，你的命令提示符将显示环境名称，如下所示：

(myenv) $
在虚拟环境中安装库：
现在，你可以使用pip在虚拟环境中安装库，而不会影响系统全局的Python环境。例如：

pip install requests
使用虚拟环境：
在激活的虚拟环境中，你可以运行Python脚本、安装库或执行其他Python相关操作。

退出虚拟环境：
要退出虚拟环境，只需运行以下命令：

deactivate
这将恢复到系统全局的Python环境。

