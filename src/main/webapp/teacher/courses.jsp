<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.onlineexam.model.*" %>
<%@ page import="java.util.List" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    @SuppressWarnings("unchecked")
    List<Course> courses = (List<Course>) request.getAttribute("courses");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý lớp học</title>
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
        
        .btn {
            padding: 8px 16px;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
            margin: 5px;
        }
        
        .btn-primary {
            background: #667eea;
            color: white;
        }
        
        .btn-back {
            background: rgba(255,255,255,0.2);
            color: white;
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .course-list {
            display: grid;
            gap: 20px;
            margin-top: 20px;
        }
        
        .course-item {
            background: white;
            padding: 20px;
            border-radius: 10px;
            border: 1px solid #e0e0e0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .course-item h4 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .course-item p {
            color: #666;
            font-size: 14px;
        }
        
        .course-actions {
            display: flex;
            gap: 10px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>📚 Quản lý lớp học</h1>
            <div>
                <a href="<%= request.getContextPath() %>/teacher/dashboard" class="btn btn-back">← Quay lại Dashboard</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="card">
            <h2>Danh sách lớp học phần</h2>
            
            <div class="course-list">
                <% if (courses != null && !courses.isEmpty()) { 
                    for (Course course : courses) { %>
                        <div class="course-item">
                            <div>
                                <h4><%= course.getCourseName() %></h4>
                                <p>
                                    Mã lớp: <strong><%= course.getCourseCode() %></strong> | 
                                    Học kỳ: <strong><%= course.getSemester() %> - <%= course.getYear() %></strong> |
                                    Sinh viên: <strong><%= course.getEnrolledStudents() %></strong>
                                </p>
                                <% if (course.getDescription() != null && !course.getDescription().isEmpty()) { %>
                                    <p style="margin-top: 5px;"><em><%= course.getDescription() %></em></p>
                                <% } %>
                            </div>
                            <div class="course-actions">
                                <a href="<%= request.getContextPath() %>/teacher/courses?courseId=<%= course.getCourseId() %>" class="btn btn-primary">Chi tiết</a>
                                <a href="<%= request.getContextPath() %>/teacher/exams?courseId=<%= course.getCourseId() %>" class="btn btn-primary">Quản lý thi</a>
                            </div>
                        </div>
                    <% } 
                } else { %>
                    <p style="text-align: center; padding: 40px; color: #999;">
                        Bạn chưa có lớp học phần nào. Liên hệ quản trị viên để được thêm lớp học.
                    </p>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>
