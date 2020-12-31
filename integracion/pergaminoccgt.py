# Integracion Pergamino CoffeeCloud Guatemala
import requests
from datetime import date, timedelta
def get_first_day(dt, d_years=0, d_months=0):
    # d_years, d_months are "deltas" to apply to dt
    y, m = dt.year + d_years, dt.month + d_months
    a, m = divmod(m-1, 12)
    return date(y+a, m+1, 1)
def get_last_day(dt):
    return get_first_day(dt, 0, 1) + timedelta(-1)
d = date.today()
firstday = get_first_day(d,d_years=0,d_months=-1)
lastday = get_last_day(firstday)
range = firstday.strftime("%Y/%m/%d") + " - " + lastday.strftime("%Y/%m/%d")
ccurl = "https://dev.coffeecloudapp.com"
pwurl = "https://localhost:5001"
cctoken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoicGVyZ2FtaW5vQGNvZmZlZWNsb3VkYXBwLmNvbSIsImV4cCI6MTYwNzgxMTk4OCwiaXNzIjoiQ29mZmVlQ2xvdWRBcHAiLCJhdWQiOiJDb2ZmZUNsb3VkQXBwVXNlcnMifQ.KHBfWSbEY3YYbIjjRp7i-6InQffctYdM1hk3DE1_Cfw"
pwtoken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoidmlnaWxhbmNpYUBwZXJnYW1pbm93ZWIuY29tIiwiZXhwIjoxNjA3OTEzMDIwLCJpc3MiOiJwZXJnYW1pbm93ZWIiLCJhdWQiOiJQZXJnYW1pbm9BcHBVc2VycyJ9.45UrFmDHyleelPDwAQT1EVra2E2C3cNo1iPGxZzK0ME"
ccrefreshtoken = "3mX8CI4bE+JNKwNqQoBhCPiluSJ8ZZxMpNw+sSwTeF8="
pwrefreshtoken = "8dsFx47x63xhFcaV7+Q8X/nNRoiUz1afR/BUalCoytQ="
resultrefresh = requests.post(ccurl + "/api/authentication/refresh", verify=False, json={"OldToken":cctoken,"RefreshToken":ccrefreshtoken}, headers={"Content-Type":"application/json"})
if resultrefresh == 200:
    ntoken = resultrefresh.text
    h = {
        "Authorization": "Bearer " + ntoken,
        "Content-Type": "application/json"
    }
    resultdata = requests.post(ccurl + "/get-datos-evaluaciones-pergamino", json={"range":range}, verify=False, headers=h)
    data = resultdata.json()
    elements = data[0]
    for item in elements:
        item["pais"] = "GT"
    resultrefresh = requests.post(pwurl + "/api/authentication/refresh", verify=False, json={"OldToken":pwtoken,"RefreshToken":pwrefreshtoken}, headers={"Content-Type":"application/json"})
    if resultrefresh == 200:
        ntoken = resultrefresh.text
        h = {
            "Authorization": "Bearer " + ntoken,
            "Content-Type": "application/json"
        }
        resultinsert = requests.post(pwurl + "/api/replicacion/saveVigilanciaExterna", json={"vigilancia":elements}, verify=False, headers=h)
