# vm.alarm-attr.py

This was built to write attributes to custom attributes on machine creation.

This script shoudl be placed on the VCSA and called from an alarm rule

The attributes are hard coded so they will need to be modified to suite the needs

# vm.snapshot_vm.ps1

This one takes snaps using PowerCLI and should be ran from PoSH

It will also delete any snaps older than 7 days by default

There are flags to change the purge date of the snaps on the target VM - default 7
