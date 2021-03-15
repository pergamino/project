import requests
from datetime import date, timedelta
pwregurl = "https://admin.redpergamino.net"
pwpaiurl = "https://localhost:5001"
pwregtoken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW5AcGVyZ2FtaW5vd2ViLmNvbSIsImV4cCI6MTYxNTY2MjI1MywiaXNzIjoicGVyZ2FtaW5vd2ViIiwiYXVkIjoiUGVyZ2FtaW5vQXBwVXNlcnMifQ.XUvoUw9JWmPzQ1N0jvxgP6j5IK_onhHfOqIZUNOXGMA"
pwpaitoken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiYWRtaW5AcGVyZ2FtaW5vd2ViLmNvbSIsImV4cCI6MTYxNTY2MjI1MywiaXNzIjoicGVyZ2FtaW5vd2ViIiwiYXVkIjoiUGVyZ2FtaW5vQXBwVXNlcnMifQ.XUvoUw9JWmPzQ1N0jvxgP6j5IK_onhHfOqIZUNOXGMA"
pwregrefreshtoken = "C0VFD5iDWGpW1wV+ULMF+sSnMlsZDOiPUdeIsUNU4ME="
pwpairefreshtoken = "C0VFD5iDWGpW1wV+ULMF+sSnMlsZDOiPUdeIsUNU4ME="
resultrefresh = requests.post(pwregurl + "/api/authentication/refresh", verify=True, json={"OldToken":pwregtoken,"RefreshToken":pwregrefreshtoken}, headers={"Content-Type":"application/json"})
if resultrefresh.status_code == 200:
    ntoken = resultrefresh.text
    h = {
        "Authorization": "Bearer " + ntoken,
        "Content-Type": "application/json"
    }
    resultdata = requests.post(pwregurl + "/api/replicacion/getDataReplicacionMapAlerta", verify=True, headers=h)
    data = resultdata.json()
    resultrefresh = requests.post(pwpaiurl + "/api/authentication/refresh", verify=False, json={"OldToken":pwpaitoken,"RefreshToken":pwpairefreshtoken}, headers={"Content-Type":"application/json"})
    if resultrefresh.status_code == 200:
        ntoken = resultrefresh.text
        h = {
            "Authorization": "Bearer " + ntoken,
            "Content-Type": "application/json"
        }
        resultdata = requests.post(pwpaiurl + "/api/replicacion/saveDataReplicacionAlerta", json=data, verify=False, headers=h)
        data = resultdata.json()
