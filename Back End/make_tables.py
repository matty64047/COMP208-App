import sqlite3
    
import sqlite3

qry = open('database_layout.sql', 'r').read()
conn = sqlite3.connect('comp208.db')
c = conn.cursor()
c.executescript(qry)
conn.commit()
c.close()
conn.close()