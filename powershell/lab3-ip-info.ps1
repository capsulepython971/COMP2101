get-ciminstance win32_networkadapterconfiguration | where-object IPEnabled | format-table -property index,ipaddress,ipsubnet,dnsdomain,dnsserversearchorder

#index, (index)
#ip address(es) (ipaddress)
#subnet mask(s), (ipsubnet)
#dns domain name, (dnsdomain)
#and dns server., (dnsserversearchorderdnsserversearchorder)