import sqlite3
    
connection = sqlite3.connect("comp208.db")
cursor = connection.cursor()

sql_file = open("database_layout.sql")
sql_as_string = sql_file.read()
cursor.executescript(sql_as_string)