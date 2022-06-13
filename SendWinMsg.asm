;这个文件是用来向ReceptionWinMsg.asm 程序的窗口发送消息的
;试想怎么向另一个地址空间的窗口发送消息，传递数据呢?
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
hWnd dd ?
szBuffer db 256 dup (?)

	.const
szCaption db 'SendMessage',0
szStart db 'Press Ok to start SendMessage, param: %08x1',0
szReturn db 'SendMessage returned!',0
szDestClass db 'Window0',0
szText db 'Text send to other windows',0
szNotFound db 'Receive Message Window not Found!',0

	.code
	
start:
	invoke FindWindow,addr szDestClass,NULL
	.if eax 
		mov hWnd,eax
		invoke wsprintf,addr szBuffer,addr szStart,addr szText
		invoke MessageBox,NULL,offset szBuffer,\
		offset szCaption,MB_OK
		invoke SendMessage,hWnd,WM_SETTEXT,0,addr szText
		invoke MessageBox,NULL,offset szReturn,\
		offset szCaption,MB_OK
	.elseif
		invoke MessageBox,NULL,offset szNotFound,\
		offset szCaption,MB_OK
	.endif
	invoke ExitProcess,NULL
	end start
