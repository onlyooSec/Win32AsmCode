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
	invoke MessageBox,NULL,addr @szBuffer,offset szT,MB_OK
	ret

_GetMemInfo endp


start:
	invoke GetModuleHandle,NULL
	mov hInstance ,eax
	call _GetMemInfo
	invoke ExitProcess,NULL
	end start
