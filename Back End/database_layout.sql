create table Users (
    UserID int AUTO_INCREMENT unique,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    University varchar(255),
    Email varchar(255) unique not null,
    Password varchar(255),
    Type varchar(255),
    PRIMARY KEY (UserID)
);
    
create table Favourites (
	UserID int,
    JobID int,
	FOREIGN KEY (UserID) REFERENCES Users(UserID)
);
