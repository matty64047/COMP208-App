drop table Users;
DROP TABLE Favourites;
DROP table Jobs;

create table Users (
    _id integer PRIMARY KEY,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    University varchar(255),
    Email varchar(255) unique not null,
    Password varchar(255) not null,
    Type varchar(255) default "User" 
);

insert into users (email, type, password) values ("m.p.connoll@gmail.com", "Admin", "matthew123"); -- admin account needed for rebuilding database, either use this one or add your own admin account below

create table Favourites (
	UserID int,
    JobID int,
    _id integer PRIMARY KEY,
    Added TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(UserID, JobID),
	FOREIGN KEY (UserID) REFERENCES Users(_id),
    FOREIGN KEY (JobID) REFERENCES Jobs(_id)
);

create table Jobs (
    _id integer primary key,
    Added TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    City varchar(255),
    Title varchar(255),
    Summary varchar(255),
    TitleURL varchar(255),
    Salary varchar(255),
    Date varchar(255),
    Company varchar(255),
    Location varchar(255),
    Image varchar(255)
);