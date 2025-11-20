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
    
    Course course = (Course) request.getAttribute("course");
    @SuppressWarnings("unchecked")
    List<Student> students = (List<Student>) request.getAttribute("students");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết lớp học - <%= course != null ? course.getCourseName() : "" %></title>
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
        
        .btn {
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            display: inline-block;
            margin: 5px;
            transition: all 0.3s;
        }
        
        .btn-back {
            background: rgba(255,255,255,0.2);
            color: white;
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .btn-back:hover {
            background: rgba(255,255,255,0.3);
        }
        
        .btn-primary {
            background: #667eea;
            color: white;
        }
        
        .btn-primary:hover {
            background: #5568d3;
        }
        
        .btn-secondary {
            background: #48bb78;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #38a169;
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
        
        .course-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .course-info h2 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .course-info p {
            color: #666;
            margin: 5px 0;
            font-size: 14px;
        }
        
        .course-info .label {
            font-weight: 600;
            color: #444;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
        }
        
        .stat-card h3 {
            font-size: 36px;
            margin-bottom: 5px;
        }
        
        .stat-card p {
            font-size: 14px;
            opacity: 0.9;
        }
        
        .section-title {
            font-size: 20px;
            color: #333;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .student-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        
        .student-table thead {
            background: #f8f9fa;
        }
        
        .student-table th,
        .student-table td {
            padding: 15px;
            text-align: left;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .student-table th {
            font-weight: 600;
            color: #333;
            font-size: 14px;
        }
        
        .student-table td {
            color: #666;
            font-size: 14px;
        }
        
        .student-table tbody tr:hover {
            background: #f8f9fa;
        }
        
        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .badge-active {
            background: #d4edda;
            color: #155724;
        }
        
        .badge-inactive {
            background: #f8d7da;
            color: #721c24;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        
        .empty-state h3 {
            font-size: 24px;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            font-size: 16px;
        }
        
        .action-buttons {
            display: flex;
            gap: 10px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>📚 Chi tiết lớp học</h1>
            <div>
                <a href="<%= request.getContextPath() %>/teacher/courses" class="btn btn-back">← Quay lại danh sách</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <% if (course == null) { %>
            <div class="card">
                <div class="empty-state">
                    <h3>Không tìm thấy lớp học</h3>
                    <p>Lớp học không tồn tại hoặc bạn không có quyền truy cập.</p>
                    <a href="<%= request.getContextPath() %>/teacher/courses" class="btn btn-primary">Quay lại danh sách</a>
                </div>
            </div>
        <% } else { %>
            <!-- Course Information -->
            <div class="card">
                <div class="course-header">
                    <div class="course-info">
                        <h2><%= course.getCourseName() %></h2>
                        <p><span class="label">Mã lớp:</span> <%= course.getCourseCode() %></p>
                        <p><span class="label">Học kỳ:</span> <%= course.getSemester() %> - <%= course.getYear() %></p>
                        <% if (course.getDescription() != null && !course.getDescription().isEmpty()) { %>
                            <p><span class="label">Mô tả:</span> <%= course.getDescription() %></p>
                        <% } %>
                        <p><span class="label">Ngày tạo:</span> <%= course.getCreatedAt() != null ? new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm").format(course.getCreatedAt()) : "N/A" %></p>
                        <p>
                            <span class="label">Trạng thái:</span> 
                            <span class="badge <%= course.isActive() ? "badge-active" : "badge-inactive" %>">
                                <%= course.isActive() ? "Đang hoạt động" : "Không hoạt động" %>
                            </span>
                        </p>
                    </div>
                    <div class="action-buttons">
                        <a href="<%= request.getContextPath() %>/teacher/exams?courseId=<%= course.getCourseId() %>" class="btn btn-primary">📝 Quản lý bài thi</a>
                        <a href="<%= request.getContextPath() %>/teacher/grades?courseId=<%= course.getCourseId() %>" class="btn btn-secondary">📊 Xem điểm</a>
                    </div>
                </div>
                
                <!-- Statistics -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <h3><%= students != null ? students.size() : 0 %></h3>
                        <p>👥 Sinh viên đăng ký</p>
                    </div>
                    <div class="stat-card">
                        <h3>0</h3>
                        <p>📝 Bài kiểm tra</p>
                    </div>
                    <div class="stat-card">
                        <h3>0</h3>
                        <p>✅ Bài đã nộp</p>
                    </div>
                </div>
            </div>
            
            <!-- Student List -->
            <div class="card">
                <div class="section-title">
                    <span>👥 Danh sách sinh viên (<%= students != null ? students.size() : 0 %>)</span>
                </div>
                
                <% if (students == null || students.isEmpty()) { %>
                    <div class="empty-state">
                        <h3>📭 Chưa có sinh viên nào</h3>
                        <p>Chưa có sinh viên nào đăng ký lớp học này.</p>
                    </div>
                <% } else { %>
                    <table class="student-table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mã sinh viên</th>
                                <th>Họ và tên</th>
                                <th>Email</th>
                                <th>Chuyên ngành</th>
                                <th>Năm học</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            int index = 1;
                            for (Student student : students) { 
                                // Get user info from student
                                String fullName = student.getUser() != null ? student.getUser().getFullName() : "N/A";
                                String email = student.getUser() != null ? student.getUser().getEmail() : "N/A";
                                boolean isActive = student.getUser() != null ? student.getUser().isActive() : false;
                            %>
                                <tr>
                                    <td><%= index++ %></td>
                                    <td><strong><%= student.getStudentCode() %></strong></td>
                                    <td><%= fullName %></td>
                                    <td><%= email %></td>
                                    <td><%= student.getMajor() != null ? student.getMajor() : "N/A" %></td>
                                    <td><%= student.getYearOfStudy() > 0 ? "Năm " + student.getYearOfStudy() : "N/A" %></td>
                                    <td>
                                        <span class="badge <%= isActive ? "badge-active" : "badge-inactive" %>">
                                            <%= isActive ? "Hoạt động" : "Không hoạt động" %>
                                        </span>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                <% } %>
            </div>
        <% } %>
    </div>
</body>
</html>
