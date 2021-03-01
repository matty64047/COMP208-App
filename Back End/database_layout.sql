create table Users (
    _id integer PRIMARY KEY,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    University varchar(255),
    Email varchar(255) unique not null,
    Password varchar(255),
    Type varchar(255),
);
    
create table Favourites (
	UserID int,
    JobID int,
    _id integer PRIMARY KEY,
    DT datetime DEFAULT NOW(), 
    UNIQUE KEY (UserID,JobID),
	FOREIGN KEY (UserID) REFERENCES Users(_id),
    FOREIGN KEY (JobID) REFERENCES Jobs(_id)
);
