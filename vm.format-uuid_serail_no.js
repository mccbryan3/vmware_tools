function vm_format_uuid(uuid) {
    
    var new_uuid = "VMWARE-"
    uuid = uuid.replace(/-/g,"")

    for (i=0;i<uuid.length;i+=2) {
        if(new_uuid.length == 28) {var del = "-"} else {var del = " "}
        new_uuid += uuid.substring(i, i+2) + del
    }
    return new_uuid.substring(0, new_uuid.length - 1)
}

var uuid_bios = vm_format_uuid("421419c6-2f79-5e3b-45b8-11256bf0bd0b")
WScript.Echo(uuid_bios)