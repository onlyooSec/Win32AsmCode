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

	.data 

hInstance dd ?
hWinMain dd ?
szBuffer byte 1024 dup (?)

	.const
szClassName db 'Window0',0
szWindowName db 'MyWindow',0
szText db 'for hack',0
szCaptionMain db 'a MessageBox',0
szReceive db 'Receive WM_SETTEXT message',0dh,0ah
	  db 'param: %08x',0dh,0ah
	  db 'text: "%s" ',0dh,0ah,0



	.code
	
_ProcWinMain proc uses ebx esi edi,hWnd,uMsg,wParam,lParam
	
	LOCAL @stPs:PAINTSTRUCT
	LOCAL @hDc
	LOCAL @stRect:RECT
	
	mov eax, uMsg
	.if eax == WM_PAINT	
		invoke BeginPaint,hWnd,addr @stPs
		mov @hDc,eax
		invoke GetClientRect,hWnd,addr @stRect
		invoke DrawText,@hDc,offset szText,-1,addr @stRect,\
		DT_VCENTER or DT_CENTER
		invoke EndPaint,hWnd,addr @stPs
	.elseif eax == WM_CLOSE
		invoke DestroyWindow,hWnd
		invoke PostQuitMessage,NULL
	.elseif eax == WM_SETTEXT
		invoke wsprintf,addr szBuffer,addr szReceive,lParam,lParam
		invoke MessageBox,hWnd,offset szBuffer,addr szCaptionMain,MB_OK
	.else
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam
		ret
	.endif
	xor eax,eax
	ret

_ProcWinMain endp

_WinMain proc 
	LOCAL @stWndClass:WNDCLASSEX
	LOCAL @stMsg:MSG
	
	
	
	invoke GetModuleHandle,NULL
	mov hInstance,eax
	invoke RtlZeroMemory,addr @stWndClass,sizeof @stWndClass
	
	
	mov @stWndClass.cbSize,sizeof WNDCLASSEX
	mov @stWndClass.style,CS_HREDRAW or CS_VREDRAW
	mov @stWndClass.lpfnWndProc,offset _ProcWinMain
	mov @stWndClass.cbClsExtra, 0
	mov @stWndClass.cbWndExtra, 0
	push hInstance
	pop @stWndClass.hInstance
	invoke LoadIcon,0,IDI_WINLOGO
	mov @stWndClass.hIcon,eax
	mov @stWndClass.hIconSm,eax
	invoke LoadCursor,0,IDC_ARROW
	mov @stWndClass.hCursor,eax
	mov @stWndClass.hbrBackground,COLOR_WINDOW +1
	mov @stWndClass.lpszMenuName,0
	mov @stWndClass.lpszClassName,offset szClassName
	
	invoke RegisterClassEx,addr @stWndClass
	invoke CreateWindowEx,WS_EX_APPWINDOW,offset szClassName,\
	offset szWindowName,WS_OVERLAPPEDWINDOW,100,100,400,600,NULL,NULL,hInstance,NULL
	mov hWinMain, eax
	
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
