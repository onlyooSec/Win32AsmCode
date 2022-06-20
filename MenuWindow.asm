.386
.model flat,stdcall
option casemap:none

include windows.inc
include kernel32.inc
include user32.inc
include gdi32.inc

includelib kernel32.lib
includelib user32.lib
includelib gdi32.lib

;定义菜单资源值
IDM_MAIN equ 10000



	.data?
hInstance dd ?
hWinMain dd ?
hMenu dd ?
	.const
szFormat db '您选择了菜单命令: %08x',0
szCaption db '菜单选择',0
szWindowName db 'WindowName0',0
szClassName db 'WindowsClass0',0
	.code
_DisplayMenuItem proc _dwCommandID
	LOCAL @szBuffer[256]:byte
	pushad
	invoke wsprintf,addr @szBuffer,offset szFormat,_dwCommandID
	invoke MessageBox,hWinMain,addr @szBuffer,offset szCaption,MB_OK
	popad
	ret

_DisplayMenuItem endp
_Quit proc 
	
	invoke DestroyWindow,hWinMain
	invoke PostQuitMessage,NULL
	ret

_Quit endp


_ProcWinMain proc uses ebx esi edi,hWnd,uMsg,wParam,lParam
	LOCAL @stPs:PAINTSTRUCT
	
	
	mov eax, uMsg
	.if eax == WM_CLOSE
		call _Quit
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
	LOCAL @stWndClass : WNDCLASSEX
	LOCAL @stMsg:MSG
	
	
	invoke GetModuleHandle,NULL
	mov hInstance, eax
	
	invoke LoadMenu,hInstance,IDM_MAIN
	mov hMenu, eax
	
	mov @stWndClass.cbSize,sizeof WNDCLASSEX
	mov @stWndClass.style,CS_HREDRAW or CS_VREDRAW
	mov @stWndClass.lpfnWndProc ,offset _ProcWinMain
	mov @stWndClass.cbClsExtra,0
	mov @stWndClass.cbWndExtra,0
	push hInstance
	pop @stWndClass.hInstance
	invoke LoadIcon,NULL,IDI_WINLOGO
	mov @stWndClass.hIcon,eax
	mov @stWndClass.hIconSm,eax
	invoke LoadCursor,NULL,IDC_IBEAM
	mov @stWndClass.hCursor,eax
	mov @stWndClass.hbrBackground,COLOR_WINDOW+1
	
	mov @stWndClass.lpszMenuName,NULL
	mov @stWndClass.lpszClassName,offset szClassName
	
	invoke RegisterClassEx,addr @stWndClass
	invoke CreateWindowEx,WS_EX_APPWINDOW,offset szClassName,offset szWindowName,\
	WS_OVERLAPPEDWINDOW,\
	100,100,400,600,NULL,hMenu,hInstance,NULL
	mov hWinMain, eax
	invoke ShowWindow,hWinMain,SW_SHOWNORMAL
	invoke UpdateWindow,hWinMain
	;消息循环
	
	.while TRUE
		invoke GetMessage,addr @stMsg,NULL,0,0
		.break .if eax == 0
		invoke TranslateMessage,addr @stMsg
		invoke DispatchMessage,addr @stMsg
	.endw
	
	ret

_WinMain endp

start:
	call _WinMain
	invoke ExitProcess,0
	end start
