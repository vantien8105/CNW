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
    <title>Tạo bài kiểm tra</title>
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
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            border: none;
            cursor: pointer;
            font-size: 14px;
        }
        
        .btn-back {
            background: rgba(255,255,255,0.2);
            color: white;
            border: 1px solid rgba(255,255,255,0.3);
        }
        
        .btn-primary {
            background: #667eea;
            color: white;
        }
        
        .container {
            max-width: 800px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #333;
            font-weight: 500;
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .alert {
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        
        .alert-info {
            background: #e3f2fd;
            color: #1976d2;
            border: 1px solid #1976d2;
        }
    </style>
    <script>
        // Template data
        const templates = {
            'exam_database_midterm.json': {
                title: 'Kiểm tra Cơ sở dữ liệu - Giữa kỳ',
                description: 'Bài kiểm tra giữa kỳ môn Cơ sở dữ liệu',
                duration: 90,
                passingScore: 50
            },
            'exam_java_final.json': {
                title: 'Kiểm tra Lập trình Java - Cuối kỳ',
                description: 'Bài kiểm tra cuối kỳ môn Lập trình Java',
                duration: 120,
                passingScore: 50
            },
            'exam_web_midterm.json': {
                title: 'Kiểm tra Công nghệ Web - Giữa kỳ',
                description: 'Bài kiểm tra giữa kỳ môn Công nghệ Web',
                duration: 60,
                passingScore: 50
            }
        };
        
        function updateExamInfo() {
            const templateSelect = document.getElementById('examTemplate');
            const selectedTemplate = templateSelect.value;
            
            if (selectedTemplate && templates[selectedTemplate]) {
                const data = templates[selectedTemplate];
                document.getElementById('title').value = data.title;
                document.getElementById('description').value = data.description;
                document.getElementById('duration').value = data.duration;
                document.getElementById('passingScore').value = data.passingScore;
            }
        }
    </script>
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>📝 Tạo bài kiểm tra mới</h1>
            <div>
                <a href="<%= request.getContextPath() %>/teacher/dashboard" class="btn btn-back">← Quay lại Dashboard</a>
            </div>
        </div>
    </div>
    
    <div class="container">
        <div class="card">
            <% if (courses == null || courses.isEmpty()) { %>
                <div class="alert alert-info">
                    ⚠️ Bạn chưa có lớp học phần nào. Vui lòng liên hệ quản trị viên để được thêm lớp học trước khi tạo bài kiểm tra.
                </div>
            <% } else { %>
                <form action="<%= request.getContextPath() %>/teacher/exams" method="post">
                    <input type="hidden" name="action" value="create">
                    
                    <div class="form-group">
                        <label for="courseId">Lớp học phần *</label>
                        <select name="courseId" id="courseId" required>
                            <option value="">-- Chọn lớp học --</option>
                            <% for (Course course : courses) { %>
                                <option value="<%= course.getCourseId() %>">
                                    <%= course.getCourseCode() %> - <%= course.getCourseName() %> 
                                    (<%= course.getSemester() %> - <%= course.getYear() %>)
                                </option>
                            <% } %>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="examTemplate">Chọn đề thi có sẵn *</label>
                        <select name="examTemplate" id="examTemplate" required onchange="updateExamInfo()">
                            <option value="">-- Chọn đề thi --</option>
                            <option value="exam_database_midterm.json">Cơ sở dữ liệu - Giữa kỳ (10 câu, 90 phút)</option>
                            <option value="exam_java_final.json">Lập trình Java - Cuối kỳ (10 câu, 120 phút)</option>
                            <option value="exam_web_midterm.json">Công nghệ Web - Giữa kỳ (5 câu, 60 phút)</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label for="title">Tên bài kiểm tra *</label>
                        <input type="text" name="title" id="title" required placeholder="Ví dụ: Kiểm tra giữa kỳ">
                    </div>
                    
                    <div class="form-group">
                        <label for="description">Mô tả</label>
                        <textarea name="description" id="description" placeholder="Mô tả ngắn về bài kiểm tra..."></textarea>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="startTime">Thời gian bắt đầu *</label>
                            <input type="datetime-local" name="startTime" id="startTime" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="endTime">Thời gian kết thúc *</label>
                            <input type="datetime-local" name="endTime" id="endTime" required>
                        </div>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="duration">Thời lượng làm bài (phút) *</label>
                            <input type="number" name="duration" id="duration" min="1" required placeholder="60">
                        </div>
                        
                        <div class="form-group">
                            <label for="passingScore">Điểm đạt (%) *</label>
                            <input type="number" name="passingScore" id="passingScore" min="0" max="100" step="0.1" required placeholder="50">
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">✓ Tạo bài kiểm tra</button>
                    </div>
                </form>
            <% } %>
        </div>
    </div>
</body>
</html>
