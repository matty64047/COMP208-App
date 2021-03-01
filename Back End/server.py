from flask import Flask, jsonify, request
import json
import mysql.connector

"""Establish database connection - 
these are just the login details for my personal MySQL server
if you want to run this code you'll have to make the database on your system 
using the SQL template in the GitHub directory and replace these details with 
your own login details"""
mydb = mysql.connector.connect( 
  host="localhost", 
  user="root",
  password="matthew123",
  database="comp208"
)

mycursor = mydb.cursor(buffered=True, dictionary=True)

app = Flask(__name__)

#rather than rewriting the error messages which will be sent to the client each time I've just put them all here
errors = ["Email already in use", "There is no account assosciated with this email address", "Incorrect password","Already favourited"]


"""I've tried to keep server responses consistent to make them easier to work with in the flutter app
they are generally formatted as -
    jsonify({
        "error":True/False, #a flag to tell the client if the command has succeeded or not
        "response": response #if the command succeeded this will either be a 
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
    user_id = request.form.get('user_id') #retrieves value from POST request with key 'user_id'
    password = request.form.get('password')
    valid = authenticate_user(user_id, password)
    if valid == True:
        city = request.form.get('city')
        salary = request.form.get('salary')
        jobs = sql_query_all("select * from Jobs where city = %s AND salary = %s ", (city, salary,))
        return jsonify({
            "error":False,
            "response":jobs 
        })
    else: 
        return valid


"""
creates new row in favourites table with id of a specific job

Required form fields are:

"user_id"
"password"
"job_id" - of job you want to add to favourites

"""
@app.route('/favourite', methods=['POST'])
def favourite():
    user_id = request.form.get('user_id')
    password = request.form.get('password')
    valid = authenticate_user(user_id, password)
    if valid == True:
        job_id = request.form.get('job_id')
        try:
            response = sql_query("INSERT into Favourites(UserID, JobID) values (%s, %s);", (user_id, job_id))
            return jsonify({
                "error" : False,
                "response" : "Added to favourites"
            })
        except mysql.connector.errors.IntegrityError:
            return jsonify({
                "error" : True,
                "response" : errors[3]
            })
    else: 
        return valid
                
"""
removes job from favourites for specific user ID

Required form fields are:

"user_id"
"password"
"job_id" - of job you want to remove to favourites

"""
@app.route('/unfavourite', methods=['POST'])
def unfavourite():
    user_id = request.form.get('user_id')
    password = request.form.get('password')
    valid = authenticate_user(user_id, password)
    if valid == True:
        job_id = request.form.get('job_id')
        response = sql_query("DELETE FROM Favourites WHERE JobID = %s AND UserID= %s;", (job_id, user_id,))
        return jsonify({
            "error" : False,
            "response" : "Removed from favourites"
        })
    else: 
        return valid

"""
retrieves all the favourites assosciated with a user

Required form fields are:

"user_id"
"password"

"""
@app.route('/get_favourites', methods=['POST'])
def get_favourites():
    user_id = request.form.get('user_id')
    password = request.form.get('password')
    valid = authenticate_user(user_id, password)
    if valid == True:
        favourites = sql_query_all("select * from Favourites natural join Jobs where UserID=%s;", (user_id,))
        return jsonify({
            "error":False,
            "response":favourites
        })
    else: 
        return valid
        

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
    last_name = request.form.get('last_name')
    first_name = request.form.get('first_name')
    address = request.form.get('address')
    university = request.form.get('university')
    email = request.form.get('email')
    password = request.form.get('password')
    try:
        response = sql_query("insert into Users (LastName, FirstName, Address, University, Email, Password, Type) Values (%s,%s,%s,%s,%s,%s,%s);", (last_name, first_name, address, university, email, password,"User"))
    except mysql.connector.errors.IntegrityError: #email has already been used
        return jsonify({
            "error" : True,
            "response" : errors[0]
        }) 
    return jsonify({
        "error" : False,
        "response" : "New user added"
    })


"""
use client provided details (Email and password) to authenticate and then find the users 
details which are stored on the server and then sends them back in JSON format

Required form fields are:

"email"
"password"

"""
@app.route('/get_user', methods=['POST'])
def get_user():
    email = request.form.get('email')
    password = request.form.get('password')
    user = sql_query("select * from Users where Email=%s;", (email,)) #get details for user with this email
    if user: # user exists
        valid = authenticate_user(user["UserID"], password)
        if valid == True:
            return jsonify({
                "error" : False,
                "response" : user #dictionary of user details
            })
        else: 
            return valid #wrong password
    else: #no account assosciated with email provided
        return jsonify({
            "error" : True,
            "response" : errors[1] 
        })


"""
checks that the user is allowed to make the request by comparing the password sent in the
POST request is the same as what is saved in the database
"""
def authenticate_user(user_id, password):
    response = sql_query("select Password from Users where UserID=%s;", (user_id,))
    if response:
        if response["Password"] == password:
            return True #correct password - user is authenticated
        else:
            return jsonify({
                "error" : True,
                "message" : errors[2] #wrong password
            })
    else: 
        return jsonify({
            "error" : True,
            "message" : errors[1] #user does not exist
        })

"""
sends a query in the form of a string to the SQL connection specified above
and returns a tuple of the first match

"query" is the SQL statement to send 
"data" is any parameters needed for that string

example: sql_query("select Password from Users where UserID=%s;", (user_id,))
"""
def sql_query(query, data):
    mycursor.execute(query, data)
    mydb.commit()
    return mycursor.fetchone()

"""
sends a query in the form of a string to the SQL connection specified above
and returns a list of tuples of all the matching rows from the database
"""
def sql_query_all(query, data):
    mycursor.execute(query, data)
    mydb.commit()
    return mycursor.fetchall()

if __name__ == '__main__':
    app.run(host = '0.0.0.0', debug=True)