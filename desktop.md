### Java Swing

Swing提供许多比AWT更好的屏幕显示元素
JFrame – java的GUI程序的基本思路是以JFrame为基础，它是屏幕上window的对象，能够最大化、最小化、关闭。
JPanel – Java图形用户界面(GUI)工具包swing中的面板容器类，包含在javax.swing 包中，可以进行嵌套，功能是对窗体中具有相同逻辑功能的组件进行组合，是一种轻量级容器，可以加入到JFrame窗体中。。
JLabel – JLabel 对象可以显示文本、图像或同时显示二者。可以通过设置垂直和水平对齐方式，指定标签显示区中标签内容在何处对齐。默认情况下，标签在其显示区内垂直居中对齐。默认情况下，只显示文本的标签是开始边对齐；而只显示图像的标签则水平居中对齐。
JTextField –一个轻量级组件，它允许编辑单行文本。
JPasswordField – 允许我们输入了一行字像输入框，但隐藏星号(*) 或点创建密码(密码)
JButton – JButton 类的实例。用于创建按钮类似实例中的 "Login"。

### AWT
AWT 是 Java 中最早的 GUI 工具包，它提供了一组基础的 GUI 组件和窗口管理器，可以用于创建简单的 GUI 应用程序
Swing 是 Java 的一个扩展包，包含了丰富的 GUI 组件，用于创建图形用户界面。
Swing 组件以 “J” 开头，例如 JFrame、JButton 等。与 AWT 相比，Swing 组件更加轻量级，具有更好的可定制性、可移植性和可扩展性。


### JavaFX
JavaFX 是 Java 的第三个 GUI 工具包

### SwingWorker
GUI 多线程编程 —— SwingWorker
在 GUI 编程中，长时间运行的任务会阻塞 GUI 线程，导致 GUI 不响应
