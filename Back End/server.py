from flask import Flask, jsonify, request
import json
import sqlite3
from tqdm import tqdm
import os

app = Flask(__name__)

"""
I've tried to keep server responses consistent to make them easier to work with in the flutter app
they are generally formatted as -
    jsonify({
        "error":True/False,      #a flag to tell the client if the command has succeeded or not
        
        
        "response": response     #if the command succeeded this will either be a 
                                 success message or any information that has been requested, if not it 
                                 will be an error message from the list above
    })
"""


"""
queries SQL database with filters provided in POST request and returns list of appropriate jobs

The client interacts with this webserver script through HTTP POST requests

The URL the POST request is sent to is http://server_address/app_route_address
E.g. for this function, if the server address was 192.168.1.1 it would be "http://192.168.1.1/get_jobs"

The body of the POST request should have form fields appropriate for the function you are calling.

For this function, required form fields are:

"user_id"
"password"
"city"
"salary"

"""
@app.route('/get_jobs', methods=['POST'])
def get_jobs():
    try:
        user_id = request.form.get('user_id') #retrieves value from POST request with key 'user_id'
        password = request.form.get('password')
        authenticate_user(user_id, password)
        #city = request.form.get('city')
        #salary = request.form.get('salary')
        jobs = sql_query_all("select * from Jobs", ())
        return jsonify({
            "error":False,
            "response":jobs 
        })
    except Exception as error:
        return exception_handler(error)


"""
creates new row in favourites table with id of a specific job

Required form fields are:

"user_id"
"password"
"job_id" - of job you want to add to favourites

"""
@app.route('/favourite', methods=['POST'])
def favourite():
    try:
        user_id = request.form.get('user_id')
        password = request.form.get('password')
        authenticate_user(user_id, password)
        job_id = request.form.get('job_id')
        response = sql_query("INSERT into Favourites(UserID, JobID) values (?, ?);", (user_id, job_id))
        return jsonify({
            "error" : False,
            "response" : "Added to favourites"
        })
    except Exception as error:
        return exception_handler(error)
                
"""
removes job from favourites for specific user ID

Required form fields are:

"user_id"
"password"
"job_id" - of job you want to remove to favourites

"""
@app.route('/unfavourite', methods=['POST'])
def unfavourite():
    try:
        user_id = request.form.get('user_id')
        password = request.form.get('password')
        authenticate_user(user_id, password)
        job_id = request.form.get('job_id')
        response = sql_query("DELETE FROM Favourites WHERE JobID = ? AND UserID= ?;", (job_id, user_id,))
        return jsonify({
            "error" : False,
            "response" : "Removed from favourites"
        })
    except Exception as error:
        return exception_handler(error)
    

"""
retrieves all the favourites assosciated with a user

Required form fields are:

"user_id"
"password"

"""
@app.route('/get_favourites', methods=['POST'])
def get_favourites():
    try:
        user_id = request.form.get('user_id')
        password = request.form.get('password')
        authenticate_user(user_id, password)
        favourites = sql_query_all("select * from Favourites inner join jobs on favourites.JobID=jobs._id where userID=?;", (user_id,))
        return jsonify({
            "error":False,
            "response":favourites
        })
    except Exception as error:
        return exception_handler(error)
        

"""
creates new user from details provided by client in post request

Required form fields are:

"last_name"
"first_name"
"address"
"university"
"email"
"password"

"""
@app.route('/new_user', methods=['POST'])
def new_user():
    try:
        last_name = request.form.get('last_name')
        first_name = request.form.get('first_name')
        address = request.form.get('address')
        university = request.form.get('university')
        email = request.form.get('email')
        password = request.form.get('password')
        response = sql_query("insert into Users (LastName, FirstName, Address, University, Email, Password) Values (?,?,?,?,?,?);", (last_name, first_name, address, university, email, password))
        return jsonify({
            "error" : False,
            "response" : "New user added"
        })
    except Exception as error:
        return exception_handler(error)
    except TypeError:
        return exception_handler("That email is not assosciated with a user account")



"""
use client provided details (Email and password) to authenticate and then find the users 
details which are stored on the server and then sends them back in JSON format

Required form fields are:

"email"
"password"

"""
@app.route('/get_user', methods=['POST'])
def get_user():
    try:
        email = request.form.get('email')
        password = request.form.get('password')
        user = sql_query("select * from Users where Email=?;", (email,)) #get details for user with this email
        if not user:
            raise UserDoesNotExistError
        authenticate_user(user["_id"], password)
        return jsonify({
            "error" : False,
            "response" : user #dictionary of user details
        })
    except Exception as error:
        return exception_handler(error)

"""
checks that the user has admin privelleges and then rebuilds the database from the JSON files in the
jobs folder

Required form fields are:

"email"
"password"

"""
@app.route('/rebuild_database', methods=['POST'])
def rebuild_database():
    try:
        email = request.form.get('email')
        print("1")
        password = request.form.get('password')
        print("2")
        user = sql_query("select * from Users where Email=?;", (email,)) #get details for user with this email
        print("3")
        if not user:
            print("4")
            raise UserDoesNotExistError
        print("5")
        authenticate_user(user["_id"], password)
        print("6")
        if (user["Type"] !="admin"):
            raise NotAnAdminError
        create_database_tables()
        populate_jobs_table()
        return jsonify({
            "error" : False,
            "response" : "Success"
        })
    except Exception as error:
        exception_handler(error)

"""
checks that the user is allowed to make the request by comparing the password sent in the
POST request is the same as what is saved in the database
"""
def authenticate_user(user_id, password):
    response = sql_query("select Password from Users where _id=?;", (user_id,))
    if response:
        if response["Password"] == password:
            return True #correct password - user is authenticated
        else:
            raise WrongPasswordError
    else: 
        raise UserDoesNotExistError


"""
sends a query in the form of a string to the SQL connection specified above
and returns a tuple of the first match

"query" is the SQL statement to send 
"data" is any parameters needed for that string

example: sql_query("select Password from Users where _id=?;", (user_id,))
"""
def sql_query(query, data):
    with sqlite3.connect('comp208.db') as mydb:
        mydb.row_factory = sqlite3.Row
        mycursor = mydb.cursor()
        mycursor.execute(query, data)
        mydb.commit()
        response = mycursor.fetchone()
        if response:
            return dict(response)
        else:
            return response

"""
sends a query in the form of a string to the SQL connection specified above
and returns a list of tuples of all the matching rows from the database
"""
def sql_query_all(query, data):
    with sqlite3.connect('comp208.db') as mydb:
        mydb.row_factory = sqlite3.Row
        mycursor = mydb.cursor()
        mycursor.execute(query, data)
        mydb.commit()
        result = [dict(row) for row in mycursor.fetchall()]
        return result



"""
searches for every JSON file in the Jobs directory and imports them into the database
"""
def populate_jobs_table():
    directory = os.getcwd()+"/Jobs" #this is the directory where the JSON files containing the jobs are located
    for filename in os.listdir(directory):
        print("--- Importing %s to database ---" % (filename))
        with open(directory+"/"+filename, encoding="utf8") as json_file:
            data = json.load(json_file)
            for job in tqdm(data):
                with sqlite3.connect('comp208.db') as mydb:
                    mycursor = mydb.cursor()
                    data = ("Liverpool",job["Title"],job["Title_URL"],job["Salary"],job["Summary"],job["Date"],job["Field1"],job["Field2"],"",)
                    mycursor.execute("insert into jobs (City,Title,Summary,TitleURL,Salary,Date,Company,Location,Image) values (?,?,?,?,?,?,?,?,?) ", data)
                    mydb.commit()
                    response = mycursor.fetchone()

"""
runs a the SQL script database_layout.sql - currently deletes old database and creates new tables
"""
def create_database_tables():
    qry = open('database_layout.sql', 'r').read() #this is the file where the layout of the database is stored
    conn = sqlite3.connect('comp208.db') #the sqlite database file
    c = conn.cursor()
    c.executescript(qry)
    conn.commit()
    c.close()
    conn.close()
    

"""
If an exception is thrown while dealing with a client request, this function is called to respond to the client
with a meaningful response

"error" - a human readable error message
"code" - a code which can be easily interpreted by the client code

call with name paramaters - 
e.g. exception_handler(code=1)

"""

class Error(Exception):
    """Base class for other exceptions"""
    pass

class UserDoesNotExistError(Error):
    code = 1
    message = "There is no account associated with that email address"
    pass

class WrongPasswordError(Error):
    code = 2
    message = "Wrong password"
    pass

class NotAnAdminError(Error):
    code = 3
    message = "You do not have permission for that action"
    pass

def exception_handler(error):
    print(7)
    response = {"error":True}
    try:
        print(8)
        response["code"] = error.code
        response["response"] = error.message
        print(9)
    except:
        print(10)
        response["code"] = 404
        response["response"] = "Unspecified error"
        print(11)
    return jsonify(response)

if __name__ == '__main__':
    app.run(host = '0.0.0.0', debug=True)