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


SELECT Name, Location FROM Library;
SELECT * FROM Library;
SELECT * FROM Book
WHERE Genre = 'Fiction';
SELECT DISTINCT Genre FROM Book;
SELECT TOP 5 *
FROM Book
ORDER BY Price DESC;
SELECT *
FROM Book
WHERE Title LIKE 'The%';
SELECT *
FROM Loan
WHERE ReturnDate IS NULL;
SELECT *
FROM Library
WHERE Location = 'New York';
SELECT *
FROM Book
WHERE IsAvailable = 1;
SELECT *
FROM Staff
WHERE Position = 'Librarian';
SELECT *
FROM Loan
WHERE Status = 'Overdue';
SELECT *
FROM Book
WHERE Price > 20;
SELECT *
FROM Book
WHERE Genre = 'Fiction'
AND IsAvailable = 1;
SELECT *
FROM Book
ORDER BY Title ASC;
SELECT DISTINCT Genre
FROM Book;
SELECT *
FROM Book
WHERE Genre = 'Fiction'
AND IsAvailable = 1
AND Price < 25;
SELECT DISTINCT Genre
FROM Book;
SELECT TOP 5 *
FROM Book
ORDER BY Price DESC;
SELECT *
FROM Book
WHERE Title LIKE 'The%';
SELECT *
FROM Loan
WHERE ReturnDate IS NULL;
SELECT *
FROM Book
WHERE Genre = 'Fiction'
  AND IsAvailable = 1
  AND Price < 25
ORDER BY Price ASC;
SELECT TOP 10 *
FROM Book
WHERE IsAvailable = 1
  AND (Genre = 'Fiction' OR Genre = 'Non-fiction')
ORDER BY Price DESC;
SELECT L.LoanID, B.Title, L.LoanDate, L.DueDate
FROM Loan L
INNER JOIN Book B
ON L.BookID = B.BookID;
SELECT S.FullName, S.Position, Lib.Name, Lib.Location
FROM Staff S
INNER JOIN Library Lib
ON S.LibraryID = Lib.LibraryID;
SELECT B.Title, B.Genre, B.Price, Lib.Name, Lib.Location
FROM Book B
INNER JOIN Library Lib
ON B.LibraryID = Lib.LibraryID;
SELECT B.Title, B.Genre, R.Rating, R.Comments
FROM Book B
LEFT JOIN Review R
ON B.BookID = R.BookID;
SELECT B.Title, B.Genre, R.Rating, R.Comments
FROM Review R
RIGHT JOIN Book B
ON R.BookID = B.BookID;
SELECT M.FullName, M.Email,
       L.LoanDate, L.DueDate, L.Status
FROM Loan L
RIGHT JOIN Member M
ON L.MemberID = M.MemberID;
SELECT B.Title, R.Rating, R.Comments
FROM Book B
FULL OUTER JOIN Review R
ON B.BookID = R.BookID;
SELECT M.FullName,
       L.LoanDate,
       L.DueDate,
       L.Status,
       P.PaymentDate,
       P.Amount
FROM Loan L
INNER JOIN Member M
    ON L.MemberID = M.MemberID
LEFT JOIN Payment P
    ON L.LoanID = P.LoanID
WHERE L.Status = 'Active';
SELECT Lib.Name,
       B.Title,
       B.Genre,
       R.Rating,
       R.Comments
FROM Book B
INNER JOIN Library Lib
    ON B.LibraryID = Lib.LibraryID
LEFT JOIN Review R
    ON B.BookID = R.BookID;
	SELECT Lib.Name,
       COUNT(DISTINCT B.BookID) AS TotalBooks,
       COUNT(DISTINCT S.StaffID) AS TotalStaff,
       COUNT(DISTINCT L.LoanID) AS TotalLoans
FROM Library Lib
LEFT JOIN Book B
    ON Lib.LibraryID = B.LibraryID
LEFT JOIN Staff S
    ON Lib.LibraryID = S.LibraryID
LEFT JOIN Loan L
    ON B.BookID = L.BookID
GROUP BY Lib.Name;
SELECT COUNT(*) AS TotalBooks
FROM Book;
SELECT COUNT(*) AS TotalMembers
FROM Member;
SELECT SUM(Price) AS TotalBookPrice
FROM Book;
SELECT AVG(Price) AS AverageBookPrice
FROM Book;
SELECT 
    MIN(Price) AS CheapestPrice,
    MAX(Price) AS MostExpensivePrice
FROM Book;
SELECT COUNT(*) AS OverdueLoans
FROM Loan
WHERE Status = 'Overdue';
SELECT MAX(Rating) AS HighestRating
FROM Review;
SELECT MIN(Rating) AS LowestRating
FROM Review;
SELECT SUM(Amount) AS TotalFinesCollected
FROM Payment;
SELECT COUNT(ReturnDate) AS ReturnedLoans
FROM Loan;
SELECT Genre, COUNT(*) AS BookCount
FROM Book
GROUP BY Genre;
SELECT LibraryID, COUNT(*) AS StaffCount
FROM Staff
GROUP BY LibraryID;
SELECT Status, COUNT(*) AS LoanCount
FROM Loan
GROUP BY Status;
SELECT Genre, AVG(Price) AS AveragePrice
FROM Book
GROUP BY Genre;
SELECT Genre, SUM(Price) AS TotalGenrePrice
FROM Book
GROUP BY Genre;
SELECT Genre, MAX(Price) AS MostExpensiveInGenre
FROM Book
GROUP BY Genre;
SELECT Rating, COUNT(*) AS RatingCount
FROM Review
GROUP BY Rating;
SELECT LibraryID, COUNT(*) AS BookCount
FROM Book
GROUP BY LibraryID;
SELECT MemberID, COUNT(*) AS LoanCount
FROM Loan
GROUP BY MemberID;
SELECT Genre, MIN(Price) AS CheapestInGenre
FROM Book
GROUP BY Genre;
SELECT LibraryID, COUNT(*) AS BookCount
FROM Book
GROUP BY LibraryID
HAVING COUNT(*) > 2;
SELECT L.LibraryID, L.Name, COUNT(B.BookID) AS BookCount
FROM Library L
JOIN Book B ON L.LibraryID = B.LibraryID
GROUP BY L.LibraryID, L.Name;
SELECT M.MemberID, M.FullName, COUNT(L.LoanID) AS LoanCount
FROM Member M
JOIN Loan L ON M.MemberID = L.MemberID
GROUP BY M.MemberID, M.FullName;
SELECT B.BookID, B.Title, COUNT(L.LoanID) AS BorrowCount
FROM Book B
JOIN Loan L ON B.BookID = L.BookID
GROUP BY B.BookID, B.Title;
SELECT B.BookID, B.Title,
       AVG(CAST(R.Rating AS DECIMAL(3,2))) AS AverageRating
FROM Book B
JOIN Review R ON B.BookID = R.BookID
GROUP BY B.BookID, B.Title;
SELECT L.LibraryID, L.Name, SUM(B.Price) AS TotalBookValue
FROM Library L
JOIN Book B ON L.LibraryID = B.LibraryID
GROUP BY L.LibraryID, L.Name;
SELECT L.LibraryID, L.Name, COUNT(S.StaffID) AS StaffCount
FROM Library L
JOIN Staff S ON L.LibraryID = S.LibraryID
GROUP BY L.LibraryID, L.Name;
SELECT M.MemberID, M.FullName, SUM(P.Amount) AS TotalFinesPaid
FROM Member M
JOIN Loan L ON M.MemberID = L.MemberID
JOIN Payment P ON L.LoanID = P.LoanID
GROUP BY M.MemberID, M.FullName;
SELECT B.Genre, COUNT(DISTINCT L.MemberID) AS DistinctBorrowers
FROM Book B
JOIN Loan L ON B.BookID = L.BookID
GROUP BY B.Genre;
SELECT B.BookID, B.Title,
       COUNT(DISTINCT L.LoanID) AS BorrowCount,
       AVG(CAST(R.Rating AS DECIMAL(3,2))) AS AverageRating
FROM Book B
LEFT JOIN Loan L ON B.BookID = L.BookID
LEFT JOIN Review R ON B.BookID = R.BookID
GROUP BY B.BookID, B.Title;
SELECT Genre,
       COUNT(*) AS TotalBooks,
       SUM(CASE WHEN IsAvailable = 1 THEN 1 ELSE 0 END) AS AvailableBooks,
       AVG(Price) AS AveragePrice
FROM Book
GROUP BY Genre;
SELECT Genre, COUNT(*) AS AvailableCount
FROM Book
WHERE IsAvailable = 1
GROUP BY Genre
HAVING COUNT(*) > 1
ORDER BY AvailableCount DESC;
SELECT M.MemberID, M.FullName, COUNT(L.LoanID) AS OverdueCount
FROM Member M
JOIN Loan L ON M.MemberID = L.MemberID
WHERE L.Status = 'Overdue'
GROUP BY M.MemberID, M.FullName
HAVING COUNT(L.LoanID) >= 1
ORDER BY M.FullName;
SELECT L.LibraryID, L.Name, COUNT(Lo.LoanID) AS TotalLoans
FROM Library L
JOIN Book B ON L.LibraryID = B.LibraryID
JOIN Loan Lo ON B.BookID = Lo.BookID
GROUP BY L.LibraryID, L.Name
HAVING COUNT(Lo.LoanID) > 2
ORDER BY TotalLoans DESC;
SELECT B.BookID, B.Title,
       COUNT(DISTINCT L.LoanID) AS BorrowCount,
       AVG(CAST(R.Rating AS DECIMAL(3,2))) AS AverageRating
FROM Book B
LEFT JOIN Loan L ON B.BookID = L.BookID
LEFT JOIN Review R ON B.BookID = R.BookID
GROUP BY B.BookID, B.Title
HAVING COUNT(DISTINCT L.LoanID) >= 1
   AND AVG(CAST(R.Rating AS DECIMAL(3,2))) > 3
ORDER BY AverageRating DESC;
SELECT 
    L.LibraryID,
    L.Name,
    L.Location,
    COUNT(DISTINCT B.BookID) AS TotalBooks,
    COUNT(DISTINCT S.StaffID) AS TotalStaff,
    COUNT(DISTINCT Lo.LoanID) AS TotalLoans,
    SUM(P.Amount) AS TotalFinesCollected
FROM Library L
LEFT JOIN Book B ON L.LibraryID = B.LibraryID
LEFT JOIN Staff S ON L.LibraryID = S.LibraryID
LEFT JOIN Loan Lo ON B.BookID = Lo.BookID
LEFT JOIN Payment P ON Lo.LoanID = P.LoanID
GROUP BY L.LibraryID, L.Name, L.Location
HAVING COUNT(DISTINCT Lo.LoanID) >= 1
ORDER BY TotalLoans DESC;
