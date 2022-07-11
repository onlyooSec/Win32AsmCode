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

IDD_DLG1 equ  1000h
IDC_EDT1 equ  1001h

	.data?
hInstance dd ?

	.code
	
_ProcDlgMain proc uses ebx esi edi,hWnd,uMsg,wParam,lParam
	
	mov eax,uMsg
	.if eax == WM_CLOSE
		invoke EndDialog,hWnd,NULL
	.elseif eax == WM_INITDIALOG
		invoke LoadIcon,hInstance,IDI_WINLOGO
		invoke SendMessage,hWnd,WM_SETICON,ICON_BIG,eax
	.elseif eax == WM_COMMAND
		mov eax,wParam
		.if eax == IDOK
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
	mov hInstance ,eax
	invoke DialogBoxParam,hInstance,IDD_DLG1,NULL,offset _ProcDlgMain,NULL
	invoke ExitProcess,NULL
	end start
