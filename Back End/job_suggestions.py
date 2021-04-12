# https://realpython.com/build-recommendation-engine-collaborative-filtering/
# -- Read more about the collaborative filtering approach used

from app import app, db
from app.models import User, Job, Ratings
from flask import g
import numpy as np
from sqlalchemy import func
import scipy
import pandas as pd
from surprise import Dataset, Reader, KNNWithMeans


"""
    Calculates the mean rating of all jobs that haven't previously been rated,
    i.e. unseen jobs, and returns the 10 highest rated
"""
def most_popular_jobs():

    most_popular_jobs = db.session.query(Job).join(Ratings).group_by(Ratings.job_id).order_by(Ratings.rating.desc()).all()
    already_seen_jobs = db.session.query(Job).join(Ratings).filter(Ratings.user_id==g.user.id).all()
    recommended_jobs = [x for x in most_popular_jobs if x not in already_seen_jobs]
    return recommended_jobs[0:10]


def with_filters(filters):
    return []


"""
    Uses a cosine distance function from a sparse matrix of user ratings 
    combined with a K nearest neighbour machine learning algorithm to 
    estimate a user's ratings for previously unseen jobs based on the ratings 
    of similiar users, and then returns the 10 highest rated jobs.

    All jobs are can be rated -1 for a right swipe, or "dislike", 1 for a left swipe,
    or "like" and 2 for a save.
"""
def user_suggestions():

    algo = create_model()

    jobs_with_scores = []

    all_jobs = Job.query.all()
    already_seen_jobs = db.session.query(Job).join(Ratings).filter(Ratings.user_id==g.user.id).all()
    unseen_jobs = [x for x in all_jobs if x not in already_seen_jobs]

    for job in unseen_jobs:
        score = algo.predict(g.user.id, job.id).est
        jobs_with_scores.append({
            "job" : job,
            "score" : score
        })
    
    top_jobs = sorted(jobs_with_scores, key=lambda k: k['score'], reverse=True)

    output = []
    for job in top_jobs:
        output.append(job["job"])

    return output[0:10]


def create_model():

    ratings = db.session.query(Ratings.job_id, Ratings.user_id, Ratings.rating).all()
    ratings_dict = {
        "job": [],
        "user": [],
        "rating": [],
    }
    for rating in ratings:
        ratings_dict["job"].append(rating[0])
        ratings_dict["user"].append(rating[1])
        ratings_dict["rating"].append(rating[2])


    df = pd.DataFrame(ratings_dict)
    reader = Reader(rating_scale=(-1, 2))

    data = Dataset.load_from_df(df[["user", "job", "rating"]], reader)

    # To use item-based cosine similarity
    sim_options = {
        "name": "cosine",
        "user_based": False,  # Compute  similarities between items
    }

    algo = KNNWithMeans(sim_options=sim_options)

    trainingSet = data.build_full_trainset()

    algo.fit(trainingSet)

    return algo