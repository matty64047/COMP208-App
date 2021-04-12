from app import app, db
import werkzeug
from flask import Response, abort, jsonify
import sqlalchemy

@app.errorhandler(sqlalchemy.exc.IntegrityError)
def not_found_error(e):
    print(e)
    return jsonify("Database Error"), 400
