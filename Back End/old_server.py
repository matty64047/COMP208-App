from flask import Flask, jsonify
import json
import mysql.connector
import requests

app = Flask(__name__)

@app.route('/')
def home():
    with open('job_scrape.json', encoding='utf-8') as json_file:
        data = json.load(json_file)
        return jsonify(data)

if __name__ == '__main__':
    app.run(host = '0.0.0.0', debug=True)