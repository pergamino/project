# Obtener precios de cafe.
from decimal import Decimal
import requests
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

url = 'http://www.ico.org/'
html_text = requests.get(url).text
lines = html_text.splitlines()
i = 0
_fecha = ""
_icocomposite = ""
_colmilds = ""
_othmilds = ""
_brmilds = ""
_robmilds = ""
for line in lines:
    if "<td colspan=\"3\" class=\"first\"><a href=\"/prices/pr-prices.pdf\" target=\"_blank\" style=\"font-weight:bold;font-size:12pt;\">ICO Indicator prices</a>" in line:
        parts = line.split("<strong>")
        fecha = parts[1].split("</strong>")
        _fecha = fecha[0]
        print(_fecha)
    if "td width=\"\" valign=\"top\"><strong>ICO Composite</strong></td>" in line:
        icoparts = lines[i + 1].split("<strong>")
        icocomposite = icoparts[1].split("</strong>")
        _icocomposite = icocomposite[0]
        print(_icocomposite)
    if "<td width=\"\" valign=\"top\">Colombian Milds</td>" in line:
        colparts = lines[i + 1].split(">")
        colmilds = colparts[1].split("<")
        _colmilds = colmilds[0]
        print(_colmilds)
    if "<td width=\"\" valign=\"top\">Other Milds</td>" in line:
        othparts = lines[i + 1].split(">")
        othmilds = othparts[1].split("<")
        _othmilds = othmilds[0]
        print(_othmilds)
    if "<td width=\"\" valign=\"top\">Brazilian Naturals</td>" in line:
        brparts = lines[i + 1].split(">")
        brmilds = brparts[1].split("<")
        _brmilds = brmilds[0]
        print(_brmilds)
    if "<td width=\"\" valign=\"top\">Robustas</td>" in line:
        robparts = lines[i + 1].split(">")
        robmilds = robparts[1].split("<")
        _robmilds = robmilds[0]
        print(_robmilds)
    i = i + 1

pwurl = "https://localhost:5001"
pwtoken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoidmlnaWxhbmNpYUBwZXJnYW1pbm93ZWIuY29tIiwiZXhwIjoxNjA3OTEzMDIwLCJpc3MiOiJwZXJnYW1pbm93ZWIiLCJhdWQiOiJQZXJnYW1pbm9BcHBVc2VycyJ9.45UrFmDHyleelPDwAQT1EVra2E2C3cNo1iPGxZzK0ME"
pwrefreshtoken = "8dsFx47x63xhFcaV7+Q8X/nNRoiUz1afR/BUalCoytQ="
resultrefresh = requests.post(pwurl + "/api/authentication/refresh", verify=False, json={"OldToken":pwtoken,"RefreshToken":pwrefreshtoken}, headers={"Content-Type":"application/json"})
print(resultrefresh.status_code)
if resultrefresh.status_code == 200:
    ntoken = resultrefresh.text
    h = {
        "Authorization": "Bearer " + ntoken,
        "Content-Type": "application/json"
    }
    resultinsert = requests.post(pwurl + "/api/replicacion/saveCoffeeIndicators", json={"fecha":_fecha,"composite":_icocomposite,"colombian":_colmilds,"other":_othmilds,"brnaturals":_brmilds,"robustas":_robmilds}, verify=False, headers=h)
    print(resultinsert)