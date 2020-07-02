$in_vmhost = Read-Host -Prompt "Input Host Name"
$vmhost = Get-VMHost $in_vmhost
$esxcli = $vmhost | get-esxcli -V2
if(($esxcli.network.ip.netstack.list.Invoke()).Key -notcontains "vmotion") {
    $esxcli.network.ip.netstack.add.invoke(@{netstack='vmotion'})
}
$vmk_vmotion  = $vmhost | Get-VMHostNetworkAdapter | ?{$_.vmotionenabled -eq $true}
$vmk_vmotion | Remove-VMHostNetworkAdapter
$esxcli.network.ip.interface.add.Invoke(@{interfacename='vmk100';portgroupname='VMotion';netstack='vmotion'})
$vmhost | Get-VMHostNetworkAdapter -VMKernel -Name vmk100 | Set-VMHostNetworkAdapter -IP $vmk_vmotion.IP -SubnetMask $vmk_vmotion.SubnetMask