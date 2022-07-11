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
IDC_STC1 equ 1002h
	.data?
hInstance dd ?
hDlg dd ?
	.const
szInfo 	db '物理内存总数     %lu字节',0dh,0ah
	db '空闲物理内存     %lu字节',0dh,0ah
	db '虚拟内存总数     %lu字节',0dh,0ah
	db '空闲虚拟内存     %lu字节',0dh,0ah
	db '已用内存比例     %d%%',0dh,0ah
	db '-------------------------',0dh,0ah
	db '用户地址空间总数 %lu字节',0dh,0ah
	db '用户可用地址空间 %lu字节',0dh,0ah,0
szT db '内存使用:',0
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
	invoke SetDlgItemText,hDlg,IDC_STC1,addr @szBuffer
	invoke MessageBox,NULL,addr @szBuffer,offset szT,MB_OK
	ret

_GetMemInfo endp

_ProcDlgMain proc uses ebx esi edi,hWnd,uMsg,wParam,lParam
	
	mov eax,uMsg
	.if eax == WM_CLOSE
		invoke EndDialog,hWnd,NULL
	.elseif eax == WM_INITDIALOG
		invoke LoadIcon,hInstance,IDI_WINLOGO
		invoke SendMessage,hWnd,WM_SETICON,ICON_BIG,eax
		call _GetMemInfo
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
	mov hDlg,eax
	invoke ExitProcess,NULL
	end start
