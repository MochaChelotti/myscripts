
Add-PSSnapin "VeeamPSSnapIn" -ErrorAction SilentlyContinue
 
#region User-Variables
# VBR Server (Server Name, FQDN or IP)
$vbrServer = "172.22.4.123"
# Report mode - valid modes: any number of hours, Weekly or Monthly
# 24, 48, "Weekly", "Monthly"
$reportMode = 24
# Report Title
$rptTitle = "My Veeam Report"
# Append Report Mode to Report Title E.g. My Veeam Report (Last 24 Hours)
$modeTitle = $true
# Append VBR Server name to Report Title
$vbrTitle = $true
# Report Width in Pixels
$rptWidth = 1024

# Location of Veeam executable (Veeam.Backup.Shell.exe)
$veeamExePath = "C:\Program Files\Veeam\Backup and Replication\Backup\Veeam.Backup.Shell.exe"

# Show Backup Session Summary
$showSummaryBk = $true
# Show VMs with no successful backups within time frame ($reportMode)
$showUnprotectedVMs = $true
# Show VMs with successful backups within time frame ($reportMode)
$showProtectedVMs = $true
# To Exclude VMs from Missing and Successful Backups section add VM names to be excluded
# $excludevms = @("vm1","vm2","*_replica")
$excludeVMs = @("")
# Exclude VMs from Missing and Successful Backups section in the following (vCenter) folder(s)
# $excludeFolder =  = @("folder1","folder2","*_testonly")
$excludeFolder = @("")
# Exclude VMs from Missing and Successful Backups section in the following (vCenter) datacenter(s)
# $excludeDC =  = @("dc1","dc2","dc*")
$excludeDC = @("")
# Show Backup Job Status
$showJobsBk = $true
# Show Running Backup jobs
$showRunningBk = $true
# Only show last session for each Backup Job
$onlyLastBk = $false
# Show detailed information for Backup Jobs/Sessions (Avg Speed, Total(GB), Processed(GB), Read(GB), Transferred(GB))
$showDetailedBk = $true
# Show Backup Sessions w/Warnings or Failures within time frame ($reportMode)
$showWarnFailBk = $true
# Show Successful Backup Sessions within time frame ($reportMode)
$showSuccessBk = $true
# Show Running Restore VM Sessions within time frame ($reportMode)
$showRestoRunVM = $true
# Show Completed Restore VM Sessions within time frame ($reportMode)
$showRestoreVM = $true
# Show Endpoint Backup Session Summary
$showSummaryEp = $true
# Show Endpoint Backup Job Status
$showJobsEp = $true
# Show Running Endpoint Backup jobs
$showRunningEp = $true
# Only show last session for each Endpoint Backup Job
$onlyLastEp = $false
# Show Endpoint Backup Sessions w/Warnings or Failures within time frame ($reportMode)
$showWarnFailEp = $true
# Show Successful Endpoint Backup Sessions within time frame ($reportMode)
$showSuccessEp = $true
# Show Repository Info
$showRepo = $true
# Show Proxy Info
$showProxy = $true
# Show Replica Target Info
$showReplica = $true
# Show Veeam Services Info (Windows Services)
$showServices = $true
# Show only Services that are NOT running
$hideRunningSvc = $false
# Show License expiry info
$showLicExp = $true

# Save output to a file - $true or $false
$saveFile = $true
# File output path and filename
$outFile = "C:\MyVeeamReport_$(Get-Date -format MMddyyyy_hhmmss).htm"
# Launch file after creation - $true or $false
$launchFile = $true

# Email configuration
$sendEmail = $true
$emailHost = "mail.exagrid.com"
$emailUser = "mchelotti"
$emailPass = ""
$emailFrom = "MyVeeamReport@exagrid.com"
$emailTo = "mchelotti@exagrid.com"
# Send report as attachment - $true or $false
$emailAttach = $false
# Email Subject 
$emailSubject = $rptTitle
# Append Report Mode to Email Subject E.g. My Veeam Report (Last 24 Hours)
$modeSubject = $true
# Append VBR Server name to Email Subject
$vbrSubject = $true

# Highlighting Thresholds
# Repository Free Space Remaining %
$repoCritical = 10
$repoWarn = 20
# Replica Target Free Space Remaining %
$replicaCritical = 10
$replicaWarn = 20
# License Days Remaining
$licenseCritical = 30
$licenseWarn = 90
#endregion
 
#region VersionInfo
$MVRversion = "9.0.1"
#
# Version 9.0.1 - SM
# Inital version for VBR v9
# Updated version to follow VBR version (VeeamMajorVersion.VeeamUpdateVersion.MVRVersion)
# Fixed Proxy Information (change in property names in v9)
# Rewrote Repository Info to use newly available properties (yay!)
# Updated Get-VMsBackupStatus to remove obsolete commandlet warning (Thanks tsightler!)
# Added ability to run from console only install
# Added ability to include VBR server in report title and email subject
# Rewrote License Info gathering to allow remote info gathering
# Misc minor tweaks/cleanup
#
# Version 2.0 - SM
# Misc minor tweaks/cleanup
# Proxy host IP info now always returns IPv4 address
# Added ability to query Veeam database for Repository size info
#	Big thanks to tsightler - http://forums.veeam.com/powershell-f26/get-vbrbackuprepository-why-no-size-info-t27296.html
# Added report section - Backup Job Status
# Added option to show detailed Backup Job/Session information (Avg Speed, Total(GB), Processed(GB), Read(GB), Transferred(GB))
# Added report section - Running VM Restore Sessions
# Added report section - Completed VM Restore Sessions
# Added report section - Endpoint Backup Results Summary
# Added report section - Endpoint Backup Job Status
# Added report section - Running Endpoint Backup Jobs
# Added report section - Endpoint Backup Jobs/Sessions with Warnings or Failures
# Added report section - Successful Endpoint Backup Jobs/Sessions
#
# Version 1.4.1 - SM
# Fixed issue with summary counts
# Version 1.4 - SM
# Misc minor tweaks/cleanup
# Added variable for report width
# Added variable for email subject
# Added ability to show/hide all report sections
# Added Protected/Unprotected VM Count to Summary
# Added per object details for sessions w/no details
# Added proxy host name to Proxy Details
# Added repository host name to Repository Details
# Added section showing successful sessions
# Added ability to view only last session per job
# Added Cluster field for protected/unprotected VMs
# Added catch for cifs repositories greater than 4TB as erroneous data is returned
# Added % Complete for Running Jobs
# Added ability to exclude multiple (vCenter) folders from Missing and Successful Backups section
# Added ability to exclude multiple (vCenter) datacenters from Missing and Successful Backups section
# Tweaked license info for better reporting across different date formats
#
# Version 1.3 - SM
# Now supports VBR v8
# For VBR v7, use report version 1.2
# Added more flexible options to save and launch file 
#
# Version 1.2 - SM
# Added option to show VMs Successfully backed up
#
# Version 1.1.4 - SM
# Misc tweaks/bug fixes
# Reconfigured HTML a bit to help with certain email clients
# Added cell coloring to highlight status
# Added $rptTitle variable to hold report title
# Added ability to send report via email as attachment
#
# Version 1.1.3 - SM
# Added Details to Sessions with Warnings or Failures
#
# Version 1.1.2 - SM
# Minor tweaks/updates
# Added Veeam version info to header
#
# Version 1.1.1 - Shawn Masterson
# Based on vPowerCLI v6 Army Report (v1.1) by Thomas McConnell
# http://www.vpowercli.co.uk/2012/01/23/vpowercli-v6-army-report/
# http://pastebin.com/6p3LrWt7
#
# Tweaked HTML header (color, title)
#
# Changed report width to 1024px
#
# Moved hard-coded path to exe/dll files to user declared variables ($veeamExePath/$veeamDllPath)
#
# Adjusted sorting on all objects
#
# Modified info group/counts
#   Modified - Total Jobs = Job Runs
#   Added - Read (GB)
#   Added - Transferred (GB)
#   Modified - Warning = Warnings
#   Modified - Failed = Failures
#   Added - Failed (last session)
#   Added - Running (currently running sessions)
# 
# Modified job lines
#   Renamed Header - Sessions with Warnings or Failures
#   Fixed Write (GB) - Broke with v7
#   
# Added support license renewal
#   Credit - Gavin Townsend  http://www.theagreeablecow.com/2012/09/sysadmin-modular-reporting-samreports.html
#   Original  Credit - Arne Fokkema  http://ict-freak.nl/2011/12/29/powershell-veeam-br-get-total-days-before-the-license-expires/
#
# Modified Proxy section
#   Removed Read/Write/Util - Broke in v7 - Workaround unknown
# 
# Modified Services section
#   Added - $runningSvc variable to toggle displaying services that are running
#   Added - Ability to hide section if no results returned (all services are running)
#   Added - Scans proxies and repositories as well as the VBR server for services
#
# Added VMs Not Backed Up section
#   Credit - Tom Sightler - http://sightunseen.org/blog/?p=1
#   http://www.sightunseen.org/files/vm_backup_status_dev.ps1
#   
# Modified $reportMode
#   Added ability to run with any number of hours (8,12,72 etc)
#	Added bits to allow for zero sessions (semi-gracefully)
#
# Added Running Jobs section
#   Added ability to toggle displaying running jobs
#
# Added catch to ensure running v7 or greater
#
#
# Version 1.1
# Added job lines as per a request on the website
#
# Version 1.0
# Clean up for release
#
# Version 0.9
# More cmdlet rewrite to improve perfomace, credit to @SethBartlett
# for practically writing the Get-vPCRepoInfo
#
# Version 0.8
# Added Read/Write stats for proxies at requests of @bsousapt
# Performance improvement of proxy tear down due to rewrite of cmdlet
# Replaced 2 other functions
# Added Warning counter, .00 to all storage returns and fetch credentials for
# remote WinLocal repos
#
# Version 0.7
# Added Utilisation(Get-vPCDailyProxyUsage) and Modes 24, 48, Weekly, and Monthly
# Minor performance tweaks
 
#endregion
 
#region NonUser-Variables
# Disconnect any existing VBR Server connection
Disconnect-VBRServer
# Connect to VBR Server
Connect-VBRServer -server $vbrServer
# Get VBR Server object
$vbrserverobj = Get-VBRLocalhost
# Get all Proxies
$viProxyList = Get-VBRViProxy
# Get all Repositories
$repoList = Get-VBRBackupRepository
# Get all Sessions (Backup/BackupCopy/Replica)
$allSesh = Get-VBRBackupSession
# Get all Restore Sessions
$allResto = Get-VBRRestoreSession

# Convert mode (timeframe) to hours
If ($reportMode -eq "Monthly") {
        $HourstoCheck = 720
} Elseif ($reportMode -eq "Weekly") {
        $HourstoCheck = 168
} Else {
        $HourstoCheck = $reportMode
}

# Gather Backup jobs
$allJobsBk = @(Get-VBRJob | ? {$_.JobType -eq "Backup"})

# Gather all Backup sessions within timeframe
$seshListBk = @($allSesh | ?{($_.CreationTime -ge (Get-Date).AddHours(-$HourstoCheck)) -and $_.JobType -eq "Backup"})

# Get Backup session information
$totalxferBk = 0
$totalReadBk = 0
$seshListBk | %{$totalxferBk += $([Math]::Round([Decimal]$_.Progress.TransferedSize/1GB, 2))}
$seshListBk | %{$totalReadBk += $([Math]::Round([Decimal]$_.Progress.ReadSize/1GB, 2))}
If ($onlyLastBk) {
	$tempSeshListBk = $seshListBk
	$seshListBk = @()
	Foreach($job in (Get-VBRJob | ? {$_.JobType -eq "Backup"})) {
		$seshListBk += $TempSeshListBk | ?{$_.Jobname -eq $job.name} | Sort-Object CreationTime -Descending | Select-Object -First 1
	}
}
$successSessionsBk = @($seshListBk | ?{$_.Result -eq "Success"})
$warningSessionsBk = @($seshListBk | ?{$_.Result -eq "Warning"})
$failsSessionsBk = @($seshListBk | ?{$_.Result -eq "Failed"})
$runningSessionsBk = @($allSesh | ?{$_.State -eq "Working" -and $_.JobType -eq "Backup"})
$failedSessionsBk = @($seshListBk | ?{($_.Result -eq "Failed") -and ($_.WillBeRetried -ne "True")})

# Gather VM Restore sessions within timeframe
$seshListResto = @($allResto | ?{($_.CreationTime -ge (Get-Date).AddHours(-$HourstoCheck))})

# Get VM Restore session information
$completeResto = @($seshListResto | ?{$_.IsCompleted})
$runningResto = @($seshListResto | ?{!($_.IsCompleted)})

# Gather Endpoint Backup jobs
$allJobsEp = @(Get-VBREPJob)

# Gather all Endpoint Backup sessions within timeframe
$allSeshEp = Get-VBREPSession
$seshListEp = $allSeshEp | ?{$_.CreationTime -ge (Get-Date).AddHours(-$HourstoCheck)}
If ($onlyLastEp) {
	$tempSeshListEp = $seshListEp
	$seshListEp = @()
	Foreach($job in $allJobsEp) {
		$seshListEp += $TempSeshListEp | ?{$_.JobId -eq $job.Id} | Sort-Object CreationTime -Descending | Select-Object -First 1
	}
}
$successSessionsEp = @($seshListEp | ?{$_.Result -eq "Success"})
$warningSessionsEp = @($seshListEp | ?{$_.Result -eq "Warning"})
$failsSessionsEp = @($seshListEp | ?{$_.Result -eq "Failed"})
$runningSessionsEp = @($allSeshEp | ?{$_.State -eq "Working"})

#Get Replica jobs
$repList = @(Get-VBRJob | ?{$_.IsReplica})

# Append Report Mode to Report Title
If ($modeTitle) {
	If (($reportMode -ne "Weekly") -And ($reportMode -ne "Monthly")) {
	        $rptTitle = "$rptTitle (Last $reportMode Hrs)"
	} Else {
	        $rptTitle = "$rptTitle ($reportMode)"
	}
}

# Append VBR Server to Report Title
If ($vbrTitle) {
	$rptTitle = "$rptTitle - $vbrserver"
}

# Append Report Mode to Email subject
If ($modeSubject) {
	If (($reportMode -ne "Weekly") -And ($reportMode -ne "Monthly")) {
	        $emailSubject = "$emailSubject (Last $reportMode Hrs)"
	} Else {
	        $emailSubject = "$emailSubject ($reportMode)"
	}
}

# Append VBR Server to Email subject
If ($vbrSubject) {
	$emailSubject = "$emailSubject - $vbrserver"
}
#endregion

#region Functions
 
Function Get-vPCProxyInfo {
	$vPCObjAry = @()
    Function Build-vPCObj {param ([PsObject]$inputObj)
            $ping = new-object system.net.networkinformation.ping
			$DNS = [Net.DNS]::GetHostEntry("$($inputObj.Host.Name)")
			$IPv4 = ($DNS.get_AddressList() | Where {$_.AddressFamily -eq "InterNetwork"} | Select -First 1).IPAddressToString
            $pinginfo = $ping.send("$($IPv4)")
           
            If ($pinginfo.Status -eq "Success") {
                    $hostAlive = "Alive"
            } Else {
                    $hostAlive = "Dead"
            }
           
            $vPCFuncObject = New-Object PSObject -Property @{
                    ProxyName = $inputObj.Name
                    RealName = $inputObj.Host.Name.ToLower()
                    Disabled = $inputObj.IsDisabled
                    Status  = $hostAlive
                    IP = $IPv4
                    Responce = $pinginfo.RoundtripTime
            }
            Return $vPCFuncObject
    }   
    Get-VBRViProxy | %{$vPCObjAry += $(Build-vPCObj $_)}
	$vPCObjAry
}
 
Function Get-vPCRepoInfo {
[CmdletBinding()]
        param (
                [Parameter(Position=0, ValueFromPipeline=$true)]
                [PSObject[]]$Repository
                )
        Begin {
                $outputAry = @()
                Function Build-Object {param($name, $repohost, $path, $free, $total)
                        $repoObj = New-Object -TypeName PSObject -Property @{
                                        Target = $name
										RepoHost = $repohost
                                        Storepath = $path
                                        StorageFree = [Math]::Round([Decimal]$free/1GB,2)
                                        StorageTotal = [Math]::Round([Decimal]$total/1GB,2)
                                        FreePercentage = [Math]::Round(($free/$total)*100)
                                }
                        Return $repoObj | Select Target, RepoHost, Storepath, StorageFree, StorageTotal, FreePercentage
                }
        }
        Process {
                Foreach ($r in $Repository) {
                	# Refresh Repository Size Info
					[Veeam.Backup.Core.CBackupRepositoryEx]::SyncSpaceInfoToDb($r, $true)
					
					If ($r.HostId -eq "00000000-0000-0000-0000-000000000000") {
						$HostName = ""
					}
					Else {
						$HostName = $($r.GetHost()).Name.ToLower()
					}
					$outputObj = Build-Object $r.Name $Hostname $r.Path $r.info.CachedFreeSpace $r.Info.CachedTotalSpace
					}
                $outputAry += $outputObj
        }
        End {
                $outputAry
        }
}

Function Get-vPCReplicaTarget {
[CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline=$true)]
        [PSObject[]]$InputObj
    )
    BEGIN {
		$outputAry = @()
        $dsAry = @()
        If (($Name -ne $null) -and ($InputObj -eq $null)) {
                $InputObj = Get-VBRJob -Name $Name
        }
    }
    PROCESS {
        Foreach ($obj in $InputObj) {
                        If (($dsAry -contains $obj.ViReplicaTargetOptions.DatastoreName) -eq $false) {
                        $esxi = $obj.GetTargetHost()
                            $dtstr =  $esxi | Find-VBRViDatastore -Name $obj.ViReplicaTargetOptions.DatastoreName    
                            $objoutput = New-Object -TypeName PSObject -Property @{
                                    Target = $esxi.Name
                                    Datastore = $obj.ViReplicaTargetOptions.DatastoreName
                                    StorageFree = [Math]::Round([Decimal]$dtstr.FreeSpace/1GB,2)
                                    StorageTotal = [Math]::Round([Decimal]$dtstr.Capacity/1GB,2)
                                    FreePercentage = [Math]::Round(($dtstr.FreeSpace/$dtstr.Capacity)*100)
                            }
                            $dsAry = $dsAry + $obj.ViReplicaTargetOptions.DatastoreName
                            $outputAry = $outputAry + $objoutput
                        }
                        Else {
                                return
                        }
        }
    }
    END {
                $outputAry | Select Target, Datastore, StorageFree, StorageTotal, FreePercentage
    }
}
 
Function Get-VeeamVersion {	
    $veeamExe = Get-Item $veeamExePath
	$VeeamVersion = $veeamExe.VersionInfo.ProductVersion
	Return $VeeamVersion
} 
 
Function Get-VeeamSupportDate {
	param (
		[string]$vbrserver)
	
	# Query (remote) registry with WMI for license info
	Try{
		$wmi = get-wmiobject -list "StdRegProv" -namespace root\default -computername $vbrserver -ErrorAction Stop
		$hklm = 2147483650
		$bKey = "SOFTWARE\Veeam\Veeam Backup and Replication\license"
		$bValue = "Lic1"
		$regBinary = ($wmi.GetBinaryValue($hklm, $bKey, $bValue)).uValue
		$veeamLicInfo = [string]::Join($null, ($regBinary | % { [char][int]$_; }))		

		# Convert Binary key
		$pattern = "expiration date\=\d{1,2}\/\d{1,2}\/\d{1,4}"
		$expirationDate = [regex]::matches($VeeamLicInfo, $pattern)[0].Value.Split("=")[1]
		$datearray = $expirationDate -split '/'
		$expirationDate = Get-Date -Day $datearray[0] -Month $datearray[1] -Year $datearray[2]
		$totalDaysLeft = ($expirationDate - (get-date)).Totaldays.toString().split(",")[0]
		$totalDaysLeft = [int]$totalDaysLeft
		$objoutput = New-Object -TypeName PSObject -Property @{
			ExpDate = $expirationDate.ToShortDateString()
	        DaysRemain = $totalDaysLeft
	    }
		
	}
	Catch{
		$objoutput = New-Object -TypeName PSObject -Property @{
		    ExpDate = "Failed"
		    DaysRemain = "Failed"
		}
		
	}
	$objoutput
} 

Function Get-VeeamServers {
	$vservers=@{}
	$outputAry = @()
	$vservers.add($($script:vbrserverobj.Name),"VBRServer")
	Foreach ($srv in $script:viProxyList) {
		If (!$vservers.ContainsKey($srv.Host.Name)) {
		  $vservers.Add($srv.Host.Name,"ProxyServer")
		}
	}
	Foreach ($srv in $script:repoList) {
		If (!$vservers.ContainsKey($srv.gethost().Name)) {
		  $vservers.Add($srv.gethost().Name,"RepoServer")
		}
	}
	$vservers = $vservers.GetEnumerator() | Sort-Object Name
	Foreach ($vserver in $vservers) {
		$outputAry += $vserver.Name
	}
	return $outputAry
}

Function Get-VeeamServices {
    param (
	  [PSObject]$inputObj)
	  
    $outputAry = @()
	Foreach ($obj in $InputObj) {    
		$output = Get-Service -computername $obj -Name "*Veeam*" -exclude "SQLAgent*" |
	    Select @{Name="Server Name"; Expression = {$obj.ToLower()}}, @{Name="Service Name"; Expression = {$_.DisplayName}}, Status
	    $outputAry = $outputAry + $output  
    }
$outputAry
}

Function Get-VMsBackupStatus {
	# Convert exclusion list to simple regular expression
    $excludevms_regex = ('(?i)^(' + (($script:excludeVMs | ForEach {[regex]::escape($_)}) -join "|") + ')$') -replace "\\\*", ".*"
    $excludefolder_regex = ('(?i)^(' + (($script:excludeFolder | ForEach {[regex]::escape($_)}) -join "|") + ')$') -replace "\\\*", ".*"
    $excludedc_regex = ('(?i)^(' + (($script:excludeDC | ForEach {[regex]::escape($_)}) -join "|") + ')$') -replace "\\\*", ".*"
   
    $vms=@{}

    # Build a hash table of all VMs.  Key is either Job Object Id (for any VM ever in a Veeam job) or vCenter ID+MoRef
    # Assume unprotected (!), and populate Cluster, DataCenter, and Name fields for hash key value
    Find-VBRViEntity | 
        Where-Object {$_.Type -eq "Vm" -and $_.VmFolderName -notmatch $excludefolder_regex} |
        Where-Object {$_.Name -notmatch $excludevms_regex} |
        Where-Object {$_.Path.Split("\")[1] -notmatch $excludedc_regex} |
        ForEach {$vms.Add(($_.FindObject().Id, $_.Id -ne $null)[0], @("!", $_.Path.Split("\")[0], $_.Path.Split("\")[1], $_.Path.Split("\")[2], $_.Name))}
		
	Find-VBRViEntity -VMsandTemplates |
    	Where-Object {$_.Type -eq "Vm" -and $_.IsTemplate -eq "True" -and $_.VmFolderName -notmatch $excludefolder_regex} |
    	Where-Object {$_.Name -notmatch $excludevms_regex} |
    	Where-Object {$_.Path.Split("\")[1] -notmatch $excludedc_regex} |
    	ForEach {$vms.Add(($_.FindObject().Id, $_.Id -ne $null)[0], @("!", $_.Path.Split("\")[0], $_.Path.Split("\")[1], $_.VmHostName, "[template] $($_.Name)"))}
      
    # Find all backup task sessions that have ended in the last x hours and not ending in Failure
    $vbrtasksessions = (Get-VBRBackupSession | 
        Where-Object {$_.JobType -eq "Backup" -and $_.EndTime -ge (Get-Date).addhours(-$script:HourstoCheck)}) |
        Get-VBRTaskSession | Where-Object {$_.Status -ne "Failed"}

    # Compare VM list to session list and update found VMs status to "Protected"
    If ($vbrtasksessions) {
      Foreach ($vmtask in $vbrtasksessions) {
         If($vms.ContainsKey($vmtask.Info.ObjectId)) {
            $vms[$vmtask.Info.ObjectId][0]=$vmtask.JobName
         }
      }
   }
   $vms.GetEnumerator() | Sort-Object Value
}

Function Get-VMsMissingBackup {
	param (
		$vms)
	
	$outputary = @()  
	Foreach ($vm in $vms) {
	  If ($vm.Value[0] -eq "!") {
	    $objoutput = New-Object -TypeName PSObject -Property @{
		vCenter = $vm.Value[1]
		Datacenter = $vm.Value[2]
		Cluster = $vm.Value[3]
		Name = $vm.Value[4]
		}
		$outputAry += $objoutput
	  }
	}
	$outputAry | Select vCenter, Datacenter, Cluster, Name
}

Function Get-VMsSuccessBackup {
	param (
		$vms)
	
	$outputary = @()  
	Foreach ($vm in $vms) {
	  If ($vm.Value[0] -ne "!") {
	    $objoutput = New-Object -TypeName PSObject -Property @{
		vCenter = $vm.Value[1]
		Datacenter = $vm.Value[2]
		Cluster = $vm.Value[3]
		Name = $vm.Value[4]
		}
		$outputAry += $objoutput
	  }
	}
	$outputAry | Select vCenter, Datacenter, Cluster, Name
}

#endregion
 
#region Report
# Get Veeam Version
$VeeamVersion = Get-VeeamVersion

If ($VeeamVersion -lt 9) {
	Write-Host "Script requires VBR v9" -ForegroundColor Red
	exit
}

# HTML Stuff
$headerObj = @"
<html>
        <head>
                <title>$rptTitle</title>
                <style>  
                        body {font-family: Tahoma; background-color:#fff;}
						table {font-family: Tahoma;width: $($rptWidth)px;font-size: 12px;border-collapse:collapse;}
                        <!-- table tr:nth-child(odd) td {background: #e2e2e2;} -->
						th {background-color: #cccc99;border: 1px solid #a7a9ac;border-bottom: none;}
                        td {background-color: #ffffff;border: 1px solid #a7a9ac;padding: 2px 3px 2px 3px;vertical-align: top;}
                </style>
        </head>
"@
 
$bodyTop = @"
        <body>
			<center>
                <table cellspacing="0" cellpadding="0">
                        <tr>
                                <td style="width: 80%;height: 45px;border: none;background-color: #003366;color: White;font-size: 24px;vertical-align: bottom;padding: 0px 0px 0px 15px;">$rptTitle</td>
                                <td style="width: 20%;height: 45px;border: none;background-color: #003366;color: White;font-size: 12px;vertical-align:text-top;text-align:right;padding: 2px 3px 2px 3px;">MVR v$MVRversion</td>
                        </tr>
						<tr>
                                <td style="width: 80%;height: 35px;border: none;background-color: #003366;color: White;font-size: 10px;vertical-align: bottom;padding: 0px 0px 2px 3px;">Report generated at $(Get-Date -format g) on $((gc env:computername).ToLower())</td>
                                <td style="width: 20%;height: 35px;border: none;background-color: #003366;color: White;font-size: 10px;vertical-align:bottom;text-align:right;padding: 2px 3px 2px 3px;">Veeam v$VeeamVersion</td>
                        </tr>
                </table>
"@
 
$subHead01 = @"
                <table>
                        <tr>
                                <td style="height: 35px;background-color: #eeeeee;color: #003366;font-size: 16px;font-weight: bold;vertical-align: middle;padding: 5px 0 0 15px;border-top: 1px solid #cccc99;border-bottom: none;">
"@

$subHead01err = @"
                <table>
                        <tr>
                                <td style="height: 35px;background-color: #FF0000;color: #003366;font-size: 16px;font-weight: bold;vertical-align: middle;padding: 5px 0 0 15px;border-top: 1px solid #cccc99;border-bottom: none;">
"@

$subHead02 = @"
                                </td>
                        </tr>
                </table>
"@

$footerObj = @"
</center>
</body>
</html>
"@

#Get VM Backup Status
$vmstatus = Get-VMsBackupStatus

# VMs Missing Backups
$missingVMs = @(Get-VMsMissingBackup $vmstatus)

# VMs Successfuly Backed Up
$successVMs = @(Get-VMsSuccessBackup $vmstatus)

# Get Backup Summary Info
$bodySummaryBk = $null
If ($showSummaryBk) {
	$vbrMasterHash = @{
		"Coordinator" = $vbrServer
		"Failed" = @($failedSessionsBk).Count
		"Sessions" = If ($seshListBk) {@($seshListBk).Count} Else {0}
		"Read" = $totalReadBk
		"Transferred" = $totalXferBk
		"Successful" = @($successSessionsBk).Count
		"Warning" = @($warningSessionsBk).Count
		"Fails" = @($failsSessionsBk).Count
		"Running" = @($runningSessionsBk).Count
		"SuccessVM" = @($successVMs).Count
		"FailedVM" = @($missingVMs).Count
	}
	$vbrMasterObj = New-Object -TypeName PSObject -Property $vbrMasterHash

	If ($onlyLastBk) {
		$bodySummaryBk =  $vbrMasterObj | Select @{Name="VBR Server"; Expression = {$_.Coordinator}}, @{Name="Unprotected VMs"; Expression = {$_.FailedVM}},
		@{Name="Protected VMs"; Expression = {$_.SuccessVM}}, @{Name="Jobs Run"; Expression = {$_.Sessions}},
		@{Name="Read (GB)"; Expression = {$_.Read}}, @{Name="Transferred (GB)"; Expression = {$_.Transferred}},
		@{Name="Running"; Expression = {$_.Running}}, @{Name="Successful"; Expression = {$_.Successful}},
		@{Name="Warnings"; Expression = {$_.Warning}},
		@{Name="Failed"; Expression = {$_.Failed}} | ConvertTo-HTML -Fragment
	} Else {
		$bodySummaryBk =  $vbrMasterObj | Select @{Name="VBR Server"; Expression = {$_.Coordinator}}, @{Name="Unprotected VMs"; Expression = {$_.FailedVM}},
		@{Name="Protected VMs"; Expression = {$_.SuccessVM}}, @{Name="Total Sessions"; Expression = {$_.Sessions}},
		@{Name="Read (GB)"; Expression = {$_.Read}}, @{Name="Transferred (GB)"; Expression = {$_.Transferred}},
		@{Name="Running"; Expression = {$_.Running}}, @{Name="Successful"; Expression = {$_.Successful}},
		@{Name="Warnings"; Expression = {$_.Warning}}, @{Name="Failures"; Expression = {$_.Fails}},
		@{Name="Failed"; Expression = {$_.Failed}} | ConvertTo-HTML -Fragment
	}
					
	$bodySummaryBk = $subHead01 + "Backup Results Summary" + $subHead02 + $bodySummaryBk
}

# Get VMs Missing Backups
$bodyMissing = $null
If ($showUnprotectedVMs) {	
	If ($missingVMs -ne $null) {
		$missingVMs = $missingVMs | Sort vCenter, Datacenter, Cluster, Name | ConvertTo-HTML -Fragment
		$bodyMissing = $subHead01err + "VMs with No Successful Backups" + $subHead02 + $missingVMs
	}
}

# Get VMs Successfuly Backed Up
$bodySuccess = $null
If ($showProtectedVMs) {	
	If ($successVMs -ne $null) {
		$successVMs = $successVMs | Sort vCenter, Datacenter, Cluster, Name | ConvertTo-HTML -Fragment
		$bodySuccess = $subHead01 + "VMs with Successful Backups" + $subHead02 + $successVMs
	}
}

# Get Backup Job Status
$bodyJobsBk = @()
If ($showJobsBk) {
        If ($allJobsBk.count -gt 0) {
            Foreach($bkJob in $allJobsBk) {
				$bodyJobsBk += $bkJob | Select @{Name="Job Name"; Expression = {$_.Name}},
	            @{Name="Enabled"; Expression = {$_.Info.IsScheduleEnabled}},
				@{Name="Status"; Expression = {If ($_.IsRunning) {"Working"} Else {"Stopped"}}},
				@{Name="Target Repo"; Expression = {$(Get-VBRBackupRepository | Where {$_.Id -eq $bkJob.Info.TargetRepositoryId}).Name}},
				@{Name="Next Run"; Expression = {If ($_.ScheduleOptions.IsContinious) {"<Continious>"}
					ElseIf ($_.ScheduleOptions.NextRun) {$_.ScheduleOptions.NextRun}
					ElseIf ($_.IsScheduleEnabled -eq $false) {"<Disabled>"}
					ElseIf ($_.ScheduleOptions.OptionsScheduleAfterJob.IsEnabled) {"After [" + $(Get-VBRJob | Where {$_.Id -eq $bkJob.Info.ParentScheduleId}).Name + "]"}
					Else {"<not scheduled>"}}},
	            @{Name="Last Result"; Expression = {If ($_.Info.LatestStatus -eq "None"){""}Else{$_.Info.LatestStatus}}}
			}
			$bodyJobsBk = $bodyJobsBk | Sort "Next Run" | ConvertTo-HTML -Fragment
			$bodyJobsBk = $subHead01 + "Backup Job Status" + $subHead02 + $bodyJobsBk
        }
}

# Get Running Backup Jobs
$bodyRunningBk = $null
If ($showRunningBk) {
        If ($runningSessionsBk.count -gt 0) {
                $bodyRunningBk = $runningSessionsBk | Sort Creationtime | Select @{Name="Job Name"; Expression = {$_.Name}},
                @{Name="Start Time"; Expression = {$_.CreationTime}},
                @{Name="Duration (Mins)"; Expression = {[Math]::Round((New-TimeSpan $(Get-Date $_.Progress.StartTime) $(Get-Date)).TotalMinutes,2)}},
				@{Name="% Complete"; Expression = {$_.Progress.Percents}},
                @{Name="Read (GB)"; Expression = {[Math]::Round([Decimal]$_.Progress.ReadSize/1GB, 2)}},
                @{Name="Write (GB)"; Expression = {[Math]::Round([Decimal]$_.Progress.TransferedSize/1GB, 2)}} | ConvertTo-HTML -Fragment
                $bodyRunningBk = $subHead01 + "Running Backup Jobs" + $subHead02 + $bodyRunningBk
        }
} 

# Get Backup Sessions with Failures or Warnings
$bodySessWFBk = $null
If ($showWarnFailBk) {
        $sessWF = @($warningSessionsBk + $failsSessionsBk)
        If ($sessWF.count -gt 0) {
				If ($onlyLastBk) {
					$headerWF = "Backup Jobs with Warnings or Failures"
				} Else {
					$headerWF = "Backup Sessions with Warnings or Failures"
				}
                If ($showDetailedBk) {
					$bodySessWFBk = $sessWF | Sort Creationtime | Select @{Name="Job Name"; Expression = {$_.Name}},
					@{Name="Start Time"; Expression = {$_.CreationTime}},
	                @{Name="Stop Time"; Expression = {$_.EndTime}},
					@{Name="Duration (Mins)"; Expression = {[Math]::Round($_.WorkDetails.WorkDuration.TotalMinutes,2)}},					
					@{Name="Avg Speed (MB/s)"; Expression = {[Math]::Round($_.Info.Progress.AvgSpeed/1MB,2)}},
					@{Name="Total (GB)"; Expression = {[Math]::Round($_.Info.Progress.ProcessedSize/1GB,2)}},
					@{Name="Processed (GB)"; Expression = {[Math]::Round($_.Info.Progress.ProcessedUsedSize/1GB,2)}},
					@{Name="Data Read (GB)"; Expression = {[Math]::Round($_.Info.Progress.ReadSize/1GB,2)}},
					@{Name="Transferred (GB)"; Expression = {[Math]::Round($_.Info.Progress.TransferedSize/1GB,2)}},					
					@{Name="Details"; Expression = {
					If ($_.GetDetails() -eq ""){($_.GetDetails()).Replace("<br />"," - ") + ($_ | Get-VBRTaskSession | %{If ($_.GetDetails()){$_.Name + ": " + $_.GetDetails()}})}
					Else {($_.GetDetails()).Replace("<br />"," - ")}}},
					Result  | ConvertTo-HTML -Fragment
	                $bodySessWFBk = $subHead01 + $headerWF + $subHead02 + $bodySessWFBk
				} Else {
					$bodySessWFBk = $sessWF | Sort Creationtime | Select @{Name="Job Name"; Expression = {$_.Name}},
					@{Name="Start Time"; Expression = {$_.CreationTime}},
	                @{Name="Stop Time"; Expression = {$_.EndTime}},
					@{Name="Duration (Mins)"; Expression = {[Math]::Round($_.WorkDetails.WorkDuration.TotalMinutes,2)}},
					@{Name="Details"; Expression = {
					If ($_.GetDetails() -eq ""){($_.GetDetails()).Replace("<br />"," - ") + ($_ | Get-VBRTaskSession | %{If ($_.GetDetails()){$_.Name + ": " + $_.GetDetails()}})}
					Else {($_.GetDetails()).Replace("<br />"," - ")}}},
					Result  | ConvertTo-HTML -Fragment
	                $bodySessWFBk = $subHead01 + $headerWF + $subHead02 + $bodySessWFBk
				}
        }
}

# Get Successful Backup Sessions
$bodySessSuccBk = $null
If ($showSuccessBk) {
       If ($successSessionsBk.count -gt 0) {
	   			If ($onlyLastBk) {
					$headerSucc = "Successful Backup Jobs"
				} Else {
					$headerSucc = "Successful Backup Sessions"
				}
                If ($showDetailedBk) {
					$bodySessSuccBk = $successSessionsBk | Sort Creationtime | Select @{Name="Job Name"; Expression = {$_.Name}},
	                @{Name="Start Time"; Expression = {$_.CreationTime}},
	                @{Name="Stop Time"; Expression = {$_.EndTime}},
					@{Name="Duration (Mins)"; Expression = {[Math]::Round($_.WorkDetails.WorkDuration.TotalMinutes,2)}},
					@{Name="Avg Speed (MB/s)"; Expression = {[Math]::Round($_.Info.Progress.AvgSpeed/1MB,2)}},
					@{Name="Total (GB)"; Expression = {[Math]::Round($_.Info.Progress.ProcessedSize/1GB,2)}},
					@{Name="Processed (GB)"; Expression = {[Math]::Round($_.Info.Progress.ProcessedUsedSize/1GB,2)}},
					@{Name="Data Read (GB)"; Expression = {[Math]::Round($_.Info.Progress.ReadSize/1GB,2)}},
					@{Name="Transferred (GB)"; Expression = {[Math]::Round($_.Info.Progress.TransferedSize/1GB,2)}},
					Result  | ConvertTo-HTML -Fragment
	                $bodySessSuccBk = $subHead01 + $headerSucc + $subHead02 + $bodySessSuccBk
				} Else {
					$bodySessSuccBk = $successSessionsBk | Sort Creationtime | Select @{Name="Job Name"; Expression = {$_.Name}},
	                @{Name="Start Time"; Expression = {$_.CreationTime}},
	                @{Name="Stop Time"; Expression = {$_.EndTime}},
					@{Name="Duration (Mins)"; Expression = {[Math]::Round($_.WorkDetails.WorkDuration.TotalMinutes,2)}},
					Result | ConvertTo-HTML -Fragment
	                $bodySessSuccBk = $subHead01 + $headerSucc + $subHead02 + $bodySessSuccBk
				}
        }
}

# Get Running VM Restore Sessions
$bodyRestoRunVM = $null
If ($showRestoRunVM) {
	If ($($runningResto).count -gt 0) {
		$bodyRestoRunVM = $runningResto | Sort CreationTime | Select @{Name="VM Name"; Expression = {$_.Info.VmDisplayName}},
		@{Name="Restore Type"; Expression = {$_.JobTypeString}}, @{Name="Start Time"; Expression = {$_.CreationTime}},		
		@{Name="Initiator"; Expression = {$_.Info.Initiator.Name}},
		@{Name="Reason"; Expression = {$_.Info.Reason}} | ConvertTo-HTML -Fragment
        $bodyRestoRunVM = $subHead01 + "Running VM Restore Sessions" + $subHead02 + $bodyRestoRunVM	
	}
}

# Get Completed VM Restore Sessions
$bodyRestoreVM = $null
If ($showRestoreVM) {
	If ($($completeResto).count -gt 0) {
		$bodyRestoreVM = $completeResto | Sort CreationTime | Select @{Name="VM Name"; Expression = {$_.Info.VmDisplayName}},
		@{Name="Restore Type"; Expression = {$_.JobTypeString}},
		@{Name="Start Time"; Expression = {$_.CreationTime}}, @{Name="Stop Time"; Expression = {$_.EndTime}},        
		@{Name="Duration (Mins)"; Expression = {[Math]::Round((New-TimeSpan $_.CreationTime $_.EndTime).TotalMinutes,2)}},		
		@{Name="Initiator"; Expression = {$_.Info.Initiator.Name}}, @{Name="Reason"; Expression = {$_.Info.Reason}},
		@{Name="Result"; Expression = {$_.Info.Result}} | ConvertTo-HTML -Fragment
        $bodyRestoreVM = $subHead01 + "Completed VM Restore Sessions" + $subHead02 + $bodyRestoreVM	
	}
}

# Get Endpoint Backup Summary Info
$bodySummaryEp = $null
If ($showSummaryEp) {
	$vbrEpHash = @{
		"Coordinator" = $vbrServer
		"Sessions" = If ($seshListEp) {@($seshListEp).Count} Else {0}
		"Successful" = @($successSessionsEp).Count
		"Warning" = @($warningSessionsEp).Count
		"Fails" = @($failsSessionsEp).Count
		"Running" = @($runningSessionsEp).Count
	}
	$vbrEPObj = New-Object -TypeName PSObject -Property $vbrEpHash

	If ($onlyLastEp) {
		$bodySummaryEp =  $vbrEPObj | Select @{Name="VBR Server"; Expression = {$_.Coordinator}}, @{Name="Total Jobs"; Expression = {$_.Sessions}},
		@{Name="Running"; Expression = {$_.Running}}, @{Name="Successful"; Expression = {$_.Successful}},
		@{Name="Warnings"; Expression = {$_.Warning}}, @{Name="Failures"; Expression = {$_.Fails}} | ConvertTo-HTML -Fragment
	} Else {
		$bodySummaryEp =  $vbrEPObj | Select @{Name="VBR Server"; Expression = {$_.Coordinator}}, @{Name="Total Sessions"; Expression = {$_.Sessions}},
		@{Name="Running"; Expression = {$_.Running}}, @{Name="Successful"; Expression = {$_.Successful}},
		@{Name="Warnings"; Expression = {$_.Warning}}, @{Name="Failures"; Expression = {$_.Fails}} | ConvertTo-HTML -Fragment
	}
	
	$bodySummaryEp = $subHead01 + "Endpoint Backup Results Summary" + $subHead02 + $bodySummaryEp
}

# Get Endpoint Backup Job Status
$bodyJobsEp = $null
If ($showJobsEp) {
        If ($allJobsEp.count -gt 0) {
                $bodyJobsEp = $allJobsEp | Select @{Name="Job Name"; Expression = {$_.Name}},
                @{Name="Enabled"; Expression = {$_.IsEnabled}},@{Name="Status"; Expression = {$_.LastState}},
				@{Name="Target Repo"; Expression = {$_.Target}},@{Name="Next Run"; Expression = {"Unknown"}},
                @{Name="Last Result"; Expression = {If ($_.LastResult -eq "None"){""}Else{$_.LastResult}}} | Sort "Next Run" | ConvertTo-HTML -Fragment
                $bodyJobsEp = $subHead01 + "Endpoint Backup Job Status" + $subHead02 + $bodyJobsEp
        }
}

# Get Running Endpoint Backup Jobs
$bodyRunningEp = @()
If ($showRunningEp) {
    If ($runningSessionsEp.count -gt 0) {
    	Foreach($job in $allJobsEp) {
			$bodyRunningEp += $runningSessionsEp | ?{$_.JobId -eq $job.Id} | Select @{Name="Job Name"; Expression = {$job.Name}},
			@{Name="Start Time"; Expression = {$_.CreationTime}},
            @{Name="Duration (Mins)"; Expression = {[Math]::Round((New-TimeSpan $(Get-Date $_.CreationTime) $(Get-Date)).TotalMinutes,2)}}
		}				
	$bodyRunningEp = $bodyRunningEp | Sort-Object "Start Time" | ConvertTo-HTML -Fragment
    $bodyRunningEp = $subHead01 + "Running Endpoint Backup Jobs" + $subHead02 + $bodyRunningEp
    }
}

# Get Endpoint Backup Sessions with Failures or Warnings
$bodySessWFEp = @()
If ($showWarnFailEp) {
        $sessWFEp = @($warningSessionsEp + $failsSessionsEp)
        If ($sessWFEp.count -gt 0) {
				If ($onlyLastEp) {
					$headerWFEp = "Endpoint Backup Jobs with Warnings or Failures"
				} Else {
					$headerWFEp = "Endpoint Backup Sessions with Warnings or Failures"
				}
                Foreach($job in $allJobsEp) {
					$bodySessWFEp += $sessWFEp | ?{$_.JobId -eq $job.Id} | Select @{Name="Job Name"; Expression = {$job.Name}},
					@{Name="Start Time"; Expression = {$_.CreationTime}}, @{Name="Stop Time"; Expression = {$_.EndTime}},
            		@{Name="Duration (Mins)"; Expression = {[Math]::Round((New-TimeSpan $(Get-Date $_.CreationTime) $(Get-Date $_.EndTime)).TotalMinutes,2)}},
					Result
				}
				$bodySessWFEp = $bodySessWFEp | Sort-Object "Start Time" | ConvertTo-HTML -Fragment				
                $bodySessWFEp = $subHead01 + $headerWFEp + $subHead02 + $bodySessWFEp
        }
}

# Get Successful Endpoint Backup Sessions
$bodySessSuccEp = @()
If ($showSuccessEp) {
       If ($successSessionsEp.count -gt 0) {
	   			If ($onlyLastEp) {
					$headerSuccEp = "Successful Endpoint Backup Jobs"
				} Else {
					$headerSuccEp = "Successful Endpoint Backup Sessions"
				}
                Foreach($job in $allJobsEp) {
					$bodySessSuccEp += $successSessionsEp | ?{$_.JobId -eq $job.Id} | Select @{Name="Job Name"; Expression = {$job.Name}},
					@{Name="Start Time"; Expression = {$_.CreationTime}}, @{Name="Stop Time"; Expression = {$_.EndTime}},
            		@{Name="Duration (Mins)"; Expression = {[Math]::Round((New-TimeSpan $(Get-Date $_.CreationTime) $(Get-Date $_.EndTime)).TotalMinutes,2)}},
					Result
				}
				$bodySessSuccEp = $bodySessSuccEp | Sort-Object "Start Time" | ConvertTo-HTML -Fragment				
                $bodySessSuccEp = $subHead01 + $headerSuccEp + $subHead02 + $bodySessSuccEp
        }
}

# Get Proxy Info
$bodyProxy = $null
If ($showProxy) {
	If ($viProxyList -ne $null) {
	        $bodyProxy = Get-vPCProxyInfo | Select @{Name="Proxy Name"; Expression = {$_.ProxyName}},
	        @{Name="Proxy Host"; Expression = {$_.RealName}}, Disabled, @{Name="IP Address"; Expression = {$_.IP}},
			@{Name="RT (ms)"; Expression = {$_.Responce}}, Status | Sort "Proxy Host" |  ConvertTo-HTML -Fragment
	        $bodyProxy = $subHead01 + "Proxy Details" + $subHead02 + $bodyProxy
	}
}

# Get Repository Info
$bodyRepo = $null
If ($showRepo) {
	If ($repoList -ne $null) {
			$bodyRepo = $repoList | Get-vPCRepoInfo | Select @{Name="Repository Name"; Expression = {$_.Target}},
	        @{Name="Host"; Expression = {$_.RepoHost}},
			@{Name="Path"; Expression = {$_.Storepath}}, @{Name="Free (GB)"; Expression = {$_.StorageFree}},
	        @{Name="Total (GB)"; Expression = {$_.StorageTotal}}, @{Name="Free (%)"; Expression = {$_.FreePercentage}},
			@{Name="Status"; Expression = {
				If ($_.FreePercentage -lt $repoCritical) {"Critical"} 
				ElseIf ($_.FreePercentage -lt $repoWarn) {"Warning"}
				ElseIf ($_.FreePercentage -eq "Unknown") {"Unknown"}
				Else {"OK"}}} | `
			Sort "Repository Name" | ConvertTo-HTML -Fragment
	        $bodyRepo = $subHead01 + "Repository Details" + $subHead02 + $bodyRepo
	}
}

# Get Replica Target Info
$bodyReplica = $null
If ($showReplica) {
	If ($repList -ne $null) {
	        $bodyReplica = $repList | Get-vPCReplicaTarget | Select @{Name="Replica Target"; Expression = {$_.Target}}, Datastore,
	        @{Name="Free (GB)"; Expression = {$_.StorageFree}}, @{Name="Total (GB)"; Expression = {$_.StorageTotal}},
	        @{Name="Free (%)"; Expression = {$_.FreePercentage}},
			@{Name="Status"; Expression = {If ($_.FreePercentage -lt $replicaCritical) {"Critical"} ElseIf ($_.FreePercentage -lt $replicaWarn) {"Warning"} Else {"OK"}}} | `
			Sort "Replica Target" | ConvertTo-HTML -Fragment
	        $bodyReplica = $subHead01 + "Replica Details" + $subHead02 + $bodyReplica
	}
}

# Get Veeam Services Info
$bodyServices = $null
If ($showServices) {
	$bodyServices = Get-VeeamServers
	$bodyServices = Get-VeeamServices $bodyServices
	If ($hideRunningSvc) {$bodyServices = $bodyServices | ?{$_.Status -ne "Running"}}
	If ($bodyServices -ne $null) {
		$bodyServices = $bodyServices | Select "Server Name", "Service Name",
		@{Name="Status"; Expression = {If ($_.Status -eq "Stopped"){"Not Running"} Else {$_.Status}}} | Sort "Server Name", "Service Name" | ConvertTo-HTML -Fragment
		$bodyServices = $subHead01 + "Veeam Services" + $subHead02 + $bodyServices	    
	}
}

# Get License Info
$bodyLicense = $null
If ($showLicExp) {
	$bodyLicense = Get-VeeamSupportDate $vbrServer | Select @{Name="Expiry Date"; Expression = {$_.ExpDate}}, @{Name="Days Remaining"; Expression = {$_.DaysRemain}}, `
		@{Name="Status"; Expression = {If ($_.DaysRemain -lt $licenseCritical) {"Critical"} ElseIf ($_.DaysRemain -lt $licenseWarn) {"Warning"} ElseIf ($_.DaysRemain -eq "Failed") {"Failed"} Else {"OK"}}} | `
		ConvertTo-HTML -Fragment
	$bodyLicense = $subHead01 + "License/Support Renewal Date" + $subHead02 + $bodyLicense
}

# Combine HTML Output
$htmlOutput = $headerObj + $bodyTop + $bodySummaryBK + $bodySummaryEp + $bodyMissing + $bodySuccess + $bodyJobsBk + $bodyRunningBk + $bodySessWFBk + 
	$bodySessSuccBk + $bodyRestoRunVM + $bodyRestoreVM + $bodyJobsEp + $bodyRunningEp + $bodySessWFEp + $bodySessSuccEp + $bodyRepo + $bodyProxy +
	$bodyReplica + $bodyServices + $bodyLicense + $footerObj

# Add color to output depending on results
#Green
$htmlOutput = $htmlOutput.Replace("<td>Running<","<td style=""background-color: Green;color: White;"">Running<")
$htmlOutput = $htmlOutput.Replace("<td>OK<","<td style=""background-color: Green;color: White;"">OK<")
$htmlOutput = $htmlOutput.Replace("<td>Alive<","<td style=""background-color: Green;color: White;"">Alive<")
$htmlOutput = $htmlOutput.Replace("<td>Success<","<td style=""background-color: Green;color: White;"">Success<")
#Yellow
$htmlOutput = $htmlOutput.Replace("<td>Warning<","<td style=""background-color: Yellow;"">Warning<")
#Red
$htmlOutput = $htmlOutput.Replace("<td>Not Running<","<td style=""background-color: Red;color: White;"">Not Running<")
$htmlOutput = $htmlOutput.Replace("<td>Failed<","<td style=""background-color: Red;color: White;"">Failed<")
$htmlOutput = $htmlOutput.Replace("<td>Critical<","<td style=""background-color: Red;color: White;"">Critical<")
$htmlOutput = $htmlOutput.Replace("<td>Dead<","<td style=""background-color: Red;color: White;"">Dead<")
#endregion
 
#region Output
If ($sendEmail) {
        $smtp = New-Object System.Net.Mail.SmtpClient $emailHost
        $smtp.Credentials = New-Object System.Net.NetworkCredential($emailUser, $emailPass);
		$msg = New-Object System.Net.Mail.MailMessage($emailFrom, $emailTo)
		$msg.Subject = $emailSubject
		If ($emailAttach) {
			$body = "Veeam Report Attached"
			$msg.Body = $body
			$tempfile = "$env:TEMP\$rptTitle.htm"
			$htmlOutput | Out-File $tempfile
			$attachment = new-object System.Net.Mail.Attachment $tempfile
      		$msg.Attachments.Add($attachment)
			
		} Else {
			$body = $htmlOutput
			$msg.Body = $body
			$msg.isBodyhtml = $true
		}       
        $smtp.send($msg)
		If ($emailAttach) {
			$attachment.dispose()
			Remove-Item $tempfile
		}
}
        
If ($saveFile) {       
	$htmlOutput | Out-File $outFile
	If ($launchFile) {
		Invoke-Item $outFile
	}
}
#endregion