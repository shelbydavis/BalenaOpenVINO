# BalenaOpenVINO
OpenVINO Docker image for use with BalenaCloud

## Host OS Requirements

This requires the Raspberry Pi 3 or 4 host image from
[Balena](https://balena.io), and the following addition to
`/mnt/boot/config.json` (inserted as a final entry in the JSON
dictionary, i.e. paste it before the final curly bracket)

```JSON
"os" : { 
  "udevRules": { 
    "97" : "SUBSYSTEM==\"usb\", ATTRS{idProduct}==\"2150\", ATTRS{idVendor}==\"03e7\", GROUP=\"users\", MODE=\"0660\", ENV{ID_MM_DEVICE_IGNORE}=\"1\"", 
    "98" : "SUBSYSTEM==\"usb\", ATTRS{idProduct}==\"2485\", ATTRS{idVendor}==\"03e7\", GROUP=\"users\", MODE=\"0660\", ENV{ID_MM_DEVICE_IGNORE}=\"1\"", 
    "99" : "SUBSYSTEM==\"usb\", ATTRS{idProduct}==\"f63b\", ATTRS{idVendor}==\"03e7\", GROUP=\"users\", MODE=\"0660\", ENV{ID_MM_DEVICE_IGNORE}=\"1\"" 
  } 
} 
```
