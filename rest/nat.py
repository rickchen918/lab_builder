from __future__ import print_function
from argparse import ArgumentParser

manager="192.168.0.102" 
user="admin"
password="Nicira123$"

import requests,json,base64,pdb
from requests.packages.urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

parser = ArgumentParser()
parser.add_argument("t1_LR_uuid", help="nsx tier1 LR UUID")
parser.add_argument("dest_ip", help="Destination NAT IP listening")
parser.add_argument("dest_port", help="Destinaion NAT port listening")
parser.add_argument("translated_ip", help="Translated IP Address")
parser.add_argument("translated_port", help="Translated port listening")
#parser.add_argument("-o", "--optional-arg", help="optional argument", dest="opt", default="default")

arg = parser.parse_args()

cred=base64.b64encode('%s:%s'%(user,password))
header={"Authorization":"Basic %s"%cred,"Content-type":"application/json"}

t1uuid = arg.t1_LR_uuid

ep="/api/v1/logical-routers/%s/nat/rules"%t1uuid
url="https://"+str(manager)+str(ep)
body="""{
"action":"DNAT",
"match_destination_network":"%s",
"match_service":{"resource_type":"L4PortSetNSService","destination_ports":["%s"],"l4_protocol":"TCP"},
"translated_network":"%s",
"translated_ports":"%s",
"enabled":"true"
}
"""%(arg.dest_ip,arg.dest_port,arg.translated_ip,arg.translated_port)

conn=requests.post(url,verify=False,headers=header,data=body)

print(conn.text)
