 #Hardware description
 write-output "Hardware Description"
 Get-WmiObject -class win32_computersystem | 
 foreach {
            new-object -Typename psobject -property @{
                    Manufacturer = $_.manufacturer
                    Model = $_.model
            }
} |
format-list  Manufacturer, Model


#operating system and version
write-output "operating system and version"
Get-WmiObject -class win32_operatingsystem | 
foreach {
            new-object -Typename psobject -property @{
                    "Operating System" = $_.Caption
                    Version = $_.Version
            }
} |
format-list "Operating System", Version

#Proccessor info
Write-Output "Proccesor info"
Get-WmiObject -class win32_processor | 
foreach {
            new-object -Typename psobject -property @{
                    "Clock Speed" = $_.currentclockspeed/1000 
                    "Number of Cores" = $_.threadcount/2 
                    "L2 Cache Size" = $_.L2CacheSize
                    "L3 Cache Size" = $_.L3CacheSize
            }
} |
format-list "Clock Speed", "Number of Cores", "L2 Cache Size", "L3 Cache Size" 

#ram 
write-output "Ram info"
$totalcapacity = 0
get-wmiobject -class win32_physicalmemory |
foreach {
            new-object -TypeName psobject -Property @{
                    Manufacturer = $_.manufacturer
                    "Speed(MHz)" = $_.speed
                    "Size(GB)" = $_.capacity/1gb
                    Bank = $_.banklabel
                    Slot = $_.devicelocator
            }
            $totalcapacity += $_.capacity/1gb
} |
ft -auto Manufacturer, "Size(GB)", "Speed(MHz)", Bank, Slot
"Total GB of RAM: ${totalcapacity}GB "

#Diskdrive info

$diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{Manufacturer=$disk.Manufacturer
                                                               Model= $disk.model
                                                               Location=$partition.deviceid
                                                              "Free space" =$logicaldisk.deviceid
                                                               "Size(GB)"=$logicaldisk.size / 1gb -as [int]
                                                               "Size Free(GB)"=$logicaldisk.size / 1gb -as [int]

                                                               }
           }
      }
  }

format-table   Manufacturer, model, location,drive, "size(GB)"
 


 #networking info
Write-Output "Network Adapter info"
Get-WmiObject -class win32_networkadapterconfiguration| 
foreach {
            new-object -Typename psobject -property @{
                    "Index" = $_.index 
                    "Ip Address" = $_.ipaddress
                    "Subnet Mask(s)" = $_.ipsubnet
                    "DNS Domain Name" = $_.dnsdomain
                    "DNS Server" = $_.dnsserversearchorder
            }
} |
ft -auto "Index", "Ip address", "ipsubnet", "DNS Domain Name", "DNS Server"

 #Video Adpater info
Write-Output "Video Adapter info"
Get-WmiObject -class win32_videocontroller| 
foreach {
            new-object -Typename psobject -property @{
                    
                    "Make/Model" = $_.description
                    "Resolution" = $_.VideoModeDescription 
                  
            }
} |
format-list "Make/Model", "Resolution"