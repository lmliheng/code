```java
// -*- coding: utf-8 -*- q


import java.net.InetAddress;
import java.net.UnknownHostException;

public class InternetDemo {
    public static void main(String[] args) {
        /*
         * InetAddress类，用于构造IP地址对象
         * */
        try {
            // 获取本地主机IP地址对象
            InetAddress localHost = InetAddress.getLocalHost();
            System.out.println(localHost); //主机名/主机IP地址

            // 根据IP地址或者主机名获得对应的IP地址对象
            InetAddress byName = InetAddress.getByName("www.baidu.com");
            System.out.println(byName); //www.baidu.com/220.181.38.149

            // 获得主机名
            String hostName = localHost.getHostName();
            // 获得IP地址
            String hostAddress = localHost.getHostAddress();
            System.out.println(hostName);
            System.out.println(hostAddress);

        } catch (UnknownHostException e) {
            throw new RuntimeException(e);
        }
    }
}
```
```java
import java.net.*;
import java.io.*;
public class ConnectTester {
  public static void main(String args[]){
    String host="localhost";
    int port=25;
    if(args.length>1){
        host = args[0];
        port=Integer.parseInt(args[1]);
    }
    new ConnectTester().connect(host,port);
  }
  public void connect(String host,int port){
    SocketAddress remoteAddr=new InetSocketAddress(host,port);
    Socket socket=null;
    String result="";
    try {
        long begin=System.currentTimeMillis();
        socket = new Socket();
        socket.connect(remoteAddr,1000);  
        long end=System.currentTimeMillis();
        result=(end-begin)+"ms";  
    }catch (BindException e) {
        result="Local address and port can't be binded";
    }catch (UnknownHostException e) {
        result="Unknown Host";
    }catch (ConnectException e) {
        result="Connection Refused";
    }catch (SocketTimeoutException e) {
        result="TimeOut";
    }catch (IOException e) {
        result="failure";
    } finally {
        try {
            if(socket!=null)socket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    System.out.println(remoteAddr+" : "+result);
  }
}
```
```java
try {
    Socket socket = new Socket("example.com", 12345);
    // 与服务器进行通信的代码
} catch (UnknownHostException e) {
    System.out.println("无法解析主机名");
} catch (SocketTimeoutException e) {
    System.out.println("连接超时");
} catch (ConnectException e) {
    System.out.println("连接被拒绝或服务器未响应");
} catch (IOException e) {
    System.out.println("发生I/O错误");
}
```
请注意，socket连接异常如上都是IOException的子类。在处理异常时，你可以选择捕获IOException，这将同时捕获所有与I/O相关的异常。
但是，如果你需要对不同类型的异常进行不同的处理，你应该分别捕获它们。

### 代码片段编辑器


```java
import javax.swing.*;
import javax.swing.text.*;
import java.awt.*;
import java.awt.event.KeyAdapter;
import java.awt.event.KeyEvent;
import java.util.HashMap;
import java.util.Map;

public class CodeEditorWithSnippets {
    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> createAndShowGUI());
    }

    private static void createAndShowGUI() {
        // 创建主窗体
        JFrame frame = new JFrame("代码编辑器（带代码片段）");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setSize(800, 600);

        // 创建一个滚动面板以容纳文本区域，以便在内容超出时可以滚动查看
        JScrollPane scrollPane = new JScrollPane();
        frame.add(scrollPane, BorderLayout.CENTER);

        // 创建一个文本区域用于编辑代码
        JTextArea textArea = new JTextArea();
        textArea.setFont(new Font("Monospaced", Font.PLAIN, 14)); // 使用等宽字体，更适合代码编辑
        scrollPane.setViewportView(textArea);

        // 创建代码片段映射
        Map<String, String> codeSnippets = new HashMap<>();
        codeSnippets.put("c", "public class HelloWorld {\n" +
                "    public static void main(String[] args) {\n" +
                "        System.out.println(\"Hello, World!\");\n" +
                "    }\n" +
                "}\n");
        codeSnippets.put("f", "public class HelloWorld {\n" +
                "    public static void main(String[] args) {\n" +
                "        System.out.println(\"Hello, World!\");\n" +
                "    }\n" +
                "}\n");

        // 为文本区域添加键盘监听器
        textArea.addKeyListener(new KeyAdapter() {
            @Override
            public void keyPressed(KeyEvent e) {
                if (e.getKeyChar() == KeyEvent.VK_SPACE) {
                    int caretPosition = textArea.getCaretPosition();
                    try {
                        String prefix = textArea.getText(caretPosition - 1, 1);
                        String codeSnippet = codeSnippets.get(prefix);
                        if (codeSnippet != null) {
                            textArea.replaceRange("", caretPosition - 1, caretPosition);
                            textArea.insert(codeSnippet, caretPosition - 1);
                        }
                    } catch (BadLocationException ex) {
                        ex.printStackTrace();
                    }
                }
            }
        });

        // 显示窗口
        frame.setVisible(true);
    }
}
```
