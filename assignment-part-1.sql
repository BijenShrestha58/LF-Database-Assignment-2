CREATE SCHEMA IF NOT EXISTS assignment2;

CREATE TABLE IF NOT EXISTS assignment2.publishers(
	publisher_id INT PRIMARY KEY,
	publisher_name VARCHAR(100),
	country VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS assignment2.books(
	book_id INT PRIMARY KEY,
	title vARCHAR(100),
	genre VARCHAR(50),
	publisher_id INT,
	publication_year DATE,
	FOREIGN KEY(publisher_id) REFERENCES assignment2.publishers(publisher_id)
);

CREATE TABLE IF NOT EXISTS assignment2.customers(
	customer_id INT PRIMARY KEY,
	customer_name VARCHAR(50) NOT NULL,
	email VARCHAR(150) UNIQUE,
	address VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS assignment2.authors(
	author_id INT PRIMARY KEY,
	author_name VARCHAR(50) NOT NULL,
	birth_date DATE,
	nationality VARCHAR(50)
);


CREATE TABLE IF NOT EXISTS assignment2.orders(
	order_id INT PRIMARY KEY,
	order_date DATE DEFAULT CURRENT_DATE,
	customer_id INT,
	total_amount INT DEFAULT 1,
	FOREIGN KEY(customer_id) REFERENCES assignment2.customers(customer_id)
);


CREATE TABLE IF NOT EXISTS assignment2.book_authors(
	book_id INT,
	author_id INT,
	PRIMARY KEY(book_id, author_id),
	FOREIGN KEY(book_id) REFERENCES Assignment2.books(book_id),
	FOREIGN KEY(author_id) REFERENCES assignment2.authors(author_id)
);


CREATE TABLE IF NOT EXISTS assignment2.order_items(	
	order_id INT,
	book_id INT,
	PRIMARY KEY(order_id, book_id),
	FOREIGN KEY(book_id) REFERENCES assignment2.books(book_id),
	FOREIGN KEY(order_id) REFERENCES assignment2.orders(order_id)
);
