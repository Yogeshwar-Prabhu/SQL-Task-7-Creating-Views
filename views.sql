-- ============================================
-- TASK 7: Creating Views
-- SQL Developer Internship – Elevate Labs
-- ============================================

-- Make sure the database exists
CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

-- --------------------------------------------
-- SAMPLE TABLES (only if not already created)
-- --------------------------------------------
CREATE TABLE IF NOT EXISTS authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(150) NOT NULL,
    author_id INT,
    genre VARCHAR(50),
    published_year INT,
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

CREATE TABLE IF NOT EXISTS members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    joined_date DATE
);

CREATE TABLE IF NOT EXISTS borrowed_books (
    borrow_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT,
    book_id INT,
    borrow_date DATE,
    return_date DATE,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id)
);

-- ---------------------------------------------------------
-- VIEW 1: Basic View of All Books
-- ---------------------------------------------------------
CREATE VIEW view_all_books AS
SELECT 
    book_id,
    title,
    genre,
    published_year
FROM books;

-- ---------------------------------------------------------
-- VIEW 2: Books with Author Details
-- ---------------------------------------------------------
CREATE VIEW view_books_with_authors AS
SELECT 
    b.book_id,
    b.title,
    b.genre,
    b.published_year,
    a.name AS author_name,
    a.country AS author_country
FROM books b
JOIN authors a ON b.author_id = a.author_id;

-- ---------------------------------------------------------
-- VIEW 3: Currently Borrowed Books (Not Returned Yet)
-- ---------------------------------------------------------
CREATE VIEW view_currently_borrowed AS
SELECT 
    bb.borrow_id,
    m.name AS member_name,
    b.title AS book_title,
    bb.borrow_date
FROM borrowed_books bb
JOIN members m ON bb.member_id = m.member_id
JOIN books b ON bb.book_id = b.book_id
WHERE bb.return_date IS NULL;

-- ---------------------------------------------------------
-- VIEW 4: Members Who Have Borrowed More Than 1 Book
-- ---------------------------------------------------------
CREATE VIEW view_frequent_readers AS
SELECT 
    m.member_id,
    m.name,
    COUNT(bb.book_id) AS total_borrowed
FROM members m
JOIN borrowed_books bb ON m.member_id = bb.member_id
GROUP BY m.member_id, m.name
HAVING COUNT(bb.book_id) > 1;

-- ---------------------------------------------------------
-- VIEW 5: Books Published After 2010
-- ---------------------------------------------------------
CREATE VIEW view_books_after_2010 AS
SELECT 
    title,
    genre,
    published_year
FROM books
WHERE published_year > 2010;

-- ---------------------------------------------------------
-- VIEW USAGE EXAMPLES
-- ---------------------------------------------------------

-- Fetch all books
SELECT * FROM view_all_books;

-- Fetch books with authors
SELECT * FROM view_books_with_authors;

-- Fetch currently borrowed books
SELECT * FROM view_currently_borrowed;

-- Frequent readers
SELECT * FROM view_frequent_readers;

-- Books published after 2010
SELECT * FROM view_books_after_2010;

-- ---------------------------------------------------------
-- INTERVIEW QUESTIONS (REFERENCE)
-- ---------------------------------------------------------
-- 1. What is a view?
-- 2. Can we update data through a view?
-- 3. What is a materialized view?
-- 4. Difference between view and table?
-- 5. How to drop a view?
--      → DROP VIEW view_name;
-- 6. Why use views?
-- 7. Can we create indexed views?
-- 8. How to secure data using views?
-- 9. What are limitations of views?
-- 10. How does WITH CHECK OPTION work?
-- ---------------------------------------------------------
