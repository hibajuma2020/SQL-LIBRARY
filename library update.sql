CREATE DATABASE Libraryhb;
USE Libraryhb;
CREATE TABLE Library (
    LibraryID INT IDENTITY(1,1) PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(20) NOT NULL,
    EstablishedYear INT
);
CREATE TABLE Book (
    BookID INT IDENTITY(1,1) PRIMARY KEY,
    ISBN VARCHAR(20) NOT NULL UNIQUE,
    Title VARCHAR(150) NOT NULL,
    Genre VARCHAR(50) NOT NULL CHECK (Genre IN ('Fiction','Non-fiction','Reference','Children')),
    Price DECIMAL(8,2) CHECK (Price > 0),
    IsAvailable BIT DEFAULT 1,
    ShelfLocation VARCHAR(50) NOT NULL,
    LibraryID INT NOT NULL,
    
    FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
CREATE TABLE Member (
    MemberID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100),
    Email VARCHAR(100) NOT NULL UNIQUE,
    PhoneNumber VARCHAR(20),
    MembershipStartDate DATE NOT NULL
);
CREATE TABLE Staff (
    StaffID INT IDENTITY(1,1) PRIMARY KEY,
    FullName VARCHAR(100),
    Position VARCHAR(50),
    ContactNumber VARCHAR(20),
    LibraryID INT NOT NULL,
    
    FOREIGN KEY (LibraryID) REFERENCES Library(LibraryID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
CREATE TABLE Loan (
    LoanID INT IDENTITY(1,1) PRIMARY KEY,
    LoanDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    Status VARCHAR(20) NOT NULL DEFAULT 'Issued'
        CHECK (Status IN ('Issued','Returned','Overdue')),
    
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    
    CHECK (ReturnDate IS NULL OR ReturnDate >= LoanDate)
);
CREATE TABLE Payment (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(8,2) NOT NULL CHECK (Amount > 0),
    Method VARCHAR(50),
    
    LoanID INT NOT NULL,
    
    FOREIGN KEY (LoanID) REFERENCES Loan(LoanID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
CREATE TABLE Review (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comments VARCHAR(255) DEFAULT 'No comments',
    ReviewDate DATE NOT NULL,
    
    MemberID INT NOT NULL,
    BookID INT NOT NULL,
    
    FOREIGN KEY (MemberID) REFERENCES Member(MemberID)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    
    FOREIGN KEY (BookID) REFERENCES Book(BookID)
    ON DELETE CASCADE
    ON UPDATE CASCADE
);
