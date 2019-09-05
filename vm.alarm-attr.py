#!/usr/bin/python

##
## To be ran on the VCSA and called via alarm rule
##

import sys
from getpass import getpass
from datetime import datetime
import ssl
import os

sys.path.extend(os.environ['VMWARE_PYTHON_PATH'].split(';'))

from pyVim import connect
from pyVim.connect import SmartConnect
from pyVmomi import vim

alarm_name = os.getenv('VMWARE_ALARM_NAME', 'debug_VMWARE_ALARM_NAME')
alarm_target_name = os.getenv('VMWARE_ALARM_TARGET_NAME', 'debug_VMWARE_ALARM_TARGET_NAME')
event_decscription = os.getenv('VMWARE_ALARM_EVENTDESCRIPTION', 'debug_VMWARE_ALARM_EVENTDESCRIPTION')
alarm_value = os.getenv('VMWARE_ALARM_ALARMVALUE', 'debug_VMWARE_ALARM_EVENTDESCRIPTION')
alarm_vm = os.getenv('VMWARE_ALARM_EVENT_VM', 'debug_VMWARE_ALARM_EVENT_VM')
alarm_user = os.getenv('VMWARE_ALARM_EVENT_USERNAME', 'debug_VMWARE_ALARM_EVENT_USERNAME')

if alarm_vm != 'debug_VMWARE_ALARM_EVENT_VM':

    s=ssl.SSLContext(ssl.PROTOCOL_SSLv23) # For VC 6.5/6.0 s=ssl.SSLContext(ssl.PROTOCOL_TLSv1)
    s.verify_mode=ssl.CERT_NONE
    
    # The pwd variable will need to be to a real password. 
    # Perhaps using a lookup from a vault. 
    # This is not built into this script
    # Of course "vcenter" and "user" will need to be updated as well

    si = SmartConnect(host="vcenter", user="user", pwd=getpass(), sslContext=s)
    content=si.content
    
    def find_vm_obj(content, vimtype, name):
        obj = {}
        container = content.viewManager.CreateContainerView(content.rootFolder, vimtype, True)
        for c in container.view:
            if name:
                if c.name == name:
                    obj = c
                break
            else:
                obj = c
                break
        return obj
    
    vm = find_vm_obj(content, [vim.VirtualMachine], alarm_vm) 
    
    if vm:

        f = open('output.txt', 'a+')
        f.write(alarm_name + "\n")
        f.write(alarm_target_name + "\n" )
        f.write(event_decscription + "\n")
        f.write(alarm_value + "\n")
        f.close()
      
        vm.setCustomValue('vm.owner', alarm_user)
        vm.setCustomValue('vm.provisioned', str(datetime.now().strftime('%Y-%m-%d %H:%M:%S')))