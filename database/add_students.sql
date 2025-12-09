-- Script to add more students to the existing database
-- This script adds 9 new students and enrolls them in courses
-- Password for all new users: password123

-- Add new student users (student4 to student12)
INSERT INTO users (username, password_hash, email, full_name, user_type) VALUES
('student4', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student4@student.edu', 'Nguyễn Thị Dung', 'STUDENT'),
('student5', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student5@student.edu', 'Trần Văn Em', 'STUDENT'),
('student6', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student6@student.edu', 'Võ Thị Phượng', 'STUDENT'),
('student7', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student7@student.edu', 'Đặng Văn Giang', 'STUDENT'),
('student8', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student8@student.edu', 'Bùi Thị Hương', 'STUDENT'),
('student9', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student9@student.edu', 'Phan Văn Ích', 'STUDENT'),
('student10', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student10@student.edu', 'Lý Thị Kim', 'STUDENT'),
('student11', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student11@student.edu', 'Hồ Văn Long', 'STUDENT'),
('student12', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student12@student.edu', 'Đinh Thị Mai', 'STUDENT');

-- Get the last user_id to use for student records
-- Assuming existing users are IDs 1-5, new users will be 6-14
INSERT INTO students (user_id, student_code, major, year_of_study) VALUES
(6, 'SV004', 'Công nghệ phần mềm', 2),
(7, 'SV005', 'Khoa học máy tính', 3),
(8, 'SV006', 'Hệ thống thông tin', 2),
(9, 'SV007', 'Công nghệ phần mềm', 4),
(10, 'SV008', 'Khoa học máy tính', 1),
(11, 'SV009', 'Hệ thống thông tin', 4),
(12, 'SV010', 'Công nghệ phần mềm', 1),
(13, 'SV011', 'Khoa học máy tính', 3),
(14, 'SV012', 'Hệ thống thông tin', 2);

-- Add new enrollments to existing courses
-- Enroll new students to courses to increase class sizes
-- Assuming existing student_ids are 1-3, new student_ids will be 4-12
INSERT INTO course_enrollments (student_id, course_id, status) VALUES
-- IT101: Lập trình Java cơ bản (adding 5 more students)
(4, 1, 'ACTIVE'), (6, 1, 'ACTIVE'), (8, 1, 'ACTIVE'), (10, 1, 'ACTIVE'), (12, 1, 'ACTIVE'),
-- IT201: Cơ sở dữ liệu (adding 7 more students)
(4, 2, 'ACTIVE'), (5, 2, 'ACTIVE'), (6, 2, 'ACTIVE'), (7, 2, 'ACTIVE'), 
(8, 2, 'ACTIVE'), (9, 2, 'ACTIVE'), (11, 2, 'ACTIVE'),
-- IT301: Công nghệ Web (adding 4 more students)
(2, 3, 'ACTIVE'), (5, 3, 'ACTIVE'), (7, 3, 'ACTIVE'), (9, 3, 'ACTIVE'), (11, 3, 'ACTIVE'),
-- IT401: Kiến trúc phần mềm (adding 3 more students)
(4, 4, 'ACTIVE'), (6, 4, 'ACTIVE'), (8, 4, 'ACTIVE'), (10, 4, 'ACTIVE');

-- Display summary
SELECT 'New students added successfully!' AS status;
SELECT COUNT(*) AS total_students FROM students;
SELECT c.course_name, COUNT(ce.enrollment_id) AS enrolled_count
FROM courses c
LEFT JOIN course_enrollments ce ON c.course_id = ce.course_id
WHERE ce.status = 'ACTIVE'
GROUP BY c.course_id, c.course_name
ORDER BY c.course_code;
