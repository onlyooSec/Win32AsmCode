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
