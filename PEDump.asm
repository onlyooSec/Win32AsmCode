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
IDC_INFO equ 5000h

	.data?
hRichEdit dd ?
hInstance dd ?
hWinMain dd ?
hMenu dd ?
hWinEdit dd ?
szFileName db MAX_PATH dup(?)

	.data 
szFont db '宋体',0

	.const

szTest db 'TestBox',0
szClassEdit db 'RichEdit20A',0
szDllEdit db 'RichEd20.dll',0


	.code 

_init proc 
	LOCAL @stCf:CHARFORMAT
	
	invoke LoadMenu,hInstance,IDM_MAIN
	mov hMenu,eax
	
	invoke GetDlgItem,hWinMain,IDC_INFO
	mov hWinEdit,eax
	
	invoke LoadIcon,hWinMain,IDI_WINLOGO
	invoke SendMessage,hWinMain,WM_SETICON,ICON_BIG,eax
	
	invoke SendMessage,hWinEdit,EM_SETTEXTMODE,TM_PLAINTEXT,0
	
	invoke RtlZeroMemory,addr @stCf,sizeof @stCf
	
	mov @stCf.cbSize,sizeof @stCf
	mov @stCf.yHeight,9*20
	mov @stCf.dwMask,CFM_FACE or CFM_SIZE or CFM_BOLD
	
	invoke lstrcpy,addr @stCf.szFaceName,addr szFont
	
	invoke SendMessage,hWinEdit,EM_SETCHARFORMAT,0,addr @stCf
	
	invoke SendMessage,hWinEdit,EM_EXLIMITTEXT,0,-1
	
	invoke MessageBox,NULL,offset szTest,offset szTest,MB_OK
	
	ret

_init endp


_ProcDlgMain proc uses ebx edi esi,hWnd,uMsg,wParam,lParam
	mov eax,uMsg
	
	.if eax == WM_CLOSE
		invoke EndDialog,hWnd,NULL
		
	.elseif eax == WM_INITDIALOG
		push hWnd
		pop hWinMain
		;call _init
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

	invoke LoadLibrary,offset szDllEdit
	mov hRichEdit,eax
	invoke GetModuleHandle,NULL
	mov hInstance,eax
	invoke DialogBoxParam,hInstance,DLG_MAIN,NULL,offset _ProcDlgMain,NULL
	invoke FreeLibrary,hRichEdit
	invoke ExitProcess,NULL
	end start
