SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM members;
SELECT * FROM return_status;


-- PROJECT TASK --

--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
  INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
  VALUES ('978-1-60129-456-7', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')
  SELECT * FROM books;

--Task 2: Update an Existing Member's Address
  UPDATE members
  SET member_address = '129 Main St'
  WHERE member_id = 'C101';
  SELECT * FROM members;

 --Task 3: Delete a Record from the Issued Status Table 
 -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
  DELETE FROM issued_status
  WHERE issued_id = 'IS121';

  SELECT * FROM issued_status;

 --Task 4: Retrieve All Books Issued by a Specific Employee 
 -- Objective: Select all books issued by the employee with emp_id = 'E101'.
  SELECT * FROM issued_status
  WHERE issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.
   SELECT issued_emp_id,
      COUNT(issued_id) as total_book_issued
   FROM issued_status
   GROUP BY issued_emp_id
   HAVING COUNT (issued_id) > 1

 --Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
 CREATE TABLE book_ctns (
    isbn VARCHAR(20),
    book_title VARCHAR(255),
    no_issued INT
);
  INSERT INTO book_ctns (isbn, book_title, no_issued)
  SELECT b.isbn, b.book_title,
  COUNT(ist.issued_id) as no_issued
  FROM books as b
  JOIN issued_status as ist
  ON ist.issued_book_isbn = b.isbn
  GROUP BY isbn, book_title;

  SELECT * FROM book_ctns;


-- Task 7. Retrieve All Books in a Specific Category:
 SELECT * FROM books
 WHERE category = 'History';


 --Task 8: Find Total Rental Income by Category:
  SELECT category, 
         SUM(rental_price) as total_rental_income
  FROM books
  GROUP BY category;

 
 -- List Members Who Registered in the Last 180 Days:
  SELECT * 
  FROM members
  WHERE CAST(reg_date AS DATE) >= DATEADD(DAY, -180, GETDATE());

  INSERT INTO members
  VALUES ('C138', 'Elle' , '145 Main Street', '2025-06-01'),
         ('C139', 'Jin' , '130 Main Street', '2025-05-01');



--10. List Employees with Their Branch Manager's Name and their branch details:
  SELECT * FROM branch;
  SELECT * FROM employees;

  SELECT e1.*, b.manager_id, e2.emp_name as Manager
  FROM employees as e1
  JOIN branch as b
  ON b.branch_id = e1.branch_id
  JOIN employees as e2
  ON b.manager_id = e2.emp_id


--Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:
  CREATE TABLE book_price (    
            isbn VARCHAR(50),
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price FLOAT,
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
			);
  INSERT INTO book_price (isbn, book_title, category, rental_price, status, author, publisher)
  SELECT * 
  FROM books
  WHERE rental_price > 7

  SELECT * FROM book_price;


--Task 12: Retrieve the List of Books Not Yet Returned
 SELECT DISTINCT ist.issued_book_name
 FROM issued_status as ist
 LEFT JOIN return_status$ as rs
 ON ist.issued_id = rs.issued_id
 WHERE rs.return_id IS NULL

 SELECT * FROM return_status$;









