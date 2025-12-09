-- Online Exam System Database Schema

-- Table: users (parent table for students and teachers)
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    user_type ENUM('STUDENT', 'TEACHER') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- Table: students
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,
    student_code VARCHAR(20) UNIQUE NOT NULL,
    major VARCHAR(100),
    year_of_study INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Table: teachers
CREATE TABLE teachers (
    teacher_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT UNIQUE NOT NULL,
    teacher_code VARCHAR(20) UNIQUE NOT NULL,
    department VARCHAR(100),
    title VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Table: courses (lớp học phần)
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    course_name VARCHAR(200) NOT NULL,
    teacher_id INT NOT NULL,
    semester VARCHAR(20) NOT NULL,
    year INT NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id) ON DELETE CASCADE
);

-- Table: course_enrollments (sinh viên đăng ký lớp học phần)
CREATE TABLE course_enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ACTIVE', 'DROPPED', 'COMPLETED') DEFAULT 'ACTIVE',
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (student_id, course_id)
);

-- Table: exams (bài kiểm tra)
CREATE TABLE exams (
    exam_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT NOT NULL,
    exam_title VARCHAR(200) NOT NULL,
    description TEXT,
    exam_file_path VARCHAR(500) NOT NULL,
    duration_minutes INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    total_questions INT NOT NULL,
    pass_score DECIMAL(5,2) DEFAULT 50.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by INT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES teachers(teacher_id)
);

-- Table: exam_submissions (bài thi đã nộp)
CREATE TABLE exam_submissions (
    submission_id INT PRIMARY KEY AUTO_INCREMENT,
    exam_id INT NOT NULL,
    student_id INT NOT NULL,
    answers_json TEXT NOT NULL,
    score DECIMAL(5,2) NOT NULL,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    time_taken_minutes INT,
    is_passed BOOLEAN,
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    UNIQUE KEY unique_submission (exam_id, student_id)
);

-- Table: exam_questions (cache questions from JSON for easier grading)
CREATE TABLE exam_questions (
    question_id INT PRIMARY KEY AUTO_INCREMENT,
    exam_id INT NOT NULL,
    question_number INT NOT NULL,
    question_text TEXT NOT NULL,
    question_type ENUM('MULTIPLE_CHOICE', 'TRUE_FALSE') DEFAULT 'MULTIPLE_CHOICE',
    options_json TEXT,
    correct_answer VARCHAR(10) NOT NULL,
    points DECIMAL(5,2) DEFAULT 1.00,
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id) ON DELETE CASCADE
);

-- Table: notifications (thông báo cho sinh viên)
CREATE TABLE notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    notification_type ENUM('EXAM_CREATED', 'EXAM_REMINDER', 'GRADE_POSTED', 'GENERAL') DEFAULT 'GENERAL',
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Indexes for better performance
CREATE INDEX idx_user_type ON users(user_type);
CREATE INDEX idx_user_username ON users(username);
CREATE INDEX idx_course_teacher ON courses(teacher_id);
CREATE INDEX idx_enrollment_student ON course_enrollments(student_id);
CREATE INDEX idx_enrollment_course ON course_enrollments(course_id);
CREATE INDEX idx_exam_course ON exams(course_id);
CREATE INDEX idx_exam_times ON exams(start_time, end_time);
CREATE INDEX idx_submission_student ON exam_submissions(student_id);
CREATE INDEX idx_submission_exam ON exam_submissions(exam_id);
CREATE INDEX idx_notification_user ON notifications(user_id, is_read);

-- Insert sample data for testing
-- Password for all users: password123 (hashed with BCrypt)
-- Note: In production, use proper password hashing

-- Insert sample teachers
INSERT INTO users (username, password_hash, email, full_name, user_type) VALUES
('teacher1', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'teacher1@university.edu', 'Nguyễn Văn Giáo', 'TEACHER'),
('teacher2', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'teacher2@university.edu', 'Trần Thị Linh', 'TEACHER');

INSERT INTO teachers (user_id, teacher_code, department, title) VALUES
(1, 'GV001', 'Khoa Công Nghệ Thông Tin', 'Giảng viên'),
(2, 'GV002', 'Khoa Toán - Tin học', 'Phó Giáo sư');

-- Insert sample students (expanded list)
INSERT INTO users (username, password_hash, email, full_name, user_type) VALUES
('student1', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student1@student.edu', 'Lê Văn An', 'STUDENT'),
('student2', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student2@student.edu', 'Phạm Thị Bình', 'STUDENT'),
('student3', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student3@student.edu', 'Hoàng Văn Cường', 'STUDENT'),
('student4', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student4@student.edu', 'Nguyễn Thị Dung', 'STUDENT'),
('student5', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student5@student.edu', 'Trần Văn Em', 'STUDENT'),
('student6', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student6@student.edu', 'Võ Thị Phượng', 'STUDENT'),
('student7', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student7@student.edu', 'Đặng Văn Giang', 'STUDENT'),
('student8', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student8@student.edu', 'Bùi Thị Hương', 'STUDENT'),
('student9', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student9@student.edu', 'Phan Văn Ích', 'STUDENT'),
('student10', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student10@student.edu', 'Lý Thị Kim', 'STUDENT'),
('student11', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student11@student.edu', 'Hồ Văn Long', 'STUDENT'),
('student12', '$2a$10$xS6LwYQBUZ0RZYYPCzUFXu5.VdqvLwJHh7MqKvW9fwT7t9wT7t9wT', 'student12@student.edu', 'Đinh Thị Mai', 'STUDENT');

INSERT INTO students (user_id, student_code, major, year_of_study) VALUES
(3, 'SV001', 'Công nghệ phần mềm', 3),
(4, 'SV002', 'Khoa học máy tính', 2),
(5, 'SV003', 'Hệ thống thông tin', 3),
(6, 'SV004', 'Công nghệ phần mềm', 2),
(7, 'SV005', 'Khoa học máy tính', 3),
(8, 'SV006', 'Hệ thống thông tin', 2),
(9, 'SV007', 'Công nghệ phần mềm', 4),
(10, 'SV008', 'Khoa học máy tính', 1),
(11, 'SV009', 'Hệ thống thông tin', 4),
(12, 'SV010', 'Công nghệ phần mềm', 1),
(13, 'SV011', 'Khoa học máy tính', 3),
(14, 'SV012', 'Hệ thống thông tin', 2);

-- Insert sample courses
INSERT INTO courses (course_code, course_name, teacher_id, semester, year, description) VALUES
('IT101', 'Lập trình Java cơ bản', 1, 'HK1', 2024, 'Môn học cơ bản về lập trình Java'),
('IT201', 'Cơ sở dữ liệu', 1, 'HK1', 2024, 'Thiết kế và quản trị cơ sở dữ liệu'),
('IT301', 'Công nghệ Web', 2, 'HK1', 2024, 'Phát triển ứng dụng web với Java'),
('IT401', 'Kiến trúc phần mềm', 2, 'HK1', 2024, 'Thiết kế và kiến trúc hệ thống phần mềm');

-- Enroll students to courses (multiple students per course)
INSERT INTO course_enrollments (student_id, course_id, status) VALUES
-- IT101: Lập trình Java cơ bản (8 students)
(1, 1, 'ACTIVE'), (2, 1, 'ACTIVE'), (4, 1, 'ACTIVE'), (6, 1, 'ACTIVE'),
(8, 1, 'ACTIVE'), (10, 1, 'ACTIVE'), (12, 1, 'ACTIVE'), (5, 1, 'ACTIVE'),
-- IT201: Cơ sở dữ liệu (10 students)
(1, 2, 'ACTIVE'), (2, 2, 'ACTIVE'), (3, 2, 'ACTIVE'), (5, 2, 'ACTIVE'),
(7, 2, 'ACTIVE'), (9, 2, 'ACTIVE'), (11, 2, 'ACTIVE'), (4, 2, 'ACTIVE'),
(6, 2, 'ACTIVE'), (8, 2, 'ACTIVE'),
-- IT301: Công nghệ Web (7 students)
(1, 3, 'ACTIVE'), (3, 3, 'ACTIVE'), (5, 3, 'ACTIVE'), (7, 3, 'ACTIVE'),
(9, 3, 'ACTIVE'), (11, 3, 'ACTIVE'), (2, 3, 'ACTIVE'),
-- IT401: Kiến trúc phần mềm (6 students)
(2, 4, 'ACTIVE'), (3, 4, 'ACTIVE'), (4, 4, 'ACTIVE'), (6, 4, 'ACTIVE'),
(8, 4, 'ACTIVE'), (10, 4, 'ACTIVE');