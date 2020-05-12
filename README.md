# vm.alarm-attr.py

This was built to write attributes to custom attributes on machine creation.

This script shoudl be placed on the VCSA and called from an alarm rule

The attributes are hard coded so they will need to be modified to suite the needs

# vm.snapshot_vm.ps1

This one takes snaps using PowerCLI and should be ran from PoSH

It will also delete any snaps older than 7 days by default

There are flags to change the purge date of the snaps on the target VM - default 7

# vm.get-vm_ad_created.ps1

Reads and exports whenCreated data from AD to a CSV if the VM exists. Outputs DomainState to knoiw if it exists

# find-vmhost-lun-no-datastore.ps1

Lists luns on vmhosts that are not configured as VMFS datastores are start with  the mpx prefix. This should give you a list to bounce off of a list of RDMs from the VM side. 

# vm.format-uuid_serail_no.js

This formats the VM name based on uuid from BIOS (vmname_uuid) primarily for Ansible Tower use.
