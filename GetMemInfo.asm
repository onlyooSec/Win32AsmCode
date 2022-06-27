;这个文件用来查看当前内存状态
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
	.const
	db '物理内存总数     %lu字节',0dh,0ah
	db '空闲物理内存     %lu字节',0dh,0ah
	db '虚拟内存总数     %lu字节',0dh,0ah
	db '空闲虚拟内存     %lu字节',0dh,0ah
	db '已用内存比例     %d%%',0dh,0ah
	db '-------------------------',0dh,0ah
	db '用户地址空间总数 %lu字节',0dh,0ah
	db '用户可用地址空间 %lu字节',0dh,0ah,0
	
	
	.code

_GetMemInfo proc
	
	LOCAL @stMemInfo:MEMORYSTATUS
	LOCAL @szBuffer[1024]:byte
	
	mov @stMemInfo.dwLength,sizeof @stMemInfo
	invoke GlobalMemoryStatus,addr @stMemInfo
	invoke wsprintf,addr @stBuffer,addr szInfo,\
	@stMemInfo.dwTotalPhys,@stMemInfo.dwAvailPhys,\
	@stMemInfo.dwTotalPageFile,\
	@stMemInfo.dwAvailPageFile,\
	@stMemInfo.dwMemoryLoad,\
	@stMemInfo.dwTotalVirtual,@stMemInfo.dwAvailVirtual
	invoke SetDlgItemText,hWinMain,IDC_INFO,addr @szBuffer
	ret

_GetMemInfo endp
