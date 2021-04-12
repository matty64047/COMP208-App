from app import app, db, errors
from app.models import User, Job, Ratings, Serializer
from flask import request, jsonify, abort, g
from sqlalchemy import exc
from flask_httpauth import HTTPBasicAuth
import job_suggestions
import random
from werkzeug.security import generate_password_hash, check_password_hash

auth = HTTPBasicAuth()

@app.route('/')
@app.route('/index')
def index():
    return "Server Running Correctly"

@app.route('/api/user/create', methods=["POST"])
def create_user():
    first_name = request.form.get("first_name")
    last_name = request.form.get("last_name")
    university = request.form.get("university")
    email = request.form.get("email")
    password = request.form.get("password")
    if email is None or password is None:
        abort(400, "Please fill in all the required fields")
    if User.query.filter_by(email = email).first() is not None:
        abort(409, "Email already in use")
    user = User(email=email, last_name=last_name, university=university, first_name=first_name)
    user.hash_password(request.form.get("password"))
    db.session.add(user)
    db.session.commit()
    return jsonify("Success"), 200

@app.route('/api/user', methods=["GET", "PUT", "DELETE"])
@auth.login_required
def user():

    #Retrieve User data
    if request.method == 'GET':
        return jsonify(g.user.serialize()), 200

    #Update user details
    if request.method == 'PUT':
        email = g.user.email
        try:
            args = request.form.to_dict()
            if "type" in args and args["type"] is not None:
                abort(401, "User type can not be changed")
            if "email" in args and args["email"] is not None:
                abort(400, "Email can not be changed")
            if "password" in args and args["password"] is not None:
                password_hash = generate_password_hash(args["password"])
                args.pop("password")
                args["password_hash"] = password_hash
            User.query.filter(email == email).update(args)
            db.session.commit()
            return jsonify("Success"), 200
        except exc.InvalidRequestError:
            abort(400, "Invalid field to update")

    #Delete user
    if request.method == 'DELETE':
        Ratings.query.filter_by(user_id=g.user.id).delete()
        db.session.delete(g.user)
        db.session.commit()
        return jsonify("Success"), 200

@app.route('/api/job', methods=["GET", "POST", "PUT", "DELETE"])
@auth.login_required
def job():

    #Manually add job
    if request.method == 'POST' and g.user.type == "admin":
        title = request.form.get("title")
        job = Job(title=title)
        db.session.add(job)
        db.session.commit()
        return jsonify("Success"), 200

    #Get jobs list
    if request.method == 'GET':
        jobs =  job_suggestions.user_suggestions()
        if len(jobs) < 10:
            jobs.append(random.sample(Job.query.all(), 10-len(jobs)))
        return jsonify(Serializer.serialize_list(jobs)), 200

    if request.method == 'PUT' and g.user.type == "admin":
        return "TODO"

    if request.method == 'DELETE' and g.user.type == "admin":
        Job.query.delete()
        db.session.commit()
        return jsonify("Success"), 200

@app.route('/api/rating', methods=["GET", "POST", "PUT", "DELETE"])
@auth.login_required
def rating():

    #Add new job rating
    if request.method == 'POST':
        job_id = request.form.get("job_id")
        rating = request.form.get("rating")
        Ratings.query.filter_by(user_id=g.user.id, job_id=job_id).delete() #delete old job rating
        job_rating = Ratings(user_id=g.user.id, job_id=job_id,rating=rating)
        db.session.add(job_rating)
        db.session.commit()
        return jsonify("Success"), 200

    #Get list of job ratings for user
    if request.method == 'GET':
        ratings =  Serializer.serialize_list(Ratings.query.filter_by(user_id=g.user.id))
        return jsonify(ratings), 200
    
    #Delete job rating
    if request.method == 'DELETE':
        Ratings.query.filter_by(user_id=g.user.id, job_id=request.form.get("job_id")).delete()
        db.session.commit()
        return jsonify("Success"), 200

@auth.verify_password
def verify_password(email, password):
    user = User.query.filter_by(email = email).first()
    if not user or not user.verify_password(password):
        return False
    g.user = user
    return True