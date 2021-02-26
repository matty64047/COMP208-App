from flask import Flask, jsonify
import json
import mysql.connector
import requests

mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="matthew123",
  database="jobs"
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

def authenticate_user(user_id, security_key):
    return True

if __name__ == '__main__':
    app.run(host = '0.0.0.0', debug=True)