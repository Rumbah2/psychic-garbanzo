#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

FileRemoveDir, driver , 1
FileCreateDir, driver
FileDelete, driver.zip

MsgBox, 4, ,Select Yes to download the stable driver or No to download the latest canary.`n`nDownloading takes some time, just wait for the next Box to appear
IfMsgBox Yes
	UrlDownloadToFile, https://github.com/julianxhokaxhiu/FFNx/releases/download/1.7.0/FFNx-FF7_1998-v1.7.0.0.zip, driver.zip
else
	UrlDownloadToFile, https://github.com/julianxhokaxhiu/FFNx/releases/download/canary/FFNx-FF7_1998-Canary.zip, driver.zip

Loop, Files, driver, D
{
	If A_LoopFileName =
	{
		continue
	}
	driverpath := A_LoopFileLongPath
}

Loop, Files, driver.zip
{
	If A_LoopFileName =
	{
		continue
	}
	Unz(A_LoopFileLongPath, driverpath)
}

FileSelectFile, HeavenFile, 3, c:\7th Heaven, , 7th*.exe

if ErrorLevel
	{
		MsgBox, No file selected
		ExitApp
	}

If not FileExist("driver\FFNx.dll")
{
	MsgBox, Driver download didn't work
	ExitApp
}

Loop, Files, %HeavenFile%
{
	If A_LoopFileName =
	{
		continue
	}
	FileMove, %A_LoopFileDir%\Resources\Game Driver\7H_GameDriver.dll, %A_LoopFileDir%\Resources\Game Driver\_7H_GameDriver.dll
	FileRead, Settings, %A_LoopFileDir%\7thWorkshop\settings.xml
	If Errorlevel > 0
	{
		MsgBox, Please run 7th Heaven once
		ExitApp
	}
	Loop, Parse, Settings, `n, `r
	{
		FoundPos := InStr(A_LoopField, "<FF7Exe>")
		If FoundPos > 0
			{
				FF7File := SubStr(A_LoopField, FoundPos + 8)
				FF7File := SubStr(FF7File, 1, -9)
			}
	}
}

If not FileExist(FF7File)
{
	MsgBox, FF7 not found
	ExitApp
}

Loop, Files, %FF7File%
{
	If A_LoopFileName =
	{
		continue
	}
	FileCopyDir, Driver,  %A_LoopFileDir%\ , 1
	FileMove, %A_LoopFileDir%\FFNx.dll, %A_LoopFileDir%\7H_GameDriver.dll
}

MsgBox, All Done



Unz(sZip, sUnz)									; sZip = the fullpath of the zip file, sUnz the folder to contain the extracted files
	{
;	FileCreateDir, %sUnz%
    psh  := ComObjCreate("Shell.Application")
    psh.Namespace( sUnz ).CopyHere( psh.Namespace( sZip ).items, 4|16 )
	}