.386
.model flat,stdcall
option casemap:none

 
include windows.inc
include user32.inc
include kernel32.inc
include gdi32.inc
includelib user32.lib
includelib kernel32.lib
includelib gdi32.lib

ICO_MAIN equ 1000h
IDM_MAIN equ 2000h
IDM_OPEN equ 4000h

	.data?

hInstance dd ? ;当前程序模块句柄
hWinMain dd ? ;主窗口句柄
hMenu dd ? ;菜单句柄

	.const
	
szClassName db 'WinClass',0
szWinMainName db 'Window',0

	.code
	
	

_ProcWinMain proc uses ebx esi edi,hWnd,uMsg,wParam,lParam
	
	LOCAL @stPs:PAINTSTRUCT
	
	mov eax, uMsg
	.if eax == WM_CLOSE
		invoke DestroyWindow,hWnd
		invoke PostQuitMessage,NULL
	.elseif eax == WM_PAINT
		invoke BeginPaint,hWnd,addr @stPs
		invoke EndPaint,hWnd,addr @stPs
	.else 
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam
		ret
	.endif
	xor eax,eax	
	ret

_ProcWinMain endp

_WinMain proc 
	
	LOCAL @uMsg:MSG
	LOCAL @stWC:WNDCLASSEX

	;注册窗口类
	invoke GetModuleHandle,NULL
	mov hInstance,eax
		
	;加载菜单资源
	invoke LoadMenu,hInstance,IDM_MAIN
	mov hMenu,eax
	
	
	mov @stWC.cbSize,sizeof WNDCLASSEX
	mov @stWC.style,CS_HREDRAW or CS_VREDRAW
	mov @stWC.lpfnWndProc,offset _ProcWinMain
	mov @stWC.cbClsExtra,0
	mov @stWC.cbWndExtra,0
	push hInstance
	pop @stWC.hInstance
	invoke LoadIcon,hInstance,IDI_WINLOGO
	mov @stWC.hIcon,eax
	mov @stWC.hIconSm,eax
	invoke LoadCursor,NULL,IDC_ARROW
	mov @stWC.hCursor,eax
	xor eax,eax
	mov @stWC.hbrBackground,COLOR_WINDOW+1
	mov @stWC.lpszMenuName,NULL
	mov @stWC.lpszClassName,offset szClassName
	
	invoke RegisterClassEx,addr @stWC
	
	;注册窗口类完成
	
	invoke CreateWindowEx,WS_EX_APPWINDOW,\
	offset szClassName,offset szWinMainName,\
	WS_OVERLAPPEDWINDOW,\
	100,100,600,400,\
	NULL,hMenu,hInstance,NULL
	
	mov hWinMain,eax
	
	invoke UpdateWindow,hWinMain
	
	invoke ShowWindow,hWinMain,SW_SHOWNORMAL
	
	;消息循环
	
	.while TRUE
		
		invoke GetMessage,addr @uMsg,NULL,0,0
		
		.break .if eax == 0
			
		invoke TranslateMessage,addr @uMsg
		
		invoke DispatchMessage,addr @uMsg
		
	.endw
	
	ret

_WinMain endp

start: 	
	call _WinMain
	invoke ExitProcess,NULL
	end start
