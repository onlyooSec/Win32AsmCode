;验证WM_COPYDATA传递数据的程序
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

stCopyData COPYDATASTRUCT<>
hDestWnd dd ?

	.const
szClassName db 'Win0',0 ;目标窗口名字
szData db 'just for hack!&dont forget who are you and what is hack',0
szText db 'ok.its ret..',0
szCaption db 'just..close me',0
	.code
	
start:
	invoke FindWindow,addr szClassName,NULL
	mov hDestWnd, eax
	
	mov stCopyData.dwData,0
	mov stCopyData.cbData,sizeof szData +1
	mov stCopyData.lpData,offset szData
	
	invoke SendMessage,hDestWnd,WM_COPYDATA,NULL,addr stCopyData
	invoke MessageBox,NULL,offset szText,offset szCaption,MB_OK
	invoke ExitProcess,0
	end start
	
