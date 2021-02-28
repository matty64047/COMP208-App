from flask import Flask, jsonify, request
import json
import mysql.connector

mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="matthew123",
  database="comp208"
)

app = Flask(__name__)

@app.route('/get_jobs', methods=['POST'])
def get_jobs():
    return "Not Implemented Yet"

@app.route('/favourite', methods=['POST'])
def favourite():
    return "Not Implemented Yet"

@app.route('/unfavourite', methods=['POST'])
def unfavourite():
    return "Not Implemented Yet"

@app.route('/get_favourites', methods=['POST'])
def get_favourites():
    return "Not Implemented Yet"

@app.route('/new_user', methods=['POST'])
def new_user():
    return "Not Implemented Yet"

@app.route('/get_user', methods=['POST'])
def get_user():
    user_id = request.form.get('user_id')
    password = request.form.get('password')
    valid = authenticate_user(user_id, password)
    if valid == True:
        user = sql_query("select * from Users where UserID=%s;" % (user_id))
        user_dict = {
            "user_id" : user[0],
            "last_name" : user[1],
            "first_name" : user[2],
            "address" : user[3],
            "university" : user[4],
            "email" : user[5],
            "password" : user[6],
        }
        return "True"
    else: 
        return valid

def authenticate_user(user_id, password):
    response = sql_query("select Password from Users where UserID=%s;" % (user_id))
    if response:
        if response[0] == password:
            return True 
        else:
            return "Incorrect Password"
    else: 
        return "User does not exist"

def sql_query(query):
    mycursor = mydb.cursor()
    mycursor.execute(query)
    return mycursor.fetchone()

if __name__ == '__main__':
    app.run(host = '0.0.0.0', debug=True)