param (
    [Parameter(Mandatory=$True)]
    [string]$VIServer,
    [Parameter(Mandatory=$True)]
    [string]$VMName,
    [Parameter(Mandatory=$False)]
    [int]$SnapAge = 7,
    [Parameter(Mandatory=$False)]
    [bool]$Quiesce = $False   
)

if(-not $(Test-Connection $VIServer)) {
    "error connecting to VIServer"
    exit
}

try {
    connect-viserver $VIServer | Out-Null
} catch {"Error connecting to VI Server : $($_.error)"}

try {
    $VM = Get-VM $VMName
    if($VM) {
        $VM | Get-Snapshot | Where-Object{$_.created -lt $(get-date).AddDays(-7)}  | Remove-Snapshot
        $VM | New-Snapshot -Name "backup_snap - $(Get-Date)" -Description "Taken programatically - $(Get-Date)" -Quiesce:$Quiesce
    } else {"Check VM Name..\nSpecified VM not located."}
} catch {"Error : $($_.error)"}