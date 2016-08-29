######################################################################################### 
# AUTHOR  : Felipe Dimitri Berveglieri Navarro Costa - dimitrinavarro@hotmail.com 
# DATE    : 08-06-2015 
# COMMENT : This script makes files backup. 
#           
# VERSION : 1.0
#########################################################################################
Import-Module WebAdministration
Import-Module WindowsSearch

$Source=Read-Host "Please type the source directory you want to backup"
$Destination=Read-Host "Please type the path directory you want to copy the backup files"
$Folder=Read-Host "Please type the root name folder"
$validation=Test-Path $Destination


New-PSDrive -Name "Backup" -PSProvider FileSystem -Root $Destination

if ($validation -eq $True){
        
       Set-Location Backup:
}
else{
    
    Write-Host "Error!Run Script Again"

    break
}

    robocopy $Source $Destination\$Folder *.* /mir /sec

    


Function Pause{

     Write-Host "Backup Sucessfull!!! `n"

     Write-Host "Press any key to continue..."

     $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") | Out-Null
	
}Import-Module PSWorkflow
Import-Module .\ShowUI
function Search-Twitter ($q)
{
	$wc = New-Object Net.Webclient
	$url = http://search.twitter.com/search.rss?q=$q
	([xml]$wc.downloadstring($url)).rss.channel.item | select *
}

$ws = @{
	WindowStartupLocation = "CenterScreen"
	Width = 500
	Height = 500
}

New-Window @ws -Show {
	ListBox -Background Black -ItemTemplate {
		Grid -Columns 55, 300 {
			Image -Column 0 -Name Image -Margin 5
			TextBlock -Column 1 -Name Title `
					  -Margin 5 `
					  -Foreground White `
					  -TextWrapping Wrap
		} | ConvertTo-DataTemplate -Binding @{
			"Image.Source" = "image_link"
			"Title.Text" = "title"
		}
	} -ItemsSource (Search-Twitter PowerShell)
}



Pause


