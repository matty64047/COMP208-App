from flask import Flask, jsonify, request
import json
import mysql.connector

mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="matthew123",
  database="comp208"
)

mycursor = mydb.cursor(buffered=True, dictionary=True)

app = Flask(__name__)

errors = ["Email already in use", "Email does not exist", "Incorrect password", ]

@app.route('/get_jobs', methods=['POST'])
def get_jobs():
    user_id = request.form.get('user_id')
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
                "response" : ""
            })
        except mysql.connector.errors.IntegrityError:
            return jsonify({
                "error" : True,
                "response" : "Already Favourited"
            })
    else: 
        return valid

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
            "response" : ""
        })
    else: 
        return valid

@app.route('/get_favourites', methods=['POST'])
def get_favourites():
    user_id = request.form.get('user_id')
    password = request.form.get('password')
    valid = authenticate_user(user_id, password)
    if valid == True:
        favourites = sql_query_all("select distinct * from Favourites natural join Jobs where UserID=%s;", (user_id,))
        return jsonify({
            "error":False,
            "response":favourites
        })
    else: 
        return valid

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
    except mysql.connector.errors.IntegrityError:
        return jsonify({
            "error" : True,
            "response" : errors[0]
        }) 
    return jsonify({
        "error" : False,
        "response" : ""
    })

@app.route('/get_user', methods=['POST'])
def get_user():
    email = request.form.get('email')
    password = request.form.get('password')
    user = sql_query("select * from Users where Email=%s;", (email,))
    if user:
        valid = authenticate_user(user["UserID"], password)
        if valid == True:
            return jsonify({
                "error" : False,
                "response" : user
            })
        else: 
            return valid
    else:
        return jsonify({
            "error" : True,
            "response" : errors[1]
        })

def authenticate_user(user_id, password):
    response = sql_query("select Password from Users where UserID=%s;", (user_id,))
    if response:
        if response["Password"] == password:
            return True
        else:
            return jsonify({
                "error" : True,
                "message" : errors[2]
            })
    else: 
        return jsonify({
            "error" : True,
            "message" : errors[1]
        })

def sql_query(query, data):
    mycursor.execute(query, data)
    mydb.commit()
    return mycursor.fetchone()

def sql_query_all(query, data):
    mycursor.execute(query, data)
    mydb.commit()
    return mycursor.fetchall()

if __name__ == '__main__':
    app.run(host = '0.0.0.0', debug=True)