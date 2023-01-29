import requests
from bs4 import BeautifulSoup
import getopt


def hlp(tit):
  global Verein
  return str(Verein) in str(tit)

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
    if("," in Maktwert):
      kommaShift = Marktwert.index(" ")-Marktwert.index(",") -1
    else 
      kommaShift = 0
    Marktwert = Marktwert.replace(" Mio. €",(6-kommaShift)*"0")
    Marktwert = Marktwert.replace(" Mrd. €",(9-kommaShift)*"0")
    Marktwert = Marktwert.replace(" Tsd. €",(3-kommaShift)*"0")
    Marktwert = Marktwert.replace(",","")
    return Verein,Marktwert


def get_contents_Tabelle(soup):
    Standing = soup.contents[1].a.string
    Punkte = soup.contents[6].a.string
    return Standing,Punkte

def string_of_contents(liga,saison,verein,marktwert,standing,punkte):
    #marktwert = marktwert.split(" ")[0]
    return "{},{},{},{},{},{}\n".format(liga,saison,verein, marktwert,standing,punkte)
    

def lookup(liga):
    kontinent = 'europa'
    kontinentSites = 18
    for page in range(1,kontinentSites+1):
      url = "https://www.transfermarkt.de/wettbewerbe/{0}?ajax=yw1&page={1}".format(kontinent,page)
      html = loadPage(url)
      soup = BeautifulSoup(html, 'html.parser')
      center = soup.find("div",attrs={"class":"large-8 columns"})
      center = center.find("table",attrs={"class":"items"})
      table = center.find("tbody")
      children = table.children
      for child in children:
        if(child == '\n'):
            continue
        correct = child.find("a",string = liga)
        if(correct!=None):
          link = correct['href']
          parts = link.split("/")
          league = parts[1]
          league = league[0].upper() + league[1:]
          kuerzel = parts[len(parts)-1]
          return league,kuerzel
    return None, None

def load(argv):
    opts,args = getopt.getopt(argv,"hl:o:v:b:a",["help","liga=","von=","bis=","output=","append"])

    liga = "Bundesliga"
    von = None #default 2022
    bis = None
    output = 'data'
    append = False

    for opt,arg in opts:
        if opt in ("-h","--help"):
            help = "Arguments: \n-l: Liga \n-v: Saison_von -b Saison_bis \n-o: Output file"
            print(help)
            exit(0)
        elif opt in( '--liga', '-l'):
            liga = arg
        elif opt in ('--von, -v'):
            von = int(arg)
        elif opt in ('--bis, -b'):
            bis = int(arg)
        elif opt in ('--output','-o'):
            output = arg
        elif opt in ('--append','-a'):
            append = True
    
    if bis ==None and von ==None:
        bis = 2023
        von = 2022
    elif bis == None:
        bis= von+1
    elif von ==None:
        von = bis-1
    elif not append:
        print("several saisons without appending makes no sense!")

    liga,kuerzel = lookup(liga)

    output +='.csv'
    

    for saison in range(von,bis):
        url = "https://www.transfermarkt.de/{0}/startseite/wettbewerb/{1}/plus/?saison_id={2}".format(liga,kuerzel,saison)
    
        htmlCode = loadPage(url)
        if (htmlCode == None):
            print("Arguments invalid or Server not reachable!")
            return

        marktwert,tabelle = getTableBody(htmlCode)
    
        if(tabelle ==None):
            print("Error: some elements not found")
            return

        childrenM = marktwert.children

        header = "Liga,Saison,Team,Marktwert,Platzierung,Punkte\n"
        res = ""
        for child in childrenM:
            if(child == '\n'):
                continue
            global Verein
            Verein, Marktwert = get_contents_Marktwert(child)
            
            tmp = tabelle.find(title=Verein)
            if(tmp ==None):
              tmp = tabelle.find(title=hlp)
            content = tmp.parent.parent.contents
            standing = content[1].contents[0]
            punkte = content[7].string
            
            res += string_of_contents(liga,saison,Verein,Marktwert,standing,punkte)


        if append:
            with open(output,'a+') as data :
                data.write(res)
        else:
            with open(output,'w+') as data :
                data.write(header + res)




