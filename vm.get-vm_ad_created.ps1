connect-viserver vc02
Function Get-VMADCreated {

    get-vm | %{
        $ad_obj = $null
        $ad_name = $null
        $ad_created = $null
        $ad_state = "NotLocated"
        $vm_name = $_.name
        try {
            $ad_obj = get-adcomputer $vm_name -Properties whenCreated
            $ad_name = $ad_obj.Name
            $ad_created = $ad_obj.whenCreated
            $ad_state = "Located"
        } catch {}
        $obj = [PSCustomObject]@{
            "VMName" = $vm_name
            "ADName" = $ad_name
            "ADCreated" = $ad_created
            "ADState" = $ad_state
        }

        return $obj
    }
}

Get-VMADCreated | export-csv check.csv -NotypeInformation