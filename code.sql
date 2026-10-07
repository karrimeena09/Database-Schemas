-- ===========================================================
-- LIBRARY MANAGEMENT SYSTEM
-- MySQL Database Project
-- ============================================================

DROP DATABASE IF EXISTS Library_Management_System;

CREATE DATABASE Library_Management_System;

USE Library_Management_System;


-- ============================================================
-- 1. AUTHOR TABLE
-- ============================================================

CREATE TABLE Author (
    Author_ID INT PRIMARY KEY AUTO_INCREMENT,
    Author_Name VARCHAR(100) NOT NULL,
    Biography VARCHAR(500)
);


-- ============================================================
-- 2. PUBLISHER TABLE
-- ============================================================

CREATE TABLE Publisher (
    Publisher_ID INT PRIMARY KEY AUTO_INCREMENT,
    Publisher_Name VARCHAR(100) NOT NULL,
    Contact VARCHAR(15)
);


-- ============================================================
-- 3. CATEGORY TABLE
-- ============================================================

CREATE TABLE Category (
    Category_ID INT PRIMARY KEY AUTO_INCREMENT,
    Category_Name VARCHAR(100) NOT NULL UNIQUE,
    Description VARCHAR(255)
);


-- ============================================================
-- 4. MEMBER TABLE
-- ============================================================

CREATE TABLE Member (
    Member_ID INT PRIMARY KEY AUTO_INCREMENT,
    Member_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    Address VARCHAR(255),
    Membership_Date DATE NOT NULL
);


-- ============================================================
-- 5. LIBRARIAN TABLE
-- ============================================================

CREATE TABLE Librarian (
    Librarian_ID INT PRIMARY KEY AUTO_INCREMENT,
    Librarian_Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15)
);


-- ============================================================
-- 6. BOOK TABLE
-- ============================================================

CREATE TABLE Book (
    Book_ID INT PRIMARY KEY AUTO_INCREMENT,
    Title VARCHAR(200) NOT NULL,
    ISBN VARCHAR(20) UNIQUE,
    Publication_Year INT,
    Quantity INT NOT NULL DEFAULT 0,
    Available_Quantity INT NOT NULL DEFAULT 0,

    Author_ID INT NOT NULL,
    Publisher_ID INT NOT NULL,
    Category_ID INT NOT NULL,

    CONSTRAINT fk_book_author
        FOREIGN KEY (Author_ID)
        REFERENCES Author(Author_ID),

    CONSTRAINT fk_book_publisher
        FOREIGN KEY (Publisher_ID)
        REFERENCES Publisher(Publisher_ID),

    CONSTRAINT fk_book_category
        FOREIGN KEY (Category_ID)
        REFERENCES Category(Category_ID),

    CONSTRAINT chk_book_quantity
        CHECK (Quantity >= 0),

    CONSTRAINT chk_book_available
        CHECK (Available_Quantity >= 0),

    CONSTRAINT chk_book_available_le_quantity
        CHECK (Available_Quantity <= Quantity)
);


-- ============================================================
-- 7. LOAN TABLE
-- ============================================================

CREATE TABLE Loan (
    Loan_ID INT PRIMARY KEY AUTO_INCREMENT,

    Member_ID INT NOT NULL,
    Book_ID INT NOT NULL,
    Librarian_ID INT NOT NULL,

    Issue_Date DATE NOT NULL,
    Due_Date DATE NOT NULL,
    Return_Date DATE NULL,

    CONSTRAINT fk_loan_member
        FOREIGN KEY (Member_ID)
        REFERENCES Member(Member_ID),

    CONSTRAINT fk_loan_book
        FOREIGN KEY (Book_ID)
        REFERENCES Book(Book_ID),

    CONSTRAINT fk_loan_librarian
        FOREIGN KEY (Librarian_ID)
        REFERENCES Librarian(Librarian_ID),

    CONSTRAINT chk_loan_dates
        CHECK (Due_Date >= Issue_Date),

    CONSTRAINT chk_loan_return_date
        CHECK (
            Return_Date IS NULL
            OR Return_Date >= Issue_Date
        )
);


-- ============================================================
-- 8. RESERVATION TABLE
-- ============================================================

CREATE TABLE Reservation (
    Reservation_ID INT PRIMARY KEY AUTO_INCREMENT,

    Member_ID INT NOT NULL,
    Book_ID INT NOT NULL,

    Reservation_Date DATE NOT NULL,

    Status VARCHAR(20) NOT NULL DEFAULT 'Pending',

    CONSTRAINT fk_reservation_member
        FOREIGN KEY (Member_ID)
        REFERENCES Member(Member_ID),

    CONSTRAINT fk_reservation_book
        FOREIGN KEY (Book_ID)
        REFERENCES Book(Book_ID),

    CONSTRAINT chk_reservation_status
        CHECK (
            Status IN
            ('Pending', 'Confirmed', 'Cancelled', 'Completed')
        )
);


-- ============================================================
-- 9. FINE TABLE
-- ============================================================

CREATE TABLE Fine (
    Fine_ID INT PRIMARY KEY AUTO_INCREMENT,

    Loan_ID INT NOT NULL,

    Amount DECIMAL(10,2) NOT NULL,

    Payment_Status VARCHAR(20) NOT NULL DEFAULT 'Unpaid',

    Payment_Date DATE NULL,

    CONSTRAINT fk_fine_loan
        FOREIGN KEY (Loan_ID)
        REFERENCES Loan(Loan_ID),

    CONSTRAINT chk_fine_amount
        CHECK (Amount >= 0),

    CONSTRAINT chk_fine_status
        CHECK (
            Payment_Status IN ('Unpaid', 'Paid')
        )
);


-- ============================================================
-- 10. INDEXES
-- ============================================================

CREATE INDEX idx_book_title
ON Book(Title);

CREATE INDEX idx_book_author
ON Book(Author_ID);

CREATE INDEX idx_book_category
ON Book(Category_ID);

CREATE INDEX idx_loan_member
ON Loan(Member_ID);

CREATE INDEX idx_loan_book
ON Loan(Book_ID);

CREATE INDEX idx_reservation_member
ON Reservation(Member_ID);

CREATE INDEX idx_reservation_book
ON Reservation(Book_ID);


-- ============================================================
-- 11. INSERT AUTHORS
-- ============================================================

INSERT INTO Author
(Author_Name, Biography)
VALUES
('R.K. Narayan',
 'Indian writer and novelist'),

('J.K. Rowling',
 'British author and philanthropist'),

('George Orwell',
 'English novelist and essayist'),

('Jane Austen',
 'English novelist'),

('A.P.J. Abdul Kalam',
 'Indian aerospace scientist and former President of India');


-- ============================================================
-- 12. INSERT PUBLISHERS
-- ============================================================

INSERT INTO Publisher
(Publisher_Name, Contact)
VALUES
('Penguin Books', '9876543210'),
('Oxford Press', '9876543211'),
('HarperCollins', '9876543212'),
('Random House', '9876543213'),
('Wings Publications', '9876543214');


-- ============================================================
-- 13. INSERT CATEGORIES
-- ============================================================

INSERT INTO Category
(Category_Name, Description)
VALUES
('Fiction',
 'Fictional books and novels'),

('Science',
 'Science related books'),

('Technology',
 'Computer and technology books'),

('History',
 'Historical books and references'),

('Biography',
 'Biographical and autobiographical books');


-- ============================================================
-- 14. INSERT MEMBERS
-- ============================================================

INSERT INTO Member
(Member_Name, Email, Phone, Address, Membership_Date)
VALUES
('Anjali Kumar',
 'anjali@gmail.com',
 '9000000001',
 'Hyderabad',
 '2026-01-10'),

('Rahul Sharma',
 'rahul@gmail.com',
 '9000000002',
 'Vijayawada',
 '2026-01-15'),

('Priya Reddy',
 'priya@gmail.com',
 '9000000003',
 'Guntur',
 '2026-02-05'),

('Arjun Rao',
 'arjun@gmail.com',
 '9000000004',
 'Visakhapatnam',
 '2026-02-10'),

('Sneha Patel',
 'sneha@gmail.com',
 '9000000005',
 'Rajahmundry',
 '2026-03-01');


-- ============================================================
-- 15. INSERT LIBRARIANS
-- ============================================================

INSERT INTO Librarian
(Librarian_Name, Email, Phone)
VALUES
('Suresh Kumar',
 'suresh@library.com',
 '8000000001'),

('Lakshmi Devi',
 'lakshmi@library.com',
 '8000000002');


-- ============================================================
-- 16. INSERT BOOKS
-- ============================================================

INSERT INTO Book
(
    Title,
    ISBN,
    Publication_Year,
    Quantity,
    Available_Quantity,
    Author_ID,
    Publisher_ID,
    Category_ID
)
VALUES

(
    'Malgudi Days',
    '9780143039653',
    1943,
    5,
    5,
    1,
    1,
    1
),

(
    'Harry Potter and the Philosophers Stone',
    '9780747532699',
    1997,
    6,
    5,
    2,
    3,
    1
),

(
    '1984',
    '9780451524935',
    1949,
    4,
    4,
    3,
    4,
    1
),

(
    'Pride and Prejudice',
    '9780141439518',
    1813,
    5,
    5,
    4,
    1,
    1
),

(
    'Wings of Fire',
    '9788173711466',
    1999,
    7,
    6,
    5,
    5,
    5
),

(
    'Introduction to Computer Science',
    '9780000000001',
    2022,
    8,
    8,
    5,
    2,
    3
),

(
    'Basic Science',
    '9780000000002',
    2021,
    4,
    4,
    5,
    2,
    2
);


-- ============================================================
-- 17. INSERT LOANS
-- ============================================================

INSERT INTO Loan
(
    Member_ID,
    Book_ID,
    Librarian_ID,
    Issue_Date,
    Due_Date,
    Return_Date
)
VALUES

(
    1,
    2,
    1,
    '2026-09-01',
    '2026-09-15',
    NULL
),

(
    2,
    1,
    1,
    '2026-09-03',
    '2026-09-17',
    '2026-09-12'
),

(
    3,
    3,
    2,
    '2026-09-05',
    '2026-09-19',
    NULL
),

(
    4,
    5,
    2,
    '2026-09-08',
    '2026-09-22',
    NULL
);


-- ============================================================
-- 18. INSERT RESERVATIONS
-- ============================================================

INSERT INTO Reservation
(
    Member_ID,
    Book_ID,
    Reservation_Date,
    Status
)
VALUES

(
    5,
    2,
    '2026-09-10',
    'Pending'
),

(
    1,
    3,
    '2026-09-11',
    'Confirmed'
),

(
    2,
    5,
    '2026-09-12',
    'Pending'
);


-- ============================================================
-- 19. INSERT FINES
-- ============================================================

INSERT INTO Fine
(
    Loan_ID,
    Amount,
    Payment_Status,
    Payment_Date
)
VALUES

(
    1,
    25.00,
    'Unpaid',
    NULL
),

(
    2,
    10.00,
    'Paid',
    '2026-09-13'
);


-- ============================================================
-- 20. DATA RETRIEVAL
-- ============================================================

-- Display all books
SELECT *
FROM Book;


-- Display all members
SELECT *
FROM Member;


-- Display all authors
SELECT *
FROM Author;


-- Display all categories
SELECT *
FROM Category;


-- Display available books
SELECT
    Book_ID,
    Title,
    Available_Quantity
FROM Book
WHERE Available_Quantity > 0;


-- Search for a book
SELECT *
FROM Book
WHERE Title LIKE '%Harry%';


-- Display unpaid fines
SELECT *
FROM Fine
WHERE Payment_Status = 'Unpaid';


-- Display books with quantity greater than 5
SELECT
    Title,
    Quantity
FROM Book
WHERE Quantity > 5;


-- ============================================================
-- 21. UPDATE OPERATIONS
-- ============================================================

-- Example:
-- UPDATE Member
-- SET Phone = '9111111111'
-- WHERE Member_ID = 1;


-- Example:
-- UPDATE Reservation
-- SET Status = 'Confirmed'
-- WHERE Reservation_ID = 1;


-- ============================================================
-- 22. DELETE OPERATIONS
-- ============================================================

-- Example:
-- DELETE FROM Reservation
-- WHERE Reservation_ID = 3;


-- ============================================================
-- 23. JOINS
-- ============================================================

-- Books with authors

SELECT
    B.Book_ID,
    B.Title,
    A.Author_Name
FROM Book B
INNER JOIN Author A
ON B.Author_ID = A.Author_ID;


-- Books with publishers

SELECT
    B.Title,
    P.Publisher_Name
FROM Book B
INNER JOIN Publisher P
ON B.Publisher_ID = P.Publisher_ID;


-- Books with categories

SELECT
    B.Title,
    C.Category_Name
FROM Book B
INNER JOIN Category C
ON B.Category_ID = C.Category_ID;


-- Member and borrowed book details

SELECT
    M.Member_Name,
    B.Title,
    L.Issue_Date,
    L.Due_Date,
    L.Return_Date
FROM Loan L
INNER JOIN Member M
ON L.Member_ID = M.Member_ID
INNER JOIN Book B
ON L.Book_ID = B.Book_ID;


-- Complete loan information

SELECT
    L.Loan_ID,
    M.Member_Name,
    B.Title,
    LB.Librarian_Name,
    L.Issue_Date,
    L.Due_Date,
    L.Return_Date
FROM Loan L
INNER JOIN Member M
ON L.Member_ID = M.Member_ID
INNER JOIN Book B
ON L.Book_ID = B.Book_ID
INNER JOIN Librarian LB
ON L.Librarian_ID = LB.Librarian_ID;


-- Reservation details

SELECT
    R.Reservation_ID,
    M.Member_Name,
    B.Title,
    R.Reservation_Date,
    R.Status
FROM Reservation R
INNER JOIN Member M
ON R.Member_ID = M.Member_ID
INNER JOIN Book B
ON R.Book_ID = B.Book_ID;


-- Fine details

SELECT
    F.Fine_ID,
    M.Member_Name,
    B.Title,
    F.Amount,
    F.Payment_Status
FROM Fine F
INNER JOIN Loan L
ON F.Loan_ID = L.Loan_ID
INNER JOIN Member M
ON L.Member_ID = M.Member_ID
INNER JOIN Book B
ON L.Book_ID = B.Book_ID;


-- ============================================================
-- 24. AGGREGATE FUNCTIONS
-- ============================================================

-- Count books

SELECT COUNT(*) AS Total_Book_Titles
FROM Book;


-- Total book copies

SELECT SUM(Quantity) AS Total_Book_Copies
FROM Book;


-- Available book copies

SELECT SUM(Available_Quantity)
AS Available_Book_Copies
FROM Book;


-- Average publication year

SELECT AVG(Publication_Year)
AS Average_Publication_Year
FROM Book;


-- Maximum quantity

SELECT MAX(Quantity)
AS Highest_Quantity
FROM Book;


-- Minimum quantity

SELECT MIN(Quantity)
AS Lowest_Quantity
FROM Book;


-- Books in each category

SELECT
    C.Category_Name,
    COUNT(B.Book_ID) AS Number_Of_Book_Titles
FROM Category C
LEFT JOIN Book B
ON C.Category_ID = B.Category_ID
GROUP BY
    C.Category_ID,
    C.Category_Name;


-- Loans by member

SELECT
    M.Member_Name,
    COUNT(L.Loan_ID) AS Number_Of_Loans
FROM Member M
LEFT JOIN Loan L
ON M.Member_ID = L.Member_ID
GROUP BY
    M.Member_ID,
    M.Member_Name;


-- Total fines

SELECT SUM(Amount)
AS Total_Fine_Amount
FROM Fine;


-- ============================================================
-- 25. SUBQUERIES
-- ============================================================

-- Books with quantity greater than average

SELECT
    Title,
    Quantity
FROM Book
WHERE Quantity >
(
    SELECT AVG(Quantity)
    FROM Book
);


-- Members who borrowed books

SELECT
    Member_ID,
    Member_Name
FROM Member
WHERE Member_ID IN
(
    SELECT Member_ID
    FROM Loan
);


-- Books that have been borrowed

SELECT
    Book_ID,
    Title
FROM Book
WHERE Book_ID IN
(
    SELECT Book_ID
    FROM Loan
);


-- Members with unpaid fines

SELECT
    Member_Name
FROM Member
WHERE Member_ID IN
(
    SELECT L.Member_ID
    FROM Loan L
    INNER JOIN Fine F
    ON L.Loan_ID = F.Loan_ID
    WHERE F.Payment_Status = 'Unpaid'
);


-- Books with highest quantity

SELECT
    Title,
    Quantity
FROM Book
WHERE Quantity =
(
    SELECT MAX(Quantity)
    FROM Book
);


-- ============================================================
-- 26. VIEWS
-- ============================================================

DROP VIEW IF EXISTS Issued_Books;

DROP VIEW IF EXISTS Book_Details;

DROP VIEW IF EXISTS Unpaid_Fines;


-- Issued Books View

CREATE VIEW Issued_Books AS

SELECT
    L.Loan_ID,
    M.Member_Name,
    B.Title,
    L.Issue_Date,
    L.Due_Date
FROM Loan L

INNER JOIN Member M
ON L.Member_ID = M.Member_ID

INNER JOIN Book B
ON L.Book_ID = B.Book_ID

WHERE L.Return_Date IS NULL;


-- Book Details View

CREATE VIEW Book_Details AS

SELECT
    B.Book_ID,
    B.Title,
    B.ISBN,
    A.Author_Name,
    P.Publisher_Name,
    C.Category_Name,
    B.Publication_Year,
    B.Quantity,
    B.Available_Quantity

FROM Book B

INNER JOIN Author A
ON B.Author_ID = A.Author_ID

INNER JOIN Publisher P
ON B.Publisher_ID = P.Publisher_ID

INNER JOIN Category C
ON B.Category_ID = C.Category_ID;


-- Unpaid Fines View

CREATE VIEW Unpaid_Fines AS

SELECT
    F.Fine_ID,
    M.Member_Name,
    B.Title,
    F.Amount,
    F.Payment_Status

FROM Fine F

INNER JOIN Loan L
ON F.Loan_ID = L.Loan_ID

INNER JOIN Member M
ON L.Member_ID = M.Member_ID

INNER JOIN Book B
ON L.Book_ID = B.Book_ID

WHERE F.Payment_Status = 'Unpaid';


-- ============================================================
-- 27. DISPLAY VIEWS
-- ============================================================

SELECT *
FROM Issued_Books;

SELECT *
FROM Book_Details;

SELECT *
FROM Unpaid_Fines;


-- ============================================================
-- 28. FINAL CHECK
-- ============================================================

SHOW TABLES;


SELECT 'Author' AS Table_Name,
       COUNT(*) AS Record_Count
FROM Author

UNION ALL

SELECT 'Publisher',
       COUNT(*)
FROM Publisher

UNION ALL

SELECT 'Category',
       COUNT(*)
FROM Category

UNION ALL

SELECT 'Member',
       COUNT(*)
FROM Member

UNION ALL

SELECT 'Librarian',
       COUNT(*)
FROM Librarian

UNION ALL

SELECT 'Book',
       COUNT(*)
FROM Book

UNION ALL

SELECT 'Loan',
       COUNT(*)
FROM Loan

UNION ALL

SELECT 'Reservation',
       COUNT(*)
FROM Reservation

UNION ALL

SELECT 'Fine',
       COUNT(*)
FROM Fine;


-- ============================================================
-- END OF LIBRARY MANAGEMENT SYSTEM
-- ============================================================