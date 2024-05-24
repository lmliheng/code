## 异常处理

方法一：约定返回错误码。

方法二：在语言层面上提供一个异常处理机制。
Java规定：
必须捕获的异常，包括Exception及其子类，但不包括RuntimeException及其子类，这种类型的异常称为Checked Exception。
不需要捕获的异常，包括Error及其子类，RuntimeException及其子类。