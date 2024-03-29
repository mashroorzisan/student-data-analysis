
CREATE TABLE Student (
    StudentID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL,
    Phone VARCHAR(15),
    Address TEXT
);

CREATE TABLE Book (
    ISBN VARCHAR(13) PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    Genre VARCHAR(50),
    TotalCopies INT NOT NULL,
    AvailableCopies INT NOT NULL
);

CREATE TABLE Borrowing (
    BorrowID INT AUTO_INCREMENT PRIMARY KEY,
    StudentID INT,
    ISBN VARCHAR(13),
    BorrowDate DATE NOT NULL,
    DueDate DATE NOT NULL,
    ReturnDate DATE,
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (ISBN) REFERENCES Book(ISBN)
);

-- reset
SET SQL_SAFE_UPDATES = 0;
delete from student;
delete from book;
delete from borrowing;
SET SQL_SAFE_UPDATES = 1;
-- reset done

-- check 
select * from student;
select * from book;
select * from borrowing;
-- check done

-- Inserting data into the Student table
INSERT INTO Student (Name, Email, Phone, Address) 
VALUES 
    ('John Doe', 'john@example.com', '123-456-7890', '123 Main St, Cityville'),
    ('Jane Smith', 'jane@example.com', '987-654-3210', '456 Elm St, Townsville'),
    ('Alice Johnson', 'alice@example.com', '555-123-4567', '789 Oak St, Villagetown');


-- Inserting data into the Book table
INSERT INTO Book (ISBN, Title, Author, Genre, TotalCopies, AvailableCopies) 
VALUES 
    ('978-0061', 'To Kill a Mockingbird', 'Harper Lee', 'Classic', 5, 5),
    ('978-1451', '1984', 'George Orwell', 'Dystopian', 3, 3),
    ('978-0140', 'Pride and Prejudice', 'Jane Austen', 'Romance', 4, 4),
    ('978-0141', 'The Picture of Dorian Gray', 'Oscar Wilde', 'Gothic', 2, 2);


-- Inserting data into the Borrowing table with due dates and return dates
INSERT INTO Borrowing (StudentID, ISBN, BorrowDate, DueDate, ReturnDate) 
VALUES 
    (2008142, '978-0061', '2024-03-01', '2024-03-15', '2024-03-18'),  -- Returned late
    (2008142, '978-1451', '2024-03-05', '2024-03-19', '2024-03-20'),  -- Returned on time
    (2008143, '978-0140', '2024-03-10', '2024-03-24', NULL),          -- Not yet returned
    (2008144, '978-0141', '2024-03-15', '2024-03-29', '2024-04-01');  -- Returned late


-- QUESTION 1: Insert a record of a student who borrowed a book that is most available.
insert into borrowing(
        StudentId, 
        ISBN, 
        Borrowdate, 
        duedate, 
        returndate) 
			values(
            2008142, (
                select isbn 
                from book 
                where availablecopies = (
										select max(AvailableCopies) 
                                        from book
                                        )
					), 
			'2024-11-12',
            '2024-12-12',
            '2025-1-12'
            );
            
-- QUESTION 2: Update the availablity of a book when it is borrowed from the library
update book
set availablecopies = availablecopies - 1
where isbn = '978-0061';


-- test 
select * from book;


-- QUESTION 3: Find who borrowed the most book.

select student.name
from student
join borrowing on student.studentid = borrowing.studentid 
group by student.studentid
order by count(*) desc
limit 1;


-- QUESTION 4: Retrieve the books that are overdue (i.e., the return date is before the current date).
SELECT *
FROM Borrowing
WHERE ReturnDate < CURDATE();

