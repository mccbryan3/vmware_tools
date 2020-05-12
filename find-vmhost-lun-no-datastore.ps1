try{
    $luns = get-vmhost desx02.lab.loc | Get-Datastore | Get-ScsiLun -ErrorAction SilentlyContinue
    # $luns.CanonicalName
} catch {
    "Error getting lun info for one or more luns"
}
$array = @()
Get-VMHost | Get-ScsiLun | ?{$_.CanonicalName -notlike "mpx.*"} | %{
    if(($luns.CanonicalName -notcontains $_.CanonicalName) -and ($array -notcontains $_.CanonicalName)) {
        $array += $_.CanonicalName
        $hash = @{
            VMHost = $_.VMHost 
            RuntimeName = $_.RuntimeName
            LunId = [regex]::Match($_.RuntimeName, "L\d+").Value
            CanonicalName = $_.CanonicalName
            Model = $_.Model
            Vendor = $_.Vendor
            CapacityGB = $_.CapacityGB
        }
    }
    New-Object psobject -Property $hash
    $hash = $null
}