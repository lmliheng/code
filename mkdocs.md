## 欢迎
如需完整文档，请访问[mkdoc文档](https://mkdocs.org)

### 命令
- pip install mkdocs - pip安装mkdocs库
- mkdocs new [dir-name] - 创建一个新项目。
- mkdocs serve - 启动实时重新加载文档服务器。
- mkdocs build - 构建文档站点。
- mkdocs -h - 打印帮助信息并退出。
### 项目布局
    mkdocs.yml    # 配置文件
    docs/
        index.md  # 文档主页。
        ...       # 其他 Markdown 页面、图片和其他文件。

### mkdocs.yml基本配置
```
site_name: heng
site_author: HENG
site_url: 
use_directory_urls: false
nav:
  - 主页: index.md

theme: 
  name: material
  language: zh
  palette:
    scheme: default
    primary: deep orange
  features:
    - content.code.copy
    - content.code.select
  icon:
    repo: fontawesome/brands/github


extra:
  generator: false
  social:
    - icon: fontawesome/brands/pied-piper-alt
      link: http://home.liheng.work/
    - icon: fontawesome/brands/github
      link: https://github.com/lmliheng?tab=repositories

repo_url: https://github.com/lmliheng/codes
repo_name: Heng's Codes

copyright: Copyright 2024 Write By Heng 

markdown_extensions:
  - pymdownx.highlight:

      anchor_linenums: true
      anchor_linenums: true
      line_spans: __span
      pygments_lang_class: true
  - pymdownx.inlinehilite
  - pymdownx.snippets
  - pymdownx.superfences   

```  
