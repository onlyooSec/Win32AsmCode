# Win32AsmCode

编译、链接、资源编写使用 masm32 sdk工具包 ml.exe,link.exe,rc.exe
编译工具 ml.exe
链接器 link.exe 
资源编译器 rc.exe
开发使用ide ： RadASM
常用编译命令 ： win+R -> cmd -> cd xxx.asm path
编译：ml /c /coff xxx.asm 使用这条命令生成.obj文件，->
链接：link /subsystem:windows xxx.obj,->
生成xxx.exe


0x0:think and do 缺一不可
0x1:hack for hack

0x10:
win32汇编使用编译器、链接器,masm32sdk 软件包
编译命令：ml /c /coff /Cp xx.asm   
链接命令: link /subsystem:windows xx.obj yy.lib zz.res

0x11:
-pure 忽略安装参数
taskkill /f /im "Nox.exe" 杀死进程

radmasm shift+f2 查找并替换

0x12:
窗口程序：
.break .if eax == 0

0x13:
lpszClassName是窗口类的其中一个字段，通过将该字段赋值，
创建窗口的时候引用该值才能利用到注册的窗口类。

0x14:
数据表示：0x.......代表地址 ......h是数据

0x15:
消息定义：WM_USER 的定义是400h，自定义消息的时候可以WM_USER + 1,WM_USER +2 .......

0x16
结构体访问：指针偏移方式
mov esi,offset stWndClass
mov eax,[esi + WNDCLASS.lpfnWndProc] 
结构体指针方式
mov esi,offset stWndClass
assume esi:ptr WNDCLASS
mov eax,[esi].lpfnWndProc
assume esi:nothing

0x17:
offset & addr 指令区别
.const 内容只能使用offset
局部变量只能使用addr
addr 之前必须定义
offset: 只能全局变量使用，适用于任何位置的全局变量，.const数据必须使用
addr:适用于除.const外且在调用addr之前的全局变量，以及在调用addr之前的局部变量

0x18:

