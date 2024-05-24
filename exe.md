### PyInstaller
PyInstaller 是一个用于将 Python 应用程序转换为独立可执行文件的第三方打包工具
```bash
pyinstaller --name=连点器 --onefile --icon=./favicon.ico --noconsole 连点器.py
```
-F 选项可以打出一个exe文件，默认是 -D，意思是打成一个文件夹。
-w 选项可以打桌面程序，去掉命令行黑框
-i 可以设置图标路径，将图标放在根目录

### nuitka
```bash
pip install nuitka
```
注意使用 Nuitka 要在虚拟环境中使用,项目一定都要是英文路径
例如，具体参数参见文档或者询问AI
```bash
nuitka --mingw64 --show-progress --standalone --disable-console --enable-plugin=pyside6 --plugin-enable=numpy --onefile --remove-output camera.py 
```

### 服务器端应用程序
比如web服务器等