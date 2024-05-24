## 文件上传

Django在处理文件上传时，文件数据会被打包封装在`request.FILES`中。

### 一、简单上传，手动保存

首先，写一个form模型，它必须包含一个`FileField`：

from django import forms

class UploadFileForm(forms.Form):
    title = forms.CharField(max_length=50)
    file = forms.FileField()

处理这个表单的视图将在`request.FILES`中收到文件数据，可以用`request.FILES['file']`来获取上传文件的具体数据，其中的键值`'file'`是根据`file = forms.FileField()`的变量名来的。

注意：`request.FILES`只有在请求方法为POST,并且提交请求的`<form>`具有`enctype="multipart/form-data"`属性时才有效。 否则，`request.FILES`将为空。

下面是一个接收上传文件的视图范例：

\# views.py

from django.http import HttpResponseRedirect
from django.shortcuts import render
from .forms import UploadFileForm

\# 另外写一个处理上传过来的文件的方法，并在这里导入
from somewhere import handle\_uploaded\_file

def upload_file(request):
    if request.method == 'POST':
        form = UploadFileForm(request.POST, request.FILES)
        if form.is_valid():
            handle\_uploaded\_file(request.FILES\['file'\])
            return HttpResponseRedirect('/success/url/')
    else:
        form = UploadFileForm()
    return render(request, 'upload.html', {'form': form})  \# 思考一下这个return语句是否可以缩进到else语句中呢？

请注意，必须将`request.FILES`传递到form的构造函数中。

form = UploadFileForm(request.POST, request.FILES)

下面是一个处理上传文件的方法的参考例子：

def handle\_uploaded\_file(f):
    with open('some/file/name.txt', 'wb+') as destination:
        for chunk in f.chunks():
            destination.write(chunk)

遍历`UploadedFile.chunks()`，而不是直接使用`read()`方法，能确保大文件不会占用系统过多的内存。

### 二、 使用模型处理上传的文件

如果是通过模型层的model来指定上传文件的保存方式的话，使用ModelForm更方便。 调用`form.save()`的时候，文件对象会保存在相应的`FileField`的`upload_to`参数指定的地方。

from django.http import HttpResponseRedirect
from django.shortcuts import render
from .forms import ModelFormWithFileField

def upload_file(request):
    if request.method == 'POST':
        form = ModelFormWithFileField(request.POST, request.FILES)
        if form.is_valid():
            \# 这么做就可以了，文件会被保存到Model中upload_to参数指定的位置
            form.save()
            return HttpResponseRedirect('/success/url/')
    else:
        form = ModelFormWithFileField()
    return render(request, 'upload.html', {'form': form})

如果手动构造一个对象，还可以简单地把文件对象直接从`request.FILES`赋值给模型：

from django.http import HttpResponseRedirect
from django.shortcuts import render
from .forms import UploadFileForm
from .models import ModelWithFileField

def upload_file(request):
    if request.method == 'POST':
        form = UploadFileForm(request.POST, request.FILES)
        if form.is_valid():
            instance = ModelWithFileField(file_field=request.FILES\['file'\])
            instance.save()
            return HttpResponseRedirect('/success/url/')
    else:
        form = UploadFileForm()
    return render(request, 'upload.html', {'form': form})

### 三、 同时上传多个文件

如果要使用一个表单字段同时上传多个文件，需要设置字段HTML标签的multiple属性为True，如下所示：

\# forms.py

from django import forms

class FileFieldForm(forms.Form):
    file_field = forms.FileField(widget=forms.ClearableFileInput(attrs={'multiple': True}))

然后，自己编写一个`FormView`的子类，并覆盖它的post方法，来处理多个文件上传：

\# views.py
from django.views.generic.edit import FormView
from .forms import FileFieldForm

class FileFieldView(FormView):
    form_class = FileFieldForm
    template_name = 'upload.html'  \# 用你的模版名替换.
    success_url = '...'  \# 用你的URL或者reverse()替换.

    def post(self, request, *args, **kwargs):
        form_class = self.get\_form\_class()
        form = self.get_form(form_class)
        files = request.FILES.getlist('file_field')
        if form.is_valid():
            for f in files:
                ...  \# 对每个文件做处理
            return self.form_valid(form)
        else:
            return self.form_invalid(form)

### 四、关于上传文件的处理器

当用户上传一个文件的时候，Django会把文件数据传递给上传文件处理器。

上传处理器的配置定义在`FILE_UPLOAD_HANDLERS`中，默认为：

\["django.core.files.uploadhandler.MemoryFileUploadHandler", "django.core.files.uploadhandler.TemporaryFileUploadHandler"\]

`MemoryFileUploadHandler`和`TemporaryFileUploadHandler`定义了Django的默认文件上传行为：将小文件读取到内存中，大文件放置在磁盘中。

你可以编写自己的 handlers 来自定义如何处理文件。比如，你可以使用自定义强制处理用户层面的配额，动态压缩数据，渲染进度条，甚至可以将数据发送到其他存储地址而不是本地。

在你保存上传文件之前，数据需要储存在某个地方。通常，如果上传文件小于2.5MB，Django会把整个内容存到内存。 这意味着，文件的保存仅仅涉及到内存中的读取和磁盘的写入，所以非常快。

但是，如果上传的文件很大，Django会把它写入一个临时文件，储存在你的系统临时目录中。在类Unix的平台下，Django会生成一个文件，名称类似于`/tmp/tmpzfp6I6.upload`。

### 五、动态修改上传处理器

有时候某些视图需要不同的上传行为。也就是说，在视图中动态修改处理器列表，即`request.upload_handlers`

比如，假设你正在编写 `ProgressBarUploadHandler` ，用来提供上传过程中的反馈。你需要添加这个处理程序到你的上传处理模块：

request.upload_handlers.insert(0, ProgressBarUploadHandler(request))

在这里使用 `list.insert()` （而不是 `append()` ），因为进度条处理程序需要在其他处理程序之前使用。

**记住，列表中的上传处理程序是按顺序处理的。**

如果你想完全替换掉先前的上传处理程序，只需要指定新列表：

request.upload_handlers = \[ProgressBarUploadHandler(request)\]

**你只能在访问 `request.POST` 或 `request.FILES` 之前修改上传处理程序**。开始上传动作后修改上传处理程序没有意义，并且Django 会报错。

而且，默认的， `CsrfViewMiddleware`中间件会访问`request.POST`。这意味着你需要在视图上使用 `csrf_exempt()` 来允许你改变上传处理程序。然后你需要在实际处理请求的函数上使用 `csrf_protect()` 。注意这可能会让处理程序在 CSRF 检测完成之前开始接受文件上传。如下所示：

from django.views.decorators.csrf import csrf_exempt, csrf_protect

@csrf_exempt
def upload\_file\_view(request):
    request.upload_handlers.insert(0, ProgressBarUploadHandler(request))
    return \_upload\_file_view(request)

@csrf_protect
def \_upload\_file_view(request):
    ... \# Process request

全局概念
----

在详细介绍Django对文件进行处理的功能之前，我们要了解一些它的基本概念、组织方式、使用套路、主要的类和继承关系。

如果你不了解这些，那么复杂的源码、交错的官方文档会让你陷入泥坑。不知道怎么用？什么时候用？用什么？为什么这么用？整个一团乱！

这些代码都位于`django.core.files`模块中，它们主要包括：

*   File的概念：Django对Python文件的封装。既可以用于文件上传过程中的处理，也可以单独使用
*   `File`类：Django实现File的基类
*   `ContentFile`类：继承了File类，不同之处是它处理的是字符串
*   `ImageFile` 类：继承了File类，添加了图像的宽度和长度像素值
*   `File`类的其它子类：实际上Django为`File`类还编写了一系列`Upload...`子类，只是使用较少。
*   File storage的概念：将Django的File对象保存到存储系统的API库，也就是Django如何将数据保存到硬盘中的。
*   `settings.DEFAULT_FILE_STORAGE`:一个Django配置项，用来指定默认的文件存储类。默认值为`'django.core.files.storage.FileSystemStorage'`，在`globa_settings`中。
*   `get_storage_class()`方法：Django提供的一个函数，通过字符串反射的方式获取指定的存储类或者`DEFAULT_FILE_STORAGE`设置的存储类
*   `DefaultStorage`类:对`get_storage_class()`方法返回的对象类的进一步封装
*   `default_storage`:`DefaultStorage`类的实例
*   `Storage`类：Django源码中所有存储类的基类，提供通用的接口API
*   `FileSystemStorage`：继承了`Storage`类，是Django原生实现的最重要、最常用、最普通的存储类。我们绝大多数时间实际使用的就是它！

File 对象
-------

Django设计了自己的文件对象。要记住，Django的File对象可以脱离本章的文件上传概念，独立使用！

### File 类

File 类是围绕Python原生file对象的轻度包装，添加了一些Django特有的东西。Django在内部使用File类的实例来表示文件对象。

每个File对象都包含下面的属性和方法：

*   name：文件名。包括`MEDIA_ROOT`定义的相对路径部分。
*   size：文件的尺寸，字节单位。
*   file：注意，这是File对象的file属性，不要搞混淆了！它表示File类封装的底层文件对象（Python文件对象）。
*   mode：文件的读/写模式
*   open(mode=None)：打开或者重新打开文件。mode参数和Python内置的open方法的参数一样。可以使用上下文管理器`with file.open() as f:`
    
*   `__iter__()`：遍历文件一次生成一行。
    
*   chunks(chunk_size=None)：遍历文件，分割成指定大小的“块”。`chunk_size` 默认为64 KB。这对于非常大的文件特别有用，因为它允许从磁盘流式传输，避免将整个文件存储在内存中。
    
*   multiple\_chunks(chunk\_size=None)：以指定的`chunk_size`进行测试，如果文件大到需要分割成多个数据块进行访问，则返回`True`，否则返回False。
    
*   close()：关闭文件
    

除以上属性和方法之外，还有下面的方法：

*   `encoding`
*   `fileno`
*   `flush`
*   `isatty`
*   `newlines`
*   `read`
*   `readinto`
*   `readline`
*   `readlines`
*   `seek`
*   `tell`
*   `truncate`
*   `write`
*   `writelines`,
*   `readable()`
*   `writable()`
*   `seekable()`

望文生义，它们都和Python原生的文件操作方法类似。

如果你想创建一个 `File` 实例，最简单的方法是使用 Python 内置的 `file` 对象：

>>> from django.core.files import File

\# 使用Python原生的open()方法
>>> f = open('/path/to/hello.world', 'w')
>>> myfile = File(f)

注意在这里创建的文件不会自动关闭。下面的方式可以用来自动关闭文件：

>>> from django.core.files import File

\# Create a Python file object using open() and the with statement
>>> with open('/path/to/hello.world', 'w') as f:
...     myfile = File(f)
...     myfile.write('Hello World')
...
>>> myfile.closed
True
>>> f.closed
True

如果文件在访问后没有关闭，可能会出现文件描述符溢出的风险。

OSError: \[Errno 24\] Too many open files

### ContentFile类

`ContentFile`类直接继承了`File`类，但是前者操作的是字符串或者字节内容，而不是确切的文件。例如：

from django.core.files.base import ContentFile

f1 = ContentFile("esta frase está en español")
f2 = ContentFile(b"these are bytes")

### ImageFile 类

Django为图片特别提供了一个内置类，也就是`django.core.files.images.ImageFile`，它也继承了File类。只是额外增加了两个属性：

*   width： 图片的像素宽度
*   height：图片的像素高度

比如下面的模型，使用 `ImageField` 来存储照片：

from django.db import models

class Car(models.Model):
    name = models.CharField(max_length=255)
    price = models.DecimalField(max_digits=5, decimal_places=2)
    photo = models.ImageField(upload_to='cars')

所有的 Car 实例都拥有一个 photo 属性，你可以使用它来获取照片的详细信息：

>>> car = Car.objects.get(name="57 Chevy")
>>> car.photo
<ImageFieldFile: cars/chevy.jpg>
>>> car.photo.name
'cars/chevy.jpg'
>>> car.photo.path      \# 图片在文件系统中的路径
'/media/cars/chevy.jpg'
>>> car.photo.url   \# 访问图片的url
'http://media.example.com/cars/chevy.jpg'

`car.photo` 其实是一个 `File` 对象，这意味着它拥有下面所描述的所有方法和属性。

可以通过将文件名设置为相对于文件存储位置的路径来更改文件名（如果你正在使用默认的 FileSystemStorage ，则为 MEDIA_ROOT ）。

>>> import os
>>> from django.conf import settings
>>> initial_path = car.photo.path
>>> car.photo.name = 'cars/chevy_ii.jpg'
>>> new_path = settings.MEDIA_ROOT + car.photo.name
>>> \# Move the file on the filesystem
>>> os.rename(initial_path, new_path)
>>> car.save()
>>> car.photo.path
'/media/cars/chevy_ii.jpg'
>>> car.photo.path == new_path
True

更多的 `ImageField` 使用例子：

>>> from PIL import Image
>>> car = Car.objects.get(name='57 Chevy')
>>> car.photo.width
191
>>> car.photo.height
287
>>> image = Image.open(car.photo)
\# 抛出ValueError异常。因为你在尝试打开已经关闭的文件

>>> car.photo.open()  \# 打开文件
<ImageFieldFile: cars/chevy.jpg>
>>> image = Image.open(car.photo)  \# 再次创建Image实例
>>> image
<PIL.JpegImagePlugin.JpegImageFile image mode=RGB size=191x287 at 0x7F99A94E9048>

另外，此时这个File对象会有两个附加的方法save和delete：

*   File.save（name，content，save = True）

使用提供的文件名和内容保存一个新的文件。这不会替换现有文件，但会创建一个新文件并更新该对象以指向该文件（也就是说保留外面那层用来封装的皮，把内部实际的文件内容替换掉）。如果save=True，将立刻执行模型的save方法。

>>> car.photo.save('myphoto.jpg', content, save=False)
>>> car.save()
\# 等同于
>>> car.photo.save('myphoto.jpg', content, save=True)

*   File.delete（save = True）

从模型实例中删除文件。如果save=True，删除文件后将立刻执行模型的save方法。

File storage 类
--------------

### 获取当前存储类

在本章的一开始，我们实现了一个简单的文件上传例子。用户从浏览器通过POST发送过来文件数据，Django通过`request.FILES`拿到数据，然后我们简单粗暴地使用Python语言原生的文件操作API将数据保存到了文件系统中，通常也就是硬盘中。

Django为了方便我们，提供了存储类，用来帮助我们将数据保存到存储器中，不需要手动调用open方法。

你在模型中可能看到过这样的写法：

file=models.FileField(storage='xxx',......)

其中的storage参数就是我们要指定的存储器类。如果你不指定这个参数，Django就会使用settings中配置的默认存储类进行处理。

所以，我们首先要知道`DEFAULT_FILE_STORAGE`配置项，它指定Django默认的存储类，默认值为`'django.core.files.storage.FileSystemStorage'`。一般情况下，我们无感静默使用，什么都不用做。

但是，Django总是千方百计为我们开后门，提供钩子。

Django额外又为我们提供了三种获取存储类的简便方法，用于在代码中动态修改要使用的存储类：

*   `get_storage_class`(import_path=None)

先看看它的源代码：

def get\_storage\_class(import_path=None):
    return import_string(import_path or settings.DEFAULT\_FILE\_STORAGE)

就两行！

它的作用是返回实现了存储API的存储类或者模块。

如果不提供参数，就使用`settings.DEFAULT_FILE_STORAGE`，也就是上面说的。

如果提供参数，Django将使用Python的字符串反射机制，获取对应的模块。

`get_storage_class`方法可以用在任何地方，它不属于任何类，是个独立函数。

*   `DefaultStorage`类

看看它的源代码：

class DefaultStorage(LazyObject):
    def _setup(self):
        self._wrapped = get\_storage\_class()()

三行！调用上面的`get_storage_class`方法并实例化，然后赋值给`_wrapped`，最后获得的就是`'django.core.files.storage.FileSystemStorage'`。

*   `default_storage`变量

源代码如下：

default_storage = DefaultStorage()

根本就是`DefaultStorage`的一个实例。所以，`from django.core.files.storage import default_storage`其实就是获得了一个`FileSystemStorage`对象。

看下面的例子：

>>> from django.core.files.base import ContentFile
>>> from django.core.files.storage import default_storage

\# 注意，这个save方法是有返回值的！返回值是文件在存储系统中的路径。可以通过这个路径再去查找文件。
>>> path = default_storage.save('path/to/file', ContentFile(b'new content'))
>>> path
'path/to/file'

>>> default_storage.size(path)
11
>>> default_storage.open(path).read()
b'new content'

>>> default_storage.delete(path)
>>> default_storage.exists(path)
False

### Storage类

Storage类是Django为我们提供的存储基类，实现了一些标准的API和一些可以被子类重写的默认行为。

name参数：文件名

*   `delete`(_name_)：删除指定名字的文件。如果子类没有实现这个方法，会弹出`NotImplementedError` 异常。
    
*   `exists`(_name_)： 如果文件已经存在，返回True，否则False
    
*   `get_accessed_time`(_name_): 返回上次访问该文件的时间，以`datetime`类型。如果子类没有实现这个方法，会弹出`NotImplementedError` 异常。
    
*   `get_alternative_name`(_file_root_, _file_ext_)：返回基于`file_root`和 `file_ext`参数的备用文件名，在扩展名之前，在文件名后附加一个下划线和一个随机的7个字符的字母数字字符串。3.0新增。
    
*   `get_available_name`(_name_, _max_length=None_)：据`name`参数返回自由可用的文件名。文件名的长度将不超过`max_length`（如果提供）。如果找不到自由的唯一文件名，则会引发`SuspiciousFileOperation`异常 。
    
*   `get_created_time`(_name_)： 返回文件的创建时间。如果子类没有实现这个方法，会弹出`NotImplementedError` 异常。
    
*   `get_modified_time`(_name_)：返回上次修改该文件的时间，以`datetime`类型。如果子类没有实现这个方法，会弹出`NotImplementedError` 异常。
    
*   `get_valid_name`(_name_)：根据`name`参数，返回一个在目标存储系统上可用的合法文件名。
    
*   `generate_filename`(_filename_)：验证并返回一个文件名。
    
*   `listdir`(_path_)： 列出指定path下的内容，然会一个列表的二元元组。第一个元素是目录列表，第二个元素是文件列表。如果子类没有实现这个方法，会弹出`NotImplementedError` 异常。
    
*   `open`(_name_, _mode='rb'_)：以指定的mode打开文件
    
*   `path`(_name_)：返回文件的路径，通过该路径可以使用Python原生的open()方法打开文件。如果子类没有实现这个方法，会弹出`NotImplementedError` 异常。
    
*   `save`(_name_, _content_, _max_length=None_)：保存文件。如果文件名已经存在，会自动修改生成合适的文件名。content参数必须是一个`django.core.files.File`的实例，或者可以被File包装的类文件对象。
    
*   `size`(_name_)：返回文件的大小，字节单位。如果子类没有实现这个方法，会弹出`NotImplementedError` 异常。
    
*   `url`(_name_)：返回URL，通过该URL可以访问文件的内容。如果子类没有实现这个方法，会弹出`NotImplementedError` 异常。
    

方法很多，不一定全要掌握，重点是下面这几个：

*   delete
*   exists
*   listdir
*   open
*   path
*   save
*   size
*   url

### FileSystemStorage 类

实际上，我们不直接使用Storage类，而是使用FileSystemStorage 类，这也是Django实现的唯一的本地文件系统存储类。

> `FileSystemStorage`（_location = None_，_base_url = None_，_file\_permissions\_mode = None_，_directory\_permissions\_mode = None_）

FileSystemStorage类直接继承了Storage类，并提供了下面的额外属性：

*   `location`： 存放文件的目录的绝对路径。默认为`MEDIA_ROOT`设置的值。
    
*   `base_url`： 用于访问文件的URL的基础前缀。默认为`MEDIA_URL`的值。
    
*   `file_permissions_mode`： 文件的系统权限。默认为`FILE_UPLOAD_PERMISSIONS`配置项的值。
    
*   `directory_permissions_mode`：目录的系统权限。默认为`FILE_UPLOAD_DIRECTORY_PERMISSIONS`配置项的值。
    

FileSystemStorage类实现了全套的我们在Storage类中介绍过的子类必须实现的方法。

但是要注意， `FileSystemStorage.delete()` 方法如果删除不存在的文件，不会引发异常。

下面的代码将上传文件存储到 `/media/photos` ，而不是你在 `MEDIA_ROOT` 中设置的路径：

from django.core.files.storage import FileSystemStorage
from django.db import models

\# 自定义存储路径
fs = FileSystemStorage(location='/media/photos')

class Car(models.Model):
    ...
    photo = models.ImageField(storage=fs)

Django 3.1开始，`FileSystemStorage.save()`方法支持使用`pathlib.Path`类，并且支持回调函数形式的storage参数，如下所示：

from django.conf import settings
from django.db import models
from .storages import MyLocalStorage, MyRemoteStorage

def select_storage():
    return MyLocalStorage() if settings.DEBUG else MyRemoteStorage()

class MyModel(models.Model):
    my_file = models.FileField(storage=select_storage)

这就赋予了我们在运行过程中，动态选择存储类的能力。

自定义Storage类
-----------

如果你需要自定义文件储存功能，比如把文件储存在远程系统中，你可以自己编写Storage类来实现这一功能。

实际上大多数情况下，对于本地磁盘存储，我们直接使用`FileSystemStorage`即可，对于别的需求，一般有第三方的存储类可用，在Django的生态库里查找即可。自己编写Storage类存在可靠性、可用性、安全性、性能问题，新手绕行，老手慎重。

但无论如何，这里还是给出基本的编写要求，以供参考：

第一：必须继承 `Django.core.files.storage.Storage`

from django.core.files.storage import Storage

class MyStorage(Storage):
    ...

第二：Django 必须能以无参数的状态，实例化你的存储系统。这意味着所有的设置项都应从 `dango.conf.settings` 中获取:

from django.conf import settings
from django.core.files.storage import Storage

class MyStorage(Storage):
    def \_\_init\_\_(self, option=None):
        if not option:
            option = settings.CUSTOM\_STORAGE\_OPTIONS
        ...

第三：在你的存储类中，除了其他自定义的方法外，还必须实现 `_open()` 以及 `_save()` 方法。另外，如果你的类提供了本地文件存储功能，还必须重写 `path()` 方法。

第四：你的存储类必须是 `deconstructible`可解构的，以便在迁移中的字段上使用它时可以序列化。

第五：尽量实现下列方法：

*   `Storage.delete()`
*   `Storage.exists()`
*   `Storage.listdir()`
*   `Storage.size()`
*   `Storage.url()`

举例来说，如果列出某些存储后端的内容的代价很昂贵，那么你可以不实现 `Storage.listdir()` 方法。

另一个例子是只处理写入文件的后端。在这种情况下，你不需要实现上述任何方法。

* * *

另外，下面是经常会用到专为自定义存储对象设计的两个钩子函数：

*   `_open`(_name_, _mode='rb'_)：真正执行打开文件功能的方法。它将被 `Storage.open()` 调用。
    
*   `_save`(_name_, _content_)：真正执行保存功能的方法。它将被 `Storage.save()`调用。
    
# 生成CSV文件


CSV (Comma Separated Values)，以纯文本形式存储数字和文本数据的存储方式。纯文本意味着该文件是一个字符序列，不含必须像二进制数字那样的数据。CSV文件由任意数目的记录组成，记录间以某种换行符分隔；每条记录由字段组成，字段间的分隔符是其它字符或字符串，最常见的是逗号或制表符。通常，所有记录都有完全相同的字段序列。

CSV最常用的场景就是数据分析和机器学习中源数据的载体。

要在Django的视图中生成CSV文件，可以使用Python的CSV库或者Django的模板系统来实现。

一、使用Python的CSV库
---------------

Python自带处理CSV文件的标准库csv。csv模块的CSV文件创建功能作用于类似于文件对象创建，并且Django的HttpResponse对象也是类似于文件的对象。

下面是个例子：

import csv
from django.http import HttpResponse

def some_view(request):
    \# Create the HttpResponse object with the appropriate CSV header.
    response = HttpResponse(content_type='text/csv')
    response\['Content-Disposition'\] = 'attachment; filename="somefilename.csv"'

    writer = csv.writer(response)
    writer.writerow(\['First row', 'Foo', 'Bar', 'Baz'\])
    writer.writerow(\['Second row', 'A', 'B', 'C', '"Testing"', "Here's a quote"\])

    return response

相关说明：

*   响应对象的MIME类型设置为`text/csv`，告诉浏览器，返回的是一个CSV文件而不是HTML文件。
*   响应对象设置了附加的`Content-Disposition`协议头，含有CSV文件的名称。文件名随便取，浏览器会在“另存为...”对话框等环境中使用它。
*   要在生成CSV的API中使用钩子非常简单：只需要把response作为第一个参数传递给`csv.writer`。`csv.writer`方法接受一个类似于文件的对象，而HttpResponse对象正好就是这么个东西。
*   对于CSV文件的每一行，调用`writer.writerow`，向它传递一个可迭代的对象比如列表或者元组。
*   CSV模板会为你处理各种引用，不用担心没有转义字符串中的引号或者逗号。只需要向writerow()传递你的原始字符串，它就会执行正确的操作。

当处理大尺寸文件时，可以使用Django的`StreamingHttpResponse`类，通过流式传输，避免负载均衡器在服务器生成响应的时候断掉连接，提高传输可靠性。

在下面的例子中，利用Python的生成器来有效处理大尺寸CSV文件的拼接和传输：
```
import csv

from django.http import StreamingHttpResponse

class Echo:
    """An object that implements just the write method of the file-like
 interface.
 """
    def write(self, value):
        """Write the value by returning it, instead of storing in a buffer."""
        return value

def some\_streaming\_csv_view(request):
    """A view that streams a large CSV file."""
    \# Generate a sequence of rows. The range is based on the maximum number of
    \# rows that can be handled by a single sheet in most spreadsheet
    \# applications.
    rows = (\["Row {}".format(idx), str(idx)\] for idx in range(65536))
    pseudo_buffer = Echo()
    writer = csv.writer(pseudo_buffer)
    response = StreamingHttpResponse((writer.writerow(row) for row in rows),
                                     content_type="text/csv")
    response\['Content-Disposition'\] = 'attachment; filename="somefilename.csv"'
    return response
```
二、使用Django的模板系统
---------------

也可以使用Django的模板系统来生成CSV。比起便捷的Python-csv库，这样做比较低级，不建议使用，这里只是展示一下有这种方式而已。

思路是，传递一个项目的列表给你的模板，并且让模板在for循环中输出逗号。下面是一个例子，它像上面一样生成相同的CSV文件：

from django.http import HttpResponse
from django.template import loader

def some_view(request):
    \# Create the HttpResponse object with the appropriate CSV header.
    response = HttpResponse(content_type='text/csv')
    response\['Content-Disposition'\] = 'attachment; filename="somefilename.csv"'

    \# The data is hard-coded here, but you could load it from a database or
    \# some other source.
    csv_data = (
        ('First row', 'Foo', 'Bar', 'Baz'),
        ('Second row', 'A', 'B', 'C', '"Testing"', "Here's a quote"),
    )

    t = loader.get_template('my\_template\_name.txt')
    c = {'data': csv_data}
    response.write(t.render(c))
    return response

然后，创建模板`my_template_name.txt`，带有以下模板代码：

{% for row in data %}"{{ row.0|addslashes }}", "{{ row.1|addslashes }}", "{{ row.2|addslashes }}", "{{ row.3|addslashes }}", "{{ row.4|addslashes }}"
{% endfor %}

生成PDF文件
=======

阅读: 28974     [评论](#comments)：3

* * *

可以通过开源的Python PDF库`ReportLab`来实现PDF文件的动态生成。

一、安装ReportLab
-------------

ReportLab库在PyPI上提供，可以使用pip来安装：

$ pip install reportlab

在Python交互解释器中导入它来测试安装：

>>> import reportlab

如果没有抛出任何错误，证明已安装成功。

二、编写视图
------

利用 Django 动态生成 PDF 的关键是 ReportLab API 作用于类文件对象，而 Django 的 `FileResponse` 对象接收类文件对象。

这有个 "Hello World" 示例:

import io
from django.http import FileResponse
from reportlab.pdfgen import canvas

def some_view(request):
    \# Create a file-like buffer to receive PDF data.
    buffer = io.BytesIO()

    \# Create the PDF object, using the buffer as its "file."
    p = canvas.Canvas(buffer)

    \# Draw things on the PDF. Here's where the PDF generation happens.
    \# See the ReportLab documentation for the full list of functionality.
    p.drawString(100, 100, "Hello world.")

    \# Close the PDF object cleanly, and we're done.
    p.showPage()
    p.save()

    \# FileResponse sets the Content-Disposition header so that browsers
    \# present the option to save the file.
    buffer.seek(0)
    return FileResponse(buffer, as_attachment=True, filename='hello.pdf')

相关说明：

*   MIME会自动设置为`application/pdf`。
*   将 `as_attachment=True` 传递给 `FileResponse` 时，表示这是一个可下载附件，它会设置合适的 `Content-Disposition` 头，告诉 Web 浏览器弹出一个对话框，提示或确认如何处理该文档，即便设备已配置默认行为。若省略了 `as_attachment` 参数，浏览器会用已配置的用于处理 PDF 的程序或插件来处理该 PDF。
*   你也可以提供可选参数 `filename`。浏览器的`“另存为…”`对话框会用到它。
*   注意，所有后续生成 PDF 的方法都是在 PDF 对象上调用的（本例中是 `p`）——而不是在 `buffer` 上调用。
*   最后，牢记在 PDF 文件上调用 `showPage()` 和 `save()`。
    
*   注意：ReportLab并不是线程安全的。
