import requests
from bs4 import BeautifulSoup
from tqdm import tqdm
from app import app, db
from itertools import cycle
from app.models import Job, User
import json
import time
from requests.packages.urllib3.exceptions import InsecureRequestWarning

requests.packages.urllib3.disable_warnings(InsecureRequestWarning)

city_list = ["Liverpool"]
query_terms = ["part+time"]
current_city = 0
BASE = "http://uk.indeed.com/jobs?q=part+time&l="
jobs = []
working_proxy_list = []
proxy_pool = cycle(working_proxy_list)
proxy = None

def load_proxies():
    global working_proxy_list
    global proxy
    global proxy_pool
    with open('scraping/proxies.json') as json_file:
        working_proxy_list = json.load(json_file)
        proxy_pool = cycle(working_proxy_list)
        proxy = working_proxy_list[0]

def get_proxies():
    url = "https://httpbin.org/ip"
    page = requests.get("https://free-proxy-list.net/")
    soup = BeautifulSoup(page.content, 'html.parser')
    table = soup.find(id="proxylisttable")
    rows = table.find_all('tr')
    rows = rows[1:]
    rows = rows[:-1]
    print("Trying proxies")
    for row in tqdm(rows):
        tags = row.find_all("td")
        proxy_host = tags[0].get_text()
        proxy_port = tags[1].get_text()
        proxies = {
            "https": "https://{}:{}".format(proxy_host, proxy_port),
            "http": "http://{}:{}".format(proxy_host, proxy_port)
        }
        try:
            r = requests.get(url, proxies=proxies, verify=False, timeout=(2, 5))
            working_proxy_list.append(proxies)
        except Exception as e:
            pass
    with open('scraping/proxies.json', 'w') as outfile:
        json.dump(working_proxy_list, outfile, indent=4, sort_keys=True)
    proxy = working_proxy_list[0]
    

def request_with_proxies(url):
    global working_proxy_list
    global proxy
    global proxy_pool
    for i in range(0, len(working_proxy_list)):
        while True:
            try:
                response = requests.get(url, proxies=proxy, verify=False, timeout=(2, 5))
                if "Captcha" not in (response.text) and len(response.text) >0 and "ERR_ACCESS_DENIED" not in (response.text):
                    return response
                else:
                    raise Exception
            except Exception as e:
                print(str(e))
                proxy = next(proxy_pool)
                continue
            break
    get_proxies()

def extract_job_information_indeed(page):
    soup = BeautifulSoup(page.content, 'html.parser')
    job_soup = soup.find(id="resultsCol")
    job_elems = job_soup.find_all('div', class_='jobsearch-SerpJobCard')
    
    links = []

    for job_elem in job_elems:
        if "/cmp/" not in job_elem:
            link = extract_link_indeed(job_elem)
            if Job.query.filter_by(title_url=link).first() is None:
                links.append(link)
    get_page_data(links)
    with open('scraping/indeed.json', 'w') as outfile:
        json.dump(jobs, outfile, indent=4, sort_keys=True)

def extract_link_indeed(job_elem):
    link = job_elem.find('a')['href']
    link = 'https://uk.Indeed.com' + link
    return link

def get_page_links(BASE, page_count):
    print("Extracting page 1")
    page = request_with_proxies(BASE+city_list[current_city])
    try:
        extract_job_information_indeed(page)
    except Exception as e:
        print(str(e))
        proxy = next(proxy_pool)
        pass
    for i in range(page_count):
        print("Extracting page "+str(i+2))
        page = request_with_proxies(BASE+city_list[current_city]+"&start="+str(i*10))
        try:
            extract_job_information_indeed(page)
        except Exception as e:
            print(str(e))
            proxy = next(proxy_pool)
            pass

def html_parse(html_string):
    """html_string = html_string.replace("<p>", "")
    html_string = html_string.replace("</p>", "\n")
    html_string = html_string.replace("<ul>", "\n")
    html_string = html_string.replace("</ul", "\n")
    html_string = html_string.replace("<li>", "   - ")
    html_string = html_string.replace("</li>", "\n")
    html_string = html_string.replace("\"", "'")
    html_string = html_string.replace("<br />", "\n")
    html_string = html_string.replace("<div class=\"jobsearch-jobDescriptionText\" id=\"jobDescriptionText\">", "")"""
    return html_string

def get_page_data(links):
    for link in tqdm(links):
        job = {
            "title" : "",
            "title_url" : "",
            "salary" : "",
            "description" : "",
            "company" : "",
            "location" : "",
            "rating" : "",
            "rating_count" : None,
            "days_ago" : "",
            "image" : "",
            "logo" : "",
            "work_type" : ""
        }
        page = request_with_proxies(link)
        soup = BeautifulSoup(page.content, 'html.parser')
        try:
            job["title"] = soup.find('h1', class_="icl-u-xs-mb--xs icl-u-xs-mt--none jobsearch-JobInfoHeader-title").get_text()
        except:
            pass
        try:
            job["title_url"] = link
        except:
            pass
        try:
            job["location"] = (soup.find('div', class_="icl-u-xs-mt--xs icl-u-textColor--secondary jobsearch-JobInfoHeader-subtitle jobsearch-DesktopStickyContainer-subtitle").get_text()).split("reviews")[1]
        except:
            pass
        try:
            job["company"] = soup.find('div', class_="jobsearch-CompanyReview--heading").get_text()
        except:
            pass
        try:
            job["salary"] = soup.find('span', class_="icl-u-xs-mr--xs").get_text()
        except:
            pass
        try:
            job["university"] = city_list[current_city]
        except:
            pass
        try:
            work_type = soup.find('span', class_="icl-u-xs-mt--xs").get_text()
            work_type = work_type.replace(" - ", "")
            job["work_type"] = work_type.lstrip()
        except:
            pass
        try:
            job["rating"] = soup.find(itemprop="ratingValue").get("content")
        except:
            pass
        try:
            job["rating_count"] = soup.find(itemprop="ratingCount").get("content")
        except:
            pass
        try:
            description = soup.find('div', class_="jobsearch-jobDescriptionText")
            job["description"] = html_parse(str(description))
        except Exception as e:
            print(str(e))
        try: 
            job["image"]= soup.find('img', class_="jobsearch-JobInfoHeader-headerImage").get('src')
        except:
            pass
        try: 
            job["logo"]= soup.find('img', class_="jobsearch-JobInfoHeader-logo jobsearch-JobInfoHeader-logo-overlay-lower").get('src')
        except:
            pass
        try:
            text = soup.find('div', class_="jobsearch-JobMetadataFooter")
            divs = text.find_all('div')
            if len(divs) > 6:
                job["days_ago"] = divs[1].get_text()
            else: 
                job["days_ago"] = divs[0].get_text()
        except:
            pass
        job_db = Job(university=job["university"], title=job["title"], rating_count=job["rating_count"], rating=job["rating"], title_url=job["title_url"],salary=job["salary"],description=job["description"],company=job["company"],location=job["location"],days_ago=job["days_ago"],image=job["image"],logo=job["logo"],work_type=job["work_type"])
        if Job.query.filter_by(title=job["title"]).first() is None:
            db.session.add(job_db)
            db.session.commit()
            jobs.append(job)

def get_jobs(page_count=10):
    global current_city
    for city in city_list:
        print("Getting Jobs for University of "+city_list[current_city])
        get_page_links(BASE, page_count)
        current_city = current_city + 1

def load_jobs():
    with open('scraping/indeed.json') as json_file:
        jobs_list = json.load(json_file)
        for job in jobs_list:
            del job["id"]
            del job["added"]
            db_job = Job(job)
            db.session.add(db_job)
        db.session.commit()