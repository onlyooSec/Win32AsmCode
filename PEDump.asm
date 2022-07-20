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



DLG_MAIN equ 1000h
IDM_MAIN equ 2000h
IDM_OPEN equ 2001h
IDM_EXIT equ 2002h
IDM_1 equ 4001h



	.data 

hInstance dd ?
hWinMain dd ?
hMenu dd ?
	.const

szTest db 'TestBox',0

	.code 

_init proc 
	LOCAL @szBuffer[1024]:byte
	
	invoke LoadMenu,hInstance,IDM_MAIN
	mov hMenu,eax
	
	invoke MessageBox,NULL,offset szTest,offset szTest,MB_OK
	
	ret

_init endp


_ProcDlgMain proc uses ebx edi esi,hWnd,uMsg,wParam,lParam
	mov eax,uMsg
	
	.if eax == WM_CLOSE
		invoke EndDialog,hWnd,NULL
		
	.elseif eax == WM_INITDIALOG
		call _init
		invoke LoadIcon,hInstance,IDI_WINLOGO
		invoke SendMessage,hWnd,WM_SETICON,ICON_BIG,eax
	.elseif eax == WM_COMMAND
		mov eax,wParam
		.if ax == IDOK
			invoke EndDialog,hWnd,NULL
		.endif
	.else 
		mov eax,FALSE
		ret
	.endif
	mov eax,TRUE
	ret
_ProcDlgMain endp

start:
	invoke GetModuleHandle,NULL
	mov hInstance,eax
	invoke DialogBoxParam,hInstance,DLG_MAIN,NULL,offset _ProcDlgMain,NULL
	invoke ExitProcess,NULL
	end start
