-- Students table
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(50),
    student_age INT,
    student_grade_id INT,
    FOREIGN KEY (student_grade_id) REFERENCES Grades(grade_id)
);

-- Grades table
CREATE TABLE Grades (
    grade_id INT PRIMARY KEY,
    grade_name VARCHAR(10)
);

-- Courses table
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(50)
);

-- Enrollments table
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id)
);

Insert queries:

-- Insert into Grades table
INSERT INTO Grades (grade_id, grade_name) VALUES
(1, 'A'),
(2, 'B'),
(3, 'C');

-- Insert into Courses table
INSERT INTO Courses (course_id, course_name) VALUES
(101, 'Math'),
(102, 'Science'),
(103, 'History');

-- Insert into Students table
INSERT INTO Students (student_id, student_name, student_age, student_grade_id) VALUES
(1, 'Alice', 17, 1),
(2, 'Bob', 16, 2),
(3, 'Charlie', 18, 1),
(4, 'David', 16, 2),
(5, 'Eve', 17, 1),
(6, 'Frank', 18, 3),
(7, 'Grace', 17, 2),
(8, 'Henry', 16, 1),
(9, 'Ivy', 18, 2),
(10, 'Jack', 17, 3);

-- Insert into Enrollments table
INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date) VALUES
(1, 1, 101, '2023-09-01'),
(2, 1, 102, '2023-09-01'),
(3, 2, 102, '2023-09-01'),
(4, 3, 101, '2023-09-01'),
(5, 3, 103, '2023-09-01'),
(6, 4, 101, '2023-09-01'),
(7, 4, 102, '2023-09-01'),
(8, 5, 102, '2023-09-01'),
(9, 6, 101, '2023-09-01'),
(10, 7, 103, '2023-09-01'),
(11, 1, 103, '2023-09-01');

-- 1. Find all students enrolled in the Math course.
SELECT s.student_id, s.student_name FROM school.students s
WHERE s.student_id IN
(SELECT e.student_id FROM school.enrollments e WHERE e.course_id =
(SELECT c.course_id FROM school.courses c WHERE c.course_name = 'Math'));

-- 2. List all courses taken by students named Bob.
SELECT  c.course_id, c.course_name FROM school.courses c 
WHERE c.course_id IN
(SELECT e.course_id FROM school.enrollments e WHERE e.student_id =
(SELECT s.student_id FROM school.students s WHERE s.student_name = 'Bob'));

-- 3. Find the names of students who are enrolled in more than one course.
SELECT s.student_name
FROM school.students s
WHERE s.student_id IN(
SELECT e.student_id FROM school.enrollments e
GROUP BY e.student_id 
HAVING COUNT (e.course_id)>1);

-- 4. List all students who are in Grade A (grade_id = 1).
SELECT s.student_name FROM school.students s WHERE s.student_grade_id IN
(SELECT g.grade_id FROM school.grades g WHERE grade_name='A');

-- 5. Find the number of students enrolled in each course.
SELECT e.course_id,COUNT(e.student_id) FROM school.enrollments e
GROUP BY e.course_id
ORDER BY e.course_id ASC;

-- 6. Retrieve the course with the highest number of enrollments.
SELECT e.course_id FROM school.enrollments e
GROUP BY e.course_id
HAVING COUNT(e.student_id) = (
    SELECT MAX(student_count)
    FROM (
        SELECT COUNT(student_id) AS student_count
        FROM school.enrollments
        GROUP BY course_id
    ) AS max_counts
);

-- 7. List students who are enrolled in all available courses.
SELECT e.student_id FROM school.enrollments e 
GROUP BY (e.student_id)
HAVING COUNT(e.course_id)=
(SELECT COUNT(c.course_id) FROM school.courses c)

-- 8. Find students who are not enrolled in any courses.
SELECT s.student_id, s.student_name FROM school.students s
WHERE s.student_id NOT IN
(SELECT e.student_id FROM school.enrollments e);

-- 9. Retrieve the average age of students enrolled in the Science course.
SELECT AVG(s.student_age) as average_age FROM school.students s WHERE s.student_id IN
(SELECT e.student_id FROM school.enrollments e WHERE e.course_id =
(SELECT c.course_id FROM school.courses c WHERE c.course_name = 'Science'));

-- 10. Find the grade of students enrolled in the History course.
SELECT s.student_name, 
(SELECT g.grade_name FROM school.grades g WHERE s.student_grade_id = g.grade_id) 
FROM school.students s 
WHERE s.student_id IN
(SELECT e.student_id FROM school.enrollments e WHERE e.course_id =
(SELECT c.course_id FROM school.courses c WHERE c.course_name = 'History'));
