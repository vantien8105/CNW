<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.onlineexam.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    Course course = (Course) request.getAttribute("course");
    @SuppressWarnings("unchecked")
    List<Exam> exams = (List<Exam>) request.getAttribute("exams");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý bài kiểm tra</title>
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
        
        .exam-list {
            display: grid;
            gap: 15px;
            margin-top: 20px;
        }
        
        .exam-item {
            background: white;
            padding: 20px;
            border-radius: 10px;
            border: 1px solid #e0e0e0;
        }
        
        .exam-item h4 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .exam-item p {
            color: #666;
            font-size: 14px;
            margin: 5px 0;
        }
        
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 3px;
            font-size: 12px;
            margin-right: 5px;
        }
        
        .badge-active {
            background: #4caf50;
            color: white;
        }
        
        .badge-upcoming {
            background: #2196f3;
            color: white;
        }
        
        .badge-ended {
            background: #9e9e9e;
            color: white;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>📝 Quản lý bài kiểm tra</h1>
            <div>
                <a href="<%= request.getContextPath() %>/teacher/exams?action=create" class="btn btn-primary">+ Tạo bài kiểm tra</a>
                <a href="<%= request.getContextPath() %>/teacher/dashboard" class="btn btn-back">← Quay lại</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="card">
            <% if (course != null) { %>
                <h2><%= course.getCourseName() %></h2>
                <p style="color: #666; margin-top: 5px;">
                    Mã lớp: <strong><%= course.getCourseCode() %></strong> | 
                    Học kỳ: <strong><%= course.getSemester() %> - <%= course.getYear() %></strong>
                </p>
            <% } else { %>
                <h2>Danh sách bài kiểm tra</h2>
            <% } %>
            
            <div class="exam-list">
                <% if (exams != null && !exams.isEmpty()) { 
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                    for (Exam exam : exams) { 
                        String status = exam.isAvailable() ? "active" : (exam.isUpcoming() ? "upcoming" : "ended");
                        String statusText = exam.isAvailable() ? "Đang mở" : (exam.isUpcoming() ? "Sắp tới" : "Đã kết thúc");
                        String badgeClass = exam.isAvailable() ? "badge-active" : (exam.isUpcoming() ? "badge-upcoming" : "badge-ended");
                %>
                    <div class="exam-item">
                        <div style="display: flex; justify-content: space-between; align-items: start;">
                            <div style="flex: 1;">
                                <h4>
                                    <%= exam.getExamTitle() %>
                                    <span class="badge <%= badgeClass %>"><%= statusText %></span>
                                </h4>
                                <% if (exam.getDescription() != null && !exam.getDescription().isEmpty()) { %>
                                    <p><em><%= exam.getDescription() %></em></p>
                                <% } %>
                                <p>
                                    ⏱️ Thời lượng: <strong><%= exam.getDurationMinutes() %> phút</strong> | 
                                    📊 Điểm đạt: <strong><%= exam.getPassScore() %>%</strong> |
                                    ❓ Số câu: <strong><%= exam.getTotalQuestions() %></strong>
                                </p>
                                <p>
                                    🕐 Bắt đầu: <strong><%= exam.getStartTime().format(formatter) %></strong> | 
                                    🕐 Kết thúc: <strong><%= exam.getEndTime().format(formatter) %></strong>
                                </p>
                            </div>
                            <div>
                                <a href="<%= request.getContextPath() %>/teacher/grades?examId=<%= exam.getExamId() %>" class="btn btn-primary">Xem kết quả</a>
                            </div>
                        </div>
                    </div>
                <% } 
                } else { %>
                    <p style="text-align: center; padding: 40px; color: #999;">
                        Chưa có bài kiểm tra nào. 
                        <a href="<%= request.getContextPath() %>/teacher/exams?action=create">Tạo bài kiểm tra đầu tiên →</a>
                    </p>
                <% } %>
            </div>
        </div>
    </div>
</body>
</html>
