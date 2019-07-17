import requests,json,base64,pdb,os

manager="192.168.0.140"
user="admin"
password="Nicira123$Nicira123$"
cred=base64.b64encode('%s:%s'%(user,password))
header={"Authorization":"Basic %s"%cred,"Content-type":"application/json","X-Allow-Overwrite":"true"} # the header X-Allow-Overwrite is the key to delete protected inventory

### define get pks created lsw 
def get_protected_lsw():
    ep="/api/v1/logical-switches"
    url="https://"+str(manager)+str(ep)
    conn=requests.get(url,verify=False,headers=header)
    result=json.loads(conn.text).get('results')
    matrix=[]
    for x in result:
        if "pks" in x.get('display_name'):
            uuid=x.get('id')
            matrix.append(uuid)
        else:
            continue
    
    for y in matrix:
        ep="/api/v1/logical-switches/%s?detach=true&cascade=true"%y 
        url="https://"+str(manager)+str(ep)
        conn=requests.delete(url,verify=False,headers=header)
        print conn.status_code

def get_protected_lr():
    ep="/api/v1/logical-routers"
    url="https://"+str(manager)+str(ep)
    conn=requests.get(url,verify=False,headers=header)
    result=json.loads(conn.text).get('results')
    matrix=[]
    for x in result:
        if "pks" in x.get('display_name'):
            uuid=x.get('id')
            matrix.append(uuid)
        else:
            continue
    
    for y in matrix:
        ep="/api/v1/logical-routers/%s?force=true"%y 
        url="https://"+str(manager)+str(ep)
        conn=requests.delete(url,verify=False,headers=header)
        print conn.status_code

def get_protected_lb():
    ep="/api/v1/loadbalancer/services"
    url="https://"+str(manager)+str(ep)
    conn=requests.get(url,verify=False,headers=header)
    result=json.loads(conn.text).get('results')
    matrix=[]
    for x in result:
        if "pks" in x.get('display_name'):
            uuid=x.get('id')
            matrix.append(uuid)
        else:
            continue
    
    for y in matrix:
        ep="/api/v1/loadbalancer/services/%s"%y 
        url="https://"+str(manager)+str(ep)
        conn=requests.delete(url,verify=False,headers=header)
        print conn.status_code

def get_dfwsection():
    ep="/api/v1/firewall/sections"
    url="https://"+str(manager)+str(ep)
    conn=requests.get(url,verify=False,headers=header)
    result=json.loads(conn.text).get('results')
    matrix=[]
    for x in result:
        y=x.get('id') # get dfw session uuid 
        matrix.append(y)
        print matrix

    for kill in matrix:
        url="https://"+str(manager)+str(ep)+"/"+str(kill)+"?cascade=True"
        conn=requests.delete(url,verify=False,headers=header)
        if conn.status_code == 200:
            print "the section "+str(kill)+" is deleted"
        else:
            print conn.text
            pass

get_protected_lsw()
get_protected_lr()
get_protected_lb()
get_dfwsection()

