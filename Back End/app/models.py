from app import db
import datetime
from sqlalchemy.inspection import inspect
from werkzeug.security import generate_password_hash, check_password_hash

class Serializer(object):

    def serialize(self):
        return {c: getattr(self, c) for c in inspect(self).attrs.keys()}

    @staticmethod
    def serialize_list(l):
        return [m.serialize() for m in l]

class User(db.Model, Serializer):

    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    first_name = db.Column(db.String(80), unique=False, nullable=False)
    last_name = db.Column(db.String(80), unique=False, nullable=False)
    university = db.Column(db.String(80), unique=False, nullable=False)
    password_hash = db.Column(db.String(255), unique=False, nullable=False)
    type = db.Column(db.String(10), unique=False, nullable=False, default="user")
    email = db.Column(db.String(120), unique=True, nullable=False)
    added = db.Column(db.DateTime, default=datetime.datetime.utcnow)

    def __repr__(self):
        return '<User %r>' % self.email
    
    def serialize(self):
        d = Serializer.serialize(self)
        del d['password_hash']
        return d

    def hash_password(self, password):
        self.password_hash = generate_password_hash(password)

    def verify_password(self, password):
        return check_password_hash(self.password_hash, password)

class Ratings(db.Model, Serializer):

    __tablename__ = 'ratings'
    id = db.Column(db.Integer, primary_key=True)
    job_id = db.Column(db.Integer, db.ForeignKey('jobs.id'))
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    rating = db.Column(db.Integer)
    added = db.Column(db.DateTime, default=datetime.datetime.utcnow)
    __table_args__ = (db.UniqueConstraint(job_id, user_id, name='uix_1'),)

    def __repr__(self):
        return '<Rating: %r, Job: %r>' % (self.rating, self.job_id)
    
    def serialize(self):
        d = Serializer.serialize(self)
        return d

class Job(db.Model, Serializer):

    __tablename__ = 'jobs'
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(255), unique=False, nullable=False)
    title_url = db.Column(db.String(255), unique=False, nullable=True)
    salary = db.Column(db.String(255), unique=False, nullable=True)
    description = db.Column(db.Text(10000), unique=False, nullable=True)
    company = db.Column(db.String(255), unique=False, nullable=True)
    location = db.Column(db.String(255), unique=False, nullable=True)
    days_ago = db.Column(db.String(30), unique=False, nullable=True)
    image = db.Column(db.String(255), unique=False, nullable=True)
    logo = db.Column(db.String(255), unique=False, nullable=True)
    work_type = db.Column(db.String(255), unique=False, nullable=True)
    university = db.Column(db.String(255), unique=False, nullable=True)
    added = db.Column(db.DateTime, default=datetime.datetime.utcnow)

    def __repr__(self):
        return '<Job %r>' % self.id

    def serialize(self):
        d = Serializer.serialize(self)
        return d

    def __init__(self, dictionary):
        for k, v in dictionary.items():
            setattr(self, k, v)
