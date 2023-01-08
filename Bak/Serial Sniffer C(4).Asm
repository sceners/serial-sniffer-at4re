.386
.model flat, stdcall  ;32 bit memory model
option casemap :none  ;case sensitive

include Serial Sniffer C.inc
.data
File db "Sniffer.exe",0
espace db 32 dup(?)
succs db "[Success] File has been Created to Sniffer.exe",0
sus db "[Success]",0
include SS.inc
.data?
AboutBuffer db 1024 dup(?)
SofBuffer db 512 dup(?)
AppBuffer db 32 dup(?)
hFile dword ?
oFile dword ?
mFile dword ?
nBytes dword ?
VA dword ?
VABuffer dword ?
.code

start:

	invoke GetModuleHandle,NULL
	mov		hInstance,eax

    invoke InitCommonControls
	invoke DialogBoxParam,hInstance,IDD_DIALOG1,NULL,addr DlgProc,NULL
	invoke ExitProcess,0

;########################################################################

DlgProc proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		invoke LoadIcon,hInstance,1
		invoke CreateFile,addr File,GENERIC_READ+ GENERIC_WRITE,FILE_SHARE_READ+ FILE_SHARE_WRITE,0,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
		mov hFile,eax
		invoke WriteFile,eax,addr table,2600h,addr nBytes,0
		invoke CloseHandle,hFile
	.elseif eax==WM_COMMAND
	.if wParam==1015
		invoke CreateFile,addr File,GENERIC_READ+ GENERIC_WRITE,FILE_SHARE_READ+ FILE_SHARE_WRITE,0,OPEN_ALWAYS,FILE_ATTRIBUTE_NORMAL,0
		mov hFile,eax
		invoke CreateFileMapping,eax,0,PAGE_READWRITE,0,0,0
		mov oFile,eax
		invoke MapViewOfFile,eax,FILE_MAP_READ+ FILE_MAP_WRITE,0,0,0
		mov mFile,eax
		
		invoke GetDlgItemText,hWin,1022,addr AppBuffer,52h
		mov eax,mFile
		add eax,0C00h
		invoke lstrcpy,addr [eax],addr AppBuffer

		invoke GetDlgItemText,hWin,1019,addr VABuffer,9
		invoke htodw,addr VABuffer
		mov VA,eax
		mov eax,mFile
		add eax,0CD5h
		mov ecx,VA
		mov [eax],ecx
		
		invoke GetDlgItemText,hWin,1014,addr SofBuffer,52h
		mov eax,mFile
		add eax,0C40h
		invoke lstrcpy,addr [eax],addr SofBuffer
		
		invoke GetDlgItemText,hWin,1013,addr AboutBuffer,512h
		mov eax,mFile
		add eax,0CEEh
		invoke lstrcpy,addr [eax],addr AboutBuffer
		
		invoke IsDlgButtonChecked,hWin,1002
		test eax,eax
		jz Next
		mov eax,mFile
		add eax,0CD9h
		mov byte ptr ds:[eax],1
		Next:
		invoke IsDlgButtonChecked,hWin,1003
		test eax,eax
		jz Next1
		mov eax,mFile
		add eax,0CD9h
		mov byte ptr ds:[eax],2
		Next1:
		invoke IsDlgButtonChecked,hWin,1004
		test eax,eax
		jz Next2
		mov eax,mFile
		add eax,0CD9h
		mov byte ptr ds:[eax],3
		Next2:
		invoke IsDlgButtonChecked,hWin,1005
		test eax,eax
		jz Next3
		mov eax,mFile
		add eax,0CD9h
		mov byte ptr ds:[eax],4
		Next3:
		invoke IsDlgButtonChecked,hWin,1006
		test eax,eax
		jz Next4
		add eax,0CD9h
		mov byte ptr ds:[eax],5
		Next4:
		invoke IsDlgButtonChecked,hWin,1007
		test eax,eax
		jz Next5
		mov eax,mFile
		add eax,0CD9h
		mov byte ptr ds:[eax],6
		Next5:
		invoke IsDlgButtonChecked,hWin,1008
		test eax,eax
		jz Next6
		mov eax,mFile
		add eax,0CD9h
		mov byte ptr ds:[eax],7
		Next6:
		invoke IsDlgButtonChecked,hWin,1009
		test eax,eax
		jz Next7
		mov eax,mFile
		add eax,0CD9h
		mov byte ptr ds:[eax],8
		Next7:
		invoke MessageBox,hWin,addr succs,addr sus,MB_OK+ MB_ICONINFORMATION
		invoke CloseHandle,hFile
		invoke CloseHandle,oFile
		invoke UnmapViewOfFile,mFile					
	.endif
	.elseif eax==WM_CLOSE
		invoke EndDialog,hWin,0
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret

DlgProc endp

end start
