If Not LCase( Right( WScript.FullName, 12 ) ) = "\cscript.exe" Then
  usage(true)
end if

wscript.echo "                __  ___       __          ____       __     "
wscript.echo "               / / / (_)___ _/ /_        / __ \___  / /_  __"
wscript.echo "              / /_/ / / __ `/ __ \______/ /_/ / _ \/ / / / /"
wscript.echo "             / __  / / /_/ / / / /_____/ _, _/  __/ / /_/ / "
wscript.echo "            /_/ /_/_/\__, /_/ /_/     /_/ |_|\___/_/\__, /  "
wscript.echo "                    /____/                         /____/   "
wscript.echo ""
wscript.echo "        BSIZE - Backup Size Calculator V1.0  www.high-rely.com"
wscript.echo "          Copyright (c) 2013 by Highly Reliable Systems, Inc."
wscript.echo "                        All rights reserved."
wscript.echo ""
wscript.echo ""

dim count, size, verbose, firstarg, fso
count = 0
size = 0.0
verbose = false
firstarg = 0

Set args = Wscript.Arguments
If (args.count < 3) or (args.count > 4) Then
  usage(false)
End If

if args.count = 4 then
  if args(0) = "/verbose" then
    verbose = true
    firstarg = 1
  else
    usage(false)
  end if
end if

Set fso = CreateObject("Scripting.FileSystemObject")

on error resume next
wscript.echo "Scanning " & args(firstarg) & "..."
doSubfolders fso.GetFolder(args(firstarg)), CDate(args(firstarg + 1)), CDate(args(firstarg + 2)), args(firstarg)
wscript.Echo "Matched Files: " & count & ", " & FormatNumber(size / (1024 * 1024 * 1024), 2) & "GB"

Sub doSubFolders(folder, start, endx, path)
  on error resume next
  For Each subfolder in folder.SubFolders
    Set files = subfolder.Files
    For Each file in files
      if file.DateLastModified >= start and file.DateLastModified <= endx then
	    if verbose then
	      wscript.echo "Found '" & path & "\" & file.Name & "', Last Modified: " & file.DateLastModified
		end if
		count = count + 1
		size = size + file.Size
	  end if
    Next
    doSubFolders subfolder, start, endx, path + "\" + subfolder.Name
  Next
End Sub

function usage(short)
  wscript.echo "Usage: cscript bsize.vbs [/verbose] <path> <start date> <end date>"
  if not short then
    wscript.echo ""
    wscript.echo "       <start date> and <end date> are of the form MM/DD/YYYY"
  end if
  wscript.quit
end function