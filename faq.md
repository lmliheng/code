### 包路径
注意java代码里面的包名
```bash
C:\Users\李恒\Desktop\code\java\本地网络检查>javac InternetDemo
错误: 仅当显式请求注释处理时才接受类名称 'InternetDemo'
1 个错误
```

### 资源文件路径异常
问题出在ImageIcon的初始化上。NullPointerException表明在尝试创建ImageIcon时，传递给它的URL为null。这通常是因为资源文件没有正确加载。
解决：`java -cp .;C:\Users\李恒\Desktop\code\java\GUI\resources SimpleCodeEditorTwo`
```bash
C:\Users\李恒\Desktop\code\java\GUI>java SimpleCodeEditorTwo
Exception in thread "AWT-EventQueue-0" java.lang.NullPointerException
        at javax.swing.ImageIcon.<init>(Unknown Source)
        at ImageIconExample.<init>(SimpleCodeEditorTwo.java:36)
        at SimpleCodeEditorTwo.createAndShowGUI(SimpleCodeEditorTwo.java:14)
        at SimpleCodeEditorTwo.lambda$main$0(SimpleCodeEditorTwo.java:9)
        at java.awt.event.InvocationEvent.dispatch(Unknown Source)
        at java.awt.EventQueue.dispatchEventImpl(Unknown Source)
        at java.awt.EventQueue.access$500(Unknown Source)
        at java.awt.EventQueue$3.run(Unknown Source)
        at java.awt.EventQueue$3.run(Unknown Source)
        at java.security.AccessController.doPrivileged(Native Method)
        at java.security.ProtectionDomain$JavaSecurityAccessImpl.doIntersectionPrivilege(Unknown Source)
        at java.awt.EventQueue.dispatchEvent(Unknown Source)
        at java.awt.EventDispatchThread.pumpOneEventForFilters(Unknown Source)
        at java.awt.EventDispatchThread.pumpEventsForFilter(Unknown Source)
        at java.awt.EventDispatchThread.pumpEventsForHierarchy(Unknown Source)
        at java.awt.EventDispatchThread.pumpEvents(Unknown Source)
        at java.awt.EventDispatchThread.pumpEvents(Unknown Source)
        at java.awt.EventDispatchThread.run(Unknown Source)

C:\Users\李恒\Desktop\code\java\GUI>
```

### 颜色提示
```bash
C:\Users\李恒\Desktop\code\java\GUI>java CodeEditorWithSnippets
libpng warning: iCCP: known incorrect sRGB profile
libpng warning: iCCP: known incorrect sRGB profile
```