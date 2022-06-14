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

	.data 
hInstance dd ? ;程序模块句柄
hWinMain dd ? ;窗口句柄
szBuffer db 1024 dup (?)
	
	.const
szClassName db 'Win0',0 ; 窗口类名
szWindowName db 'Window0',0 ;窗口名字
szCaption db '..a MessageBox',0
	.code
_ProcWinMain proc uses ebx esi edi,hWnd,uMsg,wParam,lParam
	LOCAL @stPs:PAINTSTRUCT
	LOCAL pCopyData ;COPYDATASTRUCT结构的地址
	LOCAL @hDc
	LOCAL @stRect:RECT
	mov eax, uMsg
	.if eax == WM_PAINT
		invoke BeginPaint,hWnd,addr @stPs
		mov @hDc,eax
		invoke EndPaint,hWnd,addr @stPs
	.elseif eax == WM_CLOSE
		invoke DestroyWindow,hWnd
		invoke PostQuitMessage,0
	.elseif eax == WM_COPYDATA
		push lParam
		pop pCopyData
		mov esi, pCopyData
		assume esi: ptr COPYDATASTRUCT ;设esi为结构指针
		invoke wsprintf,addr szBuffer,[esi].lpData
		assume esi: nothing
		invoke MessageBox,NULL,addr szBuffer,addr szCaption,MB_OK
	.else
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam
		ret
	.endif
	
	xor eax, eax
	ret

_ProcWinMain endp

_WinMain proc 
	LOCAL @stWndClass:WNDCLASSEX
	LOCAL @stMsg:MSG
	invoke GetModuleHandle,NULL
	mov hInstance,eax
	mov @stWndClass.cbSize,sizeof WNDCLASSEX
	mov @stWndClass.style,CS_HREDRAW or CS_VREDRAW
	mov @stWndClass.lpfnWndProc,offset _ProcWinMain
	mov @stWndClass.cbClsExtra,0
	mov @stWndClass.cbWndExtra,0
	push hInstance
	pop @stWndClass.hInstance
	invoke LoadIcon,NULL,IDI_WINLOGO
	mov @stWndClass.hIcon,eax
	mov @stWndClass.hIconSm,eax
	invoke LoadCursor,NULL,IDC_ARROW
	mov @stWndClass.hCursor,eax
	mov @stWndClass.hbrBackground,COLOR_WINDOW
	mov @stWndClass.lpszMenuName,NULL
	mov @stWndClass.lpszClassName,offset szClassName
	
	invoke RegisterClassEx,addr @stWndClass
	invoke CreateWindowEx,WS_EX_APPWINDOW,offset szClassName,\
	offset szWindowName,WS_OVERLAPPEDWINDOW,\
	100,100,400,600,NULL,NULL,hInstance,NULL
	mov hWinMain,eax
	
	invoke ShowWindow,hWinMain,SW_SHOWNORMAL
	invoke UpdateWindow,hWinMain
	
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
