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
