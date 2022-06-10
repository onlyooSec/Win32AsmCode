;By onlyooSec
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



	.data ;定义数据段
	
hInstance dd ?
hWinMain dd ?

	.const
	
szClassName db 'AWin',0
szTitleName db '...',0
szClassName1 db 'nima',0
	.code ; 代码段 
	
;window's pro

_ProcWinMain proc uses ebx esi edi,hWnd,wMsg,wParam,lParam
	LOCAL @stPs: PAINTSTRUCT
	LOCAL @hDc
	mov eax,wMsg
	
	.if eax == WM_PAINT
		invoke BeginPaint,hWnd,addr @stPs
		mov @hDc,eax
		invoke EndPaint,hWnd,addr @stPs
	.elseif eax == WM_CLOSE
		invoke DestroyWindow,hWnd
		invoke PostQuitMessage,0
	.else
		invoke DefWindowProc,hWnd,wMsg,wParam,lParam
		ret
	.endif
	xor eax,eax
	ret

_ProcWinMain endp


;Main
_WinMain proc 
	LOCAL @stWndClass: WNDCLASSEX
	LOCAL @stMsg:MSG
	;获取当前窗口实例
	invoke GetModuleHandle,NULL
	mov hInstance,eax
	
	invoke RtlZeroMemory,addr @stWndClass,sizeof @stWndClass
	;注册窗口类
	mov @stWndClass.cbSize, sizeof WNDCLASSEX
	push hInstance
	pop @stWndClass.hInstance
	mov @stWndClass.style, CS_HREDRAW or CS_VREDRAW
	mov @stWndClass.lpfnWndProc, offset _ProcWinMain
	mov @stWndClass.cbClsExtra, 0
	mov @stWndClass.cbWndExtra, 0
	invoke LoadIcon,0,IDI_WINLOGO
	mov @stWndClass.hIcon,eax
	mov @stWndClass.hIconSm, eax
	invoke LoadCursor,0,IDC_ARROW
	mov @stWndClass.hCursor,eax
	mov @stWndClass.hbrBackground,COLOR_WINDOW +1
	mov @stWndClass.lpszMenuName,NULL
	mov @stWndClass.lpszClassName,offset szClassName
	
	
	invoke RegisterClassEx,addr @stWndClass
	
	;创建窗口
	invoke CreateWindowEx,WS_EX_CLIENTEDGE,offset szClassName,offset szTitleName,WS_OVERLAPPEDWINDOW,\
	100,100,600,400,\
	NULL,NULL,hInstance,NULL
	mov hWinMain,eax
	invoke ShowWindow,hWinMain,SW_SHOWNORMAL
	invoke UpdateWindow,hWinMain
	
	;消息循环
	.while  TRUE
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
