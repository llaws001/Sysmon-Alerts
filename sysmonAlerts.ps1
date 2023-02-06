$eventIDs = @(6,7,4,8,9,14,15,16,17,18,255)
$sysmonEvents =  Get-WinEvent  -FilterHashtable @{LogName='Microsoft-Windows-Sysmon/Operational'; ID=$eventIDs}
$DesktopPath = [Environment]::GetFolderPath("Desktop")

#notification balloon
if ($sysmonEvents.TimeCreated -gt (Get-Date).AddHours(-24)){
    [reflection.assembly]::loadwithpartialname('System.Windows.Forms')
    [reflection.assembly]::loadwithpartialname('System.Drawing')
    $notify = new-object system.windows.forms.notifyicon
    $notify.icon = [System.Drawing.SystemIcons]::Information
    $notify.visible = $true
    $notify.showballoontip(10,'WARNING','Sysmon has detected potential malicious activity',[system.windows.forms.tooltipicon]::None)


    $sysmonEvents | select TimeCreated, id, Message| export-csv -Path $DesktopPath\SysmonAlerts.csv -NoTypeInformation
    
   }