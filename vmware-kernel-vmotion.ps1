$in_vmhost = Read-Host -Prompt "Input Host Name"
$vmhost = Get-VMHost $in_vmhost
$esxcli = $vmhost | get-esxcli -V2
$vmk_vmotion  = $vmhost | Get-VMHostNetworkAdapter | ?{$_.vmotionenabled -eq $true}
if(($esxcli.network.ip.netstack.list.Invoke()).Key -notcontains "vmotion") {
    $esxcli.network.ip.netstack.add.invoke(@{netstack='vmotion'})
}
$esxcli.network.ip.interface.add.Invoke(@{interfacename='vmk100';portgroupname=$vmk_vmotion.PortGroupName;netstack='vmotion'})
$vmk_vmotion | Remove-VMHostNetworkAdapter
$vmhost | Get-VMHostNetworkAdapter -VMKernel -Name vmk100 | Set-VMHostNetworkAdapter -IP $vmk_vmotion.IP -SubnetMask $vmk_vmotion.SubnetMask