import requests
from bs4 import BeautifulSoup
import sys

def loadPage(url):
    headers = {
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/38.0.2171.95 Safari/537.36"
    }
    r = requests.get(url,headers = headers)
    return r.text
    
def getTableBody(html):
    soup = BeautifulSoup(html, 'html.parser')
    
    center = soup.find("div",attrs={"class":"large-8 columns"})
    right = soup.find("div",attrs={"class":"large-4 columns"})

    tableMarktwert = center.find("table",attrs={"class":"items"})
    tableTabelle = right.find_all("table",attrs={"class":"items"})
    tableTabelle = tableTabelle[len(tableTabelle)-1]

    if(tableTabelle==None):
        print("Error: table not found")
        return None
    bodyMarktwert = tableMarktwert.find("tbody")
    bodyTabelle = tableTabelle.find("tbody")
    return bodyMarktwert,bodyTabelle
    
def get_contents_Marktwert(soup):
    Marktwert_Spalte = soup.contents[7]
    Verein = Marktwert_Spalte.a['title']
    Marktwert = Marktwert_Spalte.a.string
    return Verein,Marktwert


def get_contents_Tabelle(soup):
    Standing = soup.contents[1].a.string
    Punkte = soup.contents[6].a.string
    return Standing,Punkte

def string_of_contents(liga,saison,verein,marktwert,standing,punkte):
    marktwert = marktwert.split(" ")[0]
    return "{},{},{},{},{},{}\n".format(liga,saison,verein, marktwert,standing,punkte)
    


def main():
    if(len(sys.argv)<3):
        print("not enough arguments")
        return
    liga = sys.argv[1]
    saison= sys.argv[2]
    if(len(sys.argv)>3):
        kuerzel = sys.argv[3]
    else:
        kuerzel = lookup(liga)
    url = "https://www.transfermarkt.de/{0}/startseite/wettbewerb/{1}/plus/?saison_id={2}".format(liga,kuerzel,saison)
    htmlCode = loadPage(url)
    marktwert,tabelle = getTableBody(htmlCode)
    if(tabelle ==None):
        print("Error: some elements not found")
        return

    childrenM = marktwert.children

    res = "Liga,Saison,Team,Marktwert,Platzierung,Punkte\n"
    for child in childrenM:
        if(child == '\n'):
            continue
        Verein,Marktwert = get_contents_Marktwert(child)
        content = tabelle.find(title=Verein).parent.parent.contents
        standing = content[1].contents[0]
        punkte = content[7].string
            
        res += string_of_contents(liga,saison,Verein,Marktwert,standing,punkte)

    with open("data.csv",'w+') as data :
        data.write(res)

    if(res ==None):
        print("Error: some elements not found")
        return
    # print(res.prettify())


if __name__ =="__main__":
    main()
