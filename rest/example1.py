import requests,json,base64,pdb,yaml,os
from requests.packages.urllib3.exceptions import InsecureRequestWarning
requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

manager="192.168.0.102" 
user="admin"
password="Nicira123$"

cred=base64.b64encode('%s:%s'%(user,password))
header={"Authorization":"Basic %s"%cred,"Content-type":"application/json"}

t1uuid="a1007201-e70f-427b-a8d4-e479cfbda7f7"

ep="/api/v1/logical-routers/%s/nat/rules"%t1uuid
url="https://"+str(manager)+str(ep)
body="""{
"action":"DNAT",
"match_destination_network":"192.168.99.176",
"match_service":{"resource_type":"L4PortSetNSService","destination_ports":["1234"],"l4_protocol":"TCP"},
"translated_network":"192.168.100.176",
"translated_ports":"5678",
"enabled":"true"
}
"""
print body
conn=requests.post(url,verify=False,headers=header,data=body)
result=json.loads(conn.text)
print result.get('id')


