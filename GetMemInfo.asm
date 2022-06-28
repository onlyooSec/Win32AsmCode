.386
.model flat,stdcall
option casemap:none

include windows.inc
include kernel32.inc
include user32.inc
include gdi32.inc
include comdlg32.inc

includelib comdlg32.lib
includelib kernel32.lib
includelib user32.lib
includelib gdi32.lib

	.data?
hWinMain dd ?	
hInstance dd ?

	.const
	
szInfo 	db '物理内存总数     %lu字节',0dh,0ah
	db '空闲物理内存     %lu字节',0dh,0ah
	db '虚拟内存总数     %lu字节',0dh,0ah
	db '空闲虚拟内存     %lu字节',0dh,0ah
	db '已用内存比例     %d%%',0dh,0ah
	db '-------------------------',0dh,0ah
	db '用户地址空间总数 %lu字节',0dh,0ah
	db '用户可用地址空间 %lu字节',0dh,0ah,0
szClassName db 'ClassName0',0
szWindowName db 'WindowName0',0
	.code

_GetMemInfo proc
	
	LOCAL @stMemInfo:MEMORYSTATUS
	LOCAL @szBuffer[1024]:byte
	
	mov @stMemInfo.dwLength,sizeof @stMemInfo
	invoke GlobalMemoryStatus,addr @stMemInfo
	invoke wsprintf,addr @szBuffer,addr szInfo,\
	@stMemInfo.dwTotalPhys,@stMemInfo.dwAvailPhys,\
	@stMemInfo.dwTotalPageFile,\
	@stMemInfo.dwAvailPageFile,\
	@stMemInfo.dwMemoryLoad,\
	@stMemInfo.dwTotalVirtual,@stMemInfo.dwAvailVirtual
	invoke SetDlgItemText,hWinMain,IDC_INFO,addr @szBuffer
	ret

_GetMemInfo endp

_ProcWinMain proc uses ebx esi edi,hWnd,uMsg,wParam,lParam
	
	LOCAL @stPs:PAINTSTRUCT
	
	
	mov eax,uMsg
	.if eax == WM_CLOSE
		invoke PostQuitMessage,NULL
		invoke DestroyWindow,hWnd
	.elseif eax == WM_PAINT
		invoke BeginPaint,hWnd,addr @stPs
		invoke EndPaint,hWnd,addr @stPs
	.else 
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam
	.endif
	
	ret

_ProcWinMain endp

_WinMain proc
	LOCAL @stWndClass:WNDCLASSEX
	LOCAL @stMsg:MSG
	
	invoke GetModuleHandle,NULL
	mov hInstance,eax
	
	mov @stWndClass.cbSize,sizeof @stWndClass
	mov @stWndClass.style,CS_HREDRAW or CS_VREDRAW
	mov @stWndClass.lpfnWndProc,offset _ProcWinMain
	mov @stWndClass.cbClsExtra,0
	mov @stWndClass.cbWndExtra,0
	mov @stWndClass.hInstance,hInstance
	invoke LoadIcon,NULL,IDI_WINLOGO
	mov @stWndClass.hIcon,eax
	mov @stWndClass.hIconSm,eax
	invoke LoadCursor,NULL,IDC_ARROW
	mov @stWndClass.hCursor,eax
	;xor eax,eax
	mov @stWndClass.hbrBackground,COLOR_WINDOW +1
	mov @stWndClass.lpszMenuName,NULL
	mov @stWndClass.lpszClassName,offset szClassName
	invoke RegisterClassEx,addr @stWndClass
	
	invoke CreateWindowEx,WS_EX_APPWINDOW,offset szClassName,offset szWindowName,WS_OVERLAPPEDWINDOW,100,100,300,400,NULL,NULL,hInstance,NULL
	mov hWinMain,eax
	
	invoke ShowWindow,hWinMain,SW_SHOWNORMAL
	invoke UpdateWindow,hWinMain
	
	.while TRUE
		invoke GetMessage,addr @stMsg,hWinMain,0,0
		.if eax == 0
			.break
		.endif
		invoke TranslateMessage,addr @stMsg
		invoke DispatchMessage,addr @stMsg
	.endw
	
	ret

_WinMain endp

start: 
	call _WinMain
	invoke ExitProcess,0
	end start
