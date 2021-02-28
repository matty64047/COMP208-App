
create table Users (
    UserID int,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    University varchar(255),
    Email varchar(255),
    Password varchar(255),
    Type varchar(255),
    PRIMARY KEY (UserID)
);
    
create table Favourites (
	UserID int,
    JobID int
);
