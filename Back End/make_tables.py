import sqlite3
import json
from tqdm import tqdm
import os

def populate_jobs_table():
    for filename in os.listdir(os.getcwd()+"/Jobs"):
        with open(filename, encoding="utf8") as json_file:
            data = json.load(json_file)
            for job in tqdm(data):
                with sqlite3.connect('comp208.db') as mydb:
                    mycursor = mydb.cursor()
                    data = ("Liverpool",job["Title"],job["Title_URL"],job["Salary"],job["Summary"],job["Date"],job["Field1"],job["Field2"],"",)
                    mycursor.execute("insert into jobs (City,Title,Summary,TitleURL,Salary,Date,Company,Location,Image) values (?,?,?,?,?,?,?,?,?) ", data)
                    mydb.commit()
                    response = mycursor.fetchone()




def create_table():
    qry = open('database_layout.sql', 'r').read()
    conn = sqlite3.connect('comp208.db')
    c = conn.cursor()
    c.executescript(qry)
    conn.commit()
    c.close()
    conn.close()


create_table()
