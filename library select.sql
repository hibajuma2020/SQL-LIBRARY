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
INSERT INTO Library (Name, Location, ContactNumber, EstablishedYear)
VALUES
('Central Library', 'New York', '1234567890', 1995),
('Westside Library', 'California', '9876543210', 2015),
('City Library', 'Texas', '5554443333', 2008);

SELECT * FROM Library;

INSERT INTO Member (FullName, Email, PhoneNumber, MembershipStartDate)
VALUES
('Ali Ahmed', 'ali@gmail.com', '90000001', '2023-01-10'),
('Sara Khalid', 'sara@gmail.com', '90000002', '2024-03-15'),
('John Smith', 'john@yahoo.com', '90000003', '2022-07-20');

SELECT * FROM Member
SELECT * FROM Book

INSERT INTO Book (ISBN, Title, Genre, Price, ShelfLocation, LibraryID)
VALUES
('ISBN001', 'The Great Adventure', 'Fiction', 25.00, 'A1', 1),
('ISBN002', 'Science Basics', 'Reference', 40.00, 'B2', 1),
('ISBN003', 'Kids Stories', 'Children', 15.00, 'C3', 2),
('ISBN004', 'History of World', 'Non-fiction', 30.00, 'D4', 3);

SELECT * FROM Staff


INSERT INTO Staff (FullName, Position, ContactNumber, LibraryID)
VALUES
('Mona Hassan', 'Librarian', '80011111', 1),
('David Lee', 'Assistant', '80022222', 2),
('Emma Brown', 'Manager', '80033333', 3);

select * from loan

INSERT INTO Loan (LoanDate, DueDate, ReturnDate, Status, MemberID, BookID)
VALUES
('2024-01-01', '2024-01-15', NULL, 'Issued', 1, 1),
('2024-02-01', '2024-02-10', '2024-02-08', 'Returned', 2, 3),
('2024-03-01', '2024-03-10', NULL, 'Overdue', 3, 2);

SELECT * FROM Payment
INSERT INTO Payment (PaymentDate, Amount, Method, LoanID)
VALUES
('2024-03-15', 10.00, 'Cash', 3);

SELECT * FROM Review
INSERT INTO Review (Rating, Comments, ReviewDate, MemberID, BookID)
VALUES
(5, 'Amazing book!', '2024-01-20', 1, 1),
(4, NULL, '2024-02-15', 2, 3),
(3, 'Good but long', '2024-03-05', 3, 2);


