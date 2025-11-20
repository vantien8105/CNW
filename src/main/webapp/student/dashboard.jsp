<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.onlineexam.model.*" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    Student student = (Student) session.getAttribute("student");
    if (user == null || student == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    @SuppressWarnings("unchecked")
    List<ExamSubmission> recentSubmissions = (List<ExamSubmission>) request.getAttribute("recentSubmissions");
    Integer availableExamsCount = (Integer) request.getAttribute("availableExamsCount");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Sinh viên</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f5f5f5;
        }
        
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .header .container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header h1 {
            font-size: 24px;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .btn-logout {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 8px 20px;
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 5px;
            text-decoration: none;
            transition: background 0.3s;
        }
        
        .btn-logout:hover {
            background: rgba(255,255,255,0.3);
        }
        
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .welcome {
            background: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .welcome h2 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .welcome p {
            color: #666;
        }
        
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .stat-card h3 {
            font-size: 36px;
            color: #667eea;
            margin-bottom: 10px;
        }
        
        .stat-card p {
            color: #666;
            font-size: 14px;
        }
        
        .section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .section h3 {
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .course-list, .exam-list {
            display: grid;
            gap: 15px;
        }
        
        .course-item, .exam-item {
            padding: 15px;
            background: #f9f9f9;
            border-radius: 5px;
            border-left: 4px solid #667eea;
        }
        
        .course-item h4, .exam-item h4 {
            color: #333;
            margin-bottom: 5px;
        }
        
        .course-item p, .exam-item p {
            color: #666;
            font-size: 14px;
        }
        
        .btn-primary {
            display: inline-block;
            padding: 10px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin-top: 10px;
            transition: background 0.3s;
        }
        
        .btn-primary:hover {
            background: #5568d3;
        }
        
        .score {
            font-weight: bold;
            color: #667eea;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>🎓 OnlineExam - Sinh viên</h1>
            <div class="user-info">
                <span>Xin chào, <%= user.getFullName() %></span>
                <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Đăng xuất</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="welcome">
            <h2>Chào mừng bạn trở lại!</h2>
            <p>Mã sinh viên: <%= student.getStudentCode() %> | Chuyên ngành: <%= student.getMajor() %></p>
        </div>
        
        <div class="stats">
            <div class="stat-card">
                <h3><%= courses != null ? courses.size() : 0 %></h3>
                <p>Lớp học phần</p>
            </div>
            <div class="stat-card">
                <h3><%= availableExamsCount != null ? availableExamsCount : 0 %></h3>
                <p>Bài thi có thể làm</p>
            </div>
            <div class="stat-card">
                <h3><%= recentSubmissions != null ? recentSubmissions.size() : 0 %></h3>
                <p>Bài thi đã làm</p>
            </div>
        </div>
        
        <div class="section">
            <h3>📚 Lớp học phần của tôi</h3>
            <div class="course-list">
                <% if (courses != null && !courses.isEmpty()) { 
                    for (Course course : courses) { %>
                        <div class="course-item">
                            <h4><%= course.getCourseName() %></h4>
                            <p>Mã lớp: <%= course.getCourseCode() %> | Học kỳ: <%= course.getSemester() %> - <%= course.getYear() %></p>
                            <a href="<%= request.getContextPath() %>/student/exams?action=viewExams&courseId=<%= course.getCourseId() %>" class="btn-primary">Xem bài thi</a>
                        </div>
                    <% } 
                } else { %>
                    <p>Bạn chưa đăng ký lớp học phần nào.</p>
                <% } %>
            </div>
            <a href="<%= request.getContextPath() %>/student/exams" class="btn-primary" style="margin-top: 20px;">📝 Xem tất cả bài thi</a>
        </div>
        
        <div class="section">
            <h3>📝 Lịch sử thi gần đây</h3>
            <div class="exam-list">
                <% if (recentSubmissions != null && !recentSubmissions.isEmpty()) { 
                    for (ExamSubmission submission : recentSubmissions) { %>
                        <div class="exam-item">
                            <h4>Bài thi #<%= submission.getExamId() %></h4>
                            <p>
                                Điểm: <span class="score"><%= String.format("%.2f", submission.getScore()) %></span> | 
                                Thời gian nộp: <%= submission.getSubmittedAt() %>
                            </p>
                        </div>
                    <% } 
                } else { %>
                    <p>Bạn chưa làm bài thi nào.</p>
                <% } %>
            </div>
            <a href="<%= request.getContextPath() %>/student/results" class="btn-primary">Xem tất cả kết quả</a>
        </div>
    </div>
</body>
</html>
