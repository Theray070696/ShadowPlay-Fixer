function Kill-Tree {
    Param(
    [Parameter(ValueFromPipeline=$true)]
    [int]$ppid)
    Write-Host "Got $ppid"
    if($ppid -eq 0)
    {
        return
    }
    Get-CimInstance Win32_Process | Where-Object { $_.ParentProcessId -eq $ppid } | ForEach-Object { Kill-Tree $_.ProcessId }
    Stop-Process -Id $ppid -Force
}

$FailCount = 0

while($True)
{
    $FailCount -= 1
    
    $Date = Get-Date -Format "MM-dd-yyyy HH-mm"

    $ECodes = '-2147023436|-2147220934|-2147467259'

    $ECodeExists = Select-String -Path "$Env:userprofile\AppData\Local\NVIDIA Corporation\NvNode\nvnode.log" -Pattern $ECodes

    if($ECodeExists -eq $null)
    {
        Start-Sleep -Seconds 60
        continue
    }
    
    if($FailCount > 5 -and $FailCount < 10)
    {
        $FailCount += 1
        Start-Process -Path 'C:\Program Files\NVIDIA Corporation\NVIDIA GeForce Experience\NVIDIA GeForce Experience.exe'
        Start-Sleep -Seconds 60
        continue
    }

    if($ECodeExists -Match "-2147467259" -or $FailCount >= 10)
    {
        New-BurntToastNotification -Text "ShadowPlay failed to start. The system must be rebooted to fix it."
        exit
    }

    Start-Transcript -Path "D:\theray070696\Desktop\Fix-Shadowplay-$Date.log"

    @(Get-Process -Name 'nvcontainer').Id | Kill-Tree

    @(Get-Process -Name 'NVDisplay.Container').Id | Kill-Tree

    @(Get-Process -Name 'nvsphelper64').Id | Kill-Tree

    @(Get-Process -Name 'Nvidia Share').Id | Kill-Tree

    @(Get-Process -Name 'Nvidia Web Helper').Id | Kill-Tree

    @(Get-Process -Name 'NvOAWrapperCache').Id | Kill-Tree

    @(Get-Process -Name 'OAWrapper').Id | Kill-Tree

    #@(Get-Process -Name 'Nvidia Web Helper').Id | Kill-Tree
    
    Clear-Content -Path "$Env:userprofile\AppData\Local\NVIDIA Corporation\NvNode\nvnode.log"
    
    $FailCount += 2

    Stop-Transcript

    Start-Sleep -Seconds 60
}