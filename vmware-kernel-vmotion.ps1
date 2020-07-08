$in_vmhost = Read-Host -Prompt "Input Host Name"
$vmhost = Get-VMHost $in_vmhost
$esxcli = $vmhost | get-esxcli -V2
# Get the current vmkernel port enabled for vmotion
$vmk_vmotion  = $vmhost | Get-VMHostNetworkAdapter | ?{$_.vmotionenabled -eq $true}
# Check for the vmotion netstack and add it if it is not there
if(($esxcli.network.ip.netstack.list.Invoke()).Key -notcontains "vmotion") {
    $esxcli.network.ip.netstack.add.invoke(@{netstack='vmotion'})
}
$esxcli.network.ip.interface.add.Invoke(@{interfacename='vmk100';portgroupname=$vmk_vmotion.PortGroupName;netstack='vmotion'})
## Grab the gateway from the orginal vmkernal port
$vmk_vmotion_gateway = ($esxcli.network.ip.interface.ipv4.get.Invoke() | ?{$_.name -eq $vmk_vmotion.name}).gateway
## Remove the orginal vmkernel port
$vmk_vmotion | Remove-VMHostNetworkAdapter
## Set IP parameters to the old vmkernel port
$vmhost | Get-VMHostNetworkAdapter -VMKernel -Name vmk100 | Set-VMHostNetworkAdapter -IP $vmk_vmotion.IP -SubnetMask $vmk_vmotion.SubnetMask
## If there is a seperate gateway assigned to the original set it here
if($vmk_vmotion_gateway) {
    $esxcli.network.ip.interface.ipv4.set.Invoke(@{interfacename='vmk100';gateway=$vmk_vmotion_gateway;type='static';ipv4=$vmk_vmotion.IP;netmask=$vmk_vmotion.SubnetMask})
}