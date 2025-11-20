<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.onlineexam.model.*" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    Teacher teacher = (Teacher) session.getAttribute("teacher");
    if (user == null || teacher == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<Course> courses = (List<Course>) request.getAttribute("courses");
    Integer totalExams = (Integer) request.getAttribute("totalExams");
    Integer activeExams = (Integer) request.getAttribute("activeExams");
    Integer totalStudents = (Integer) request.getAttribute("totalStudents");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Giảng viên</title>
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
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
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
            color: #f5576c;
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
        
        .course-list {
            display: grid;
            gap: 15px;
        }
        
        .course-item {
            padding: 15px;
            background: #f9f9f9;
            border-radius: 5px;
            border-left: 4px solid #f5576c;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .course-info h4 {
            color: #333;
            margin-bottom: 5px;
        }
        
        .course-info p {
            color: #666;
            font-size: 14px;
        }
        
        .course-actions {
            display: flex;
            gap: 10px;
        }
        
        .btn-primary, .btn-secondary {
            display: inline-block;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: #f5576c;
            color: white;
        }
        
        .btn-primary:hover {
            background: #e04656;
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .quick-actions {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .quick-action-btn {
            flex: 1;
            min-width: 200px;
            padding: 20px;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            text-align: center;
            border-radius: 10px;
            text-decoration: none;
            transition: transform 0.3s;
        }
        
        .quick-action-btn:hover {
            transform: translateY(-5px);
        }
        
        .quick-action-btn h4 {
            margin-bottom: 5px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>👨‍🏫 OnlineExam - Giảng viên</h1>
            <div class="user-info">
                <span>Xin chào, <%= user.getFullName() %></span>
                <a href="<%= request.getContextPath() %>/logout" class="btn-logout">Đăng xuất</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="welcome">
            <h2>Chào mừng bạn trở lại!</h2>
            <p>Mã giảng viên: <%= teacher.getTeacherCode() %> | Khoa: <%= teacher.getDepartment() %> | Chức danh: <%= teacher.getTitle() %></p>
        </div>
        
        <div class="stats">
            <div class="stat-card">
                <h3><%= courses != null ? courses.size() : 0 %></h3>
                <p>Lớp học phần</p>
            </div>
            <div class="stat-card">
                <h3><%= totalExams != null ? totalExams : 0 %></h3>
                <p>Tổng bài kiểm tra</p>
            </div>
            <div class="stat-card">
                <h3><%= activeExams != null ? activeExams : 0 %></h3>
                <p>Bài thi đang mở</p>
            </div>
            <div class="stat-card">
                <h3><%= totalStudents != null ? totalStudents : 0 %></h3>
                <p>Tổng sinh viên</p>
            </div>
        </div>
        
        <div class="section">
            <h3>⚡ Thao tác nhanh</h3>
            <div class="quick-actions">
                <a href="<%= request.getContextPath() %>/teacher/exams?action=create" class="quick-action-btn">
                    <h4>📝 Tạo bài kiểm tra</h4>
                    <p>Tạo bài thi mới</p>
                </a>
                <a href="<%= request.getContextPath() %>/teacher/courses" class="quick-action-btn">
                    <h4>📚 Quản lý lớp</h4>
                    <p>Xem danh sách lớp</p>
                </a>
                <a href="<%= request.getContextPath() %>/teacher/grades" class="quick-action-btn">
                    <h4>📊 Xem điểm</h4>
                    <p>Quản lý điểm thi</p>
                </a>
            </div>
        </div>
        
        <div class="section">
            <h3>📚 Lớp học phần của tôi</h3>
            <div class="course-list">
                <% if (courses != null && !courses.isEmpty()) { 
                    for (Course course : courses) { %>
                        <div class="course-item">
                            <div class="course-info">
                                <h4><%= course.getCourseName() %></h4>
                                <p>Mã lớp: <%= course.getCourseCode() %> | Học kỳ: <%= course.getSemester() %> - <%= course.getYear() %> | Sinh viên: <%= course.getEnrolledStudents() %></p>
                            </div>
                            <div class="course-actions">
                                <a href="<%= request.getContextPath() %>/teacher/exams?courseId=<%= course.getCourseId() %>" class="btn-primary">Quản lý thi</a>
                                <a href="<%= request.getContextPath() %>/teacher/grades?courseId=<%= course.getCourseId() %>" class="btn-secondary">Xem điểm</a>
                            </div>
                        </div>
                    <% } 
                } else { %>
                    <p>Bạn chưa có lớp học phần nào.</p>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>
