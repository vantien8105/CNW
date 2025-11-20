# Hệ thống Thi Trắc Nghiệm Trực Tuyến

## Mô tả
Hệ thống thi trắc nghiệm trực tuyến cho sinh viên và giảng viên được xây dựng bằng Java Servlet và JSP.

## Tính năng chính

### Giảng viên:
1. **Quản lý lớp học phần**: Tạo, xem và quản lý các lớp học phần
2. **Tạo bài kiểm tra**: Upload file đề thi (JSON format), thiết lập thời gian bắt đầu/kết thúc, thời gian làm bài
3. **Xem danh sách điểm**: Theo dõi kết quả thi của sinh viên trong từng lớp học phần
4. **Dashboard**: Tổng quan về lớp học, bài thi và sinh viên

### Sinh viên:
1. **Xem lớp học phần**: Danh sách các lớp học phần đã đăng ký (3-4 lớp)
2. **Làm bài thi**: Tham gia bài thi khi được mở, chỉ được làm 1 lần
3. **Xem lịch sử thi**: Xem lại các bài thi đã làm và điểm số
4. **Dashboard**: Tổng quan về lớp học, bài thi sắp tới và kết quả

### Chung:
1. **Đăng nhập/Đăng xuất**: Xác thực người dùng
2. **Quản lý profile**: Xem và cập nhật thông tin cá nhân
3. **Thông báo**: Nhận thông báo về bài thi mới, nhắc nhở thi, điểm số

## Cấu trúc Database

### Tables:
- `users`: Thông tin người dùng (sinh viên và giảng viên)
- `students`: Thông tin chi tiết sinh viên
- `teachers`: Thông tin chi tiết giảng viên
- `courses`: Lớp học phần
- `course_enrollments`: Đăng ký lớp học phần
- `exams`: Bài kiểm tra
- `exam_submissions`: Bài thi đã nộp
- `exam_questions`: Câu hỏi thi (cache từ JSON)
- `notifications`: Thông báo

## Yêu cầu hệ thống

1. **Java**: JDK 8 trở lên
2. **Application Server**: Apache Tomcat 9.0 trở lên
3. **Database**: MySQL 5.7 trở lên
4. **Build Tool**: Maven (tùy chọn)

## Thư viện cần thiết

Thêm các thư viện sau vào `WEB-INF/lib/`:

1. **MySQL Connector**: `mysql-connector-java-8.0.x.jar`
   - Download: https://dev.mysql.com/downloads/connector/j/

2. **Servlet API**: `javax.servlet-api-4.0.x.jar`
   - Thường có sẵn trong Tomcat, nếu không:
   - Download: https://mvnrepository.com/artifact/javax.servlet/javax.servlet-api

3. **JSON Processing**: `gson-2.8.x.jar` hoặc `json-20210307.jar`
   - Gson: https://mvnrepository.com/artifact/com.google.code.gson/gson
   - JSON: https://mvnrepository.com/artifact/org.json/json

4. **JSTL**: `jstl-1.2.jar` (cho JSP pages)
   - Download: https://mvnrepository.com/artifact/javax.servlet/jstl

## Cài đặt

### 1. Tạo Database

```bash
# Đăng nhập MySQL
mysql -u root -p

# Tạo database
CREATE DATABASE online_exam_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# Import schema
USE online_exam_db;
SOURCE /path/to/database/schema.sql;
```

### 2. Cấu hình Database Connection

Chỉnh sửa file `src/main/java/com/onlineexam/util/DatabaseConnection.java`:

```java
private static final String URL = "jdbc:mysql://localhost:3306/online_exam_db";
private static final String USERNAME = "root";
private static final String PASSWORD = "your_password"; // Thay đổi password
```

### 3. Thêm thư viện

Tải và copy các file JAR vào thư mục `src/main/webapp/WEB-INF/lib/`:

```
WEB-INF/lib/
├── mysql-connector-java-8.0.x.jar
├── gson-2.8.x.jar
├── jstl-1.2.jar
└── javax.servlet-api-4.0.x.jar (nếu cần)
```

### 4. Deploy lên Tomcat

#### Cách 1: Sử dụng Eclipse/IntelliJ
1. Right-click project → Run As → Run on Server
2. Chọn Tomcat server
3. Click Finish

#### Cách 2: Manual Deploy
1. Export project as WAR file
2. Copy WAR file vào thư mục `tomcat/webapps/`
3. Start Tomcat server

### 5. Truy cập ứng dụng

```
http://localhost:8080/OnlineExam/
```

## Tài khoản mẫu

### Giảng viên:
- Username: `teacher1` / Password: `password123`
- Username: `teacher2` / Password: `password123`

### Sinh viên:
- Username: `student1` / Password: `password123`
- Username: `student2` / Password: `password123`
- Username: `student3` / Password: `password123`

## Format File Đề Thi (JSON)

```json
{
  "examTitle": "Kiểm tra giữa kỳ - Lập trình Java",
  "description": "Bài kiểm tra 50 câu hỏi trắc nghiệm",
  "totalQuestions": 50,
  "durationMinutes": 90,
  "passScore": 50.0,
  "questions": [
    {
      "questionNumber": 1,
      "questionText": "Java là gì?",
      "questionType": "MULTIPLE_CHOICE",
      "options": [
        {"key": "A", "value": "Ngôn ngữ lập trình"},
        {"key": "B", "value": "Hệ điều hành"},
        {"key": "C", "value": "Cơ sở dữ liệu"},
        {"key": "D", "value": "Trình duyệt web"}
      ],
      "correctAnswer": "A",
      "points": 2.0
    },
    {
      "questionNumber": 2,
      "questionText": "Java là ngôn ngữ hướng đối tượng?",
      "questionType": "TRUE_FALSE",
      "options": [
        {"key": "T", "value": "Đúng"},
        {"key": "F", "value": "Sai"}
      ],
      "correctAnswer": "T",
      "points": 2.0
    }
  ]
}
```

## Cấu trúc Project

```
OnlineExam/
├── src/main/java/com/onlineexam/
│   ├── model/          # Entities (User, Student, Teacher, Course, Exam, ...)
│   ├── dao/            # Data Access Objects
│   ├── servlet/        # Controllers (Login, Dashboard, Exam, ...)
│   └── util/           # Utilities (Database, Password, Session)
├── src/main/webapp/
│   ├── WEB-INF/
│   │   ├── web.xml     # Servlet configuration
│   │   └── lib/        # JAR libraries
│   ├── css/            # Stylesheets
│   ├── js/             # JavaScript files
│   ├── student/        # Student JSP pages
│   ├── teacher/        # Teacher JSP pages
│   ├── login.jsp       # Login page
│   └── index.jsp       # Welcome page
├── database/
│   └── schema.sql      # Database schema
└── README.md
```

## API Endpoints (Servlets)

### Authentication
- `GET/POST /login` - Đăng nhập
- `GET /logout` - Đăng xuất

### Student
- `GET /student/dashboard` - Dashboard sinh viên
- `GET /student/exam?id={examId}` - Xem/làm bài thi
- `POST /student/submit` - Nộp bài thi
- `GET /student/results` - Xem lịch sử thi và điểm

### Teacher
- `GET /teacher/dashboard` - Dashboard giảng viên
- `GET /teacher/courses` - Quản lý lớp học phần
- `GET /teacher/exams` - Quản lý bài kiểm tra
- `POST /teacher/exams` - Tạo bài kiểm tra mới
- `GET /teacher/grades?courseId={courseId}` - Xem danh sách điểm

### Common
- `GET /profile` - Xem profile
- `POST /profile` - Cập nhật profile

## Quy trình làm bài thi

1. **Sinh viên đăng nhập** → Vào dashboard
2. **Chọn lớp học phần** → Xem danh sách bài thi
3. **Kiểm tra điều kiện**:
   - Bài thi đã mở (trong khoảng thời gian cho phép)
   - Chưa làm bài này trước đó
4. **Bắt đầu làm bài** → Hệ thống ghi lại thời gian bắt đầu
5. **Trả lời câu hỏi** → Có thể lưu nháp (tùy chọn)
6. **Nộp bài** → Hệ thống tự động chấm điểm
7. **Xem kết quả** → Điểm số và đánh giá

## Chức năng bổ sung (thực tiễn)

1. **Bảo mật**:
   - Mã hóa mật khẩu (SHA-256)
   - Session management
   - Kiểm tra quyền truy cập

2. **Chống gian lận**:
   - Chỉ cho phép làm bài 1 lần
   - Kiểm tra thời gian làm bài
   - Ghi log hoạt động

3. **Thông báo**:
   - Thông báo bài thi mới
   - Nhắc nhở trước khi thi
   - Thông báo kết quả

4. **Quản lý**:
   - Export danh sách điểm (Excel/PDF)
   - Thống kê phân tích
   - Backup dữ liệu

## Troubleshooting

### Lỗi kết nối database
```
Error: Unable to connect to database
```
**Giải pháp**: Kiểm tra MySQL đang chạy, username/password đúng, database đã tạo

### Lỗi 404 Not Found
```
HTTP Status 404 – Not Found
```
**Giải pháp**: Kiểm tra URL mapping trong web.xml, servlet class name đúng

### Lỗi ClassNotFoundException
```
ClassNotFoundException: com.mysql.cj.jdbc.Driver
```
**Giải pháp**: Thêm mysql-connector-java JAR vào WEB-INF/lib

## Phát triển thêm

### Tính năng có thể mở rộng:
1. Upload ảnh trong câu hỏi
2. Hỗ trợ nhiều định dạng câu hỏi (điền vào chỗ trống, essay)
3. Thi online có giám sát (webcam)
4. Mobile app
5. API REST cho integration
6. Real-time notifications
7. Discussion forum cho từng lớp

## License
Educational project - Free to use and modify

## Liên hệ
Để được hỗ trợ, vui lòng tạo issue trên GitHub hoặc liên hệ admin.
