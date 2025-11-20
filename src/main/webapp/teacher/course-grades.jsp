<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách bài thi - ${course.courseName}</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .header {
            background: white;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .header h1 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .actions {
            margin-bottom: 20px;
        }
        
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
            transition: background 0.3s;
        }
        
        .btn:hover {
            background: #5568d3;
        }
        
        .btn-secondary {
            background: #6c757d;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .exams-grid {
            display: grid;
            gap: 20px;
        }
        
        .exam-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .exam-info h3 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .exam-details {
            color: #666;
            font-size: 14px;
        }
        
        .exam-details span {
            margin-right: 15px;
        }
        
        .exam-stats {
            text-align: right;
        }
        
        .stat-number {
            font-size: 32px;
            font-weight: bold;
            color: #667eea;
        }
        
        .stat-label {
            color: #666;
            font-size: 14px;
        }
        
        .no-exams {
            text-align: center;
            padding: 40px;
            background: white;
            border-radius: 10px;
            color: #999;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📚 ${course.courseName}</h1>
            <p style="color: #666; margin-top: 5px;">Danh sách bài thi của môn học</p>
        </div>
        
        <div class="actions">
            <a href="${pageContext.request.contextPath}/teacher/grades" class="btn btn-secondary">
                ← Quay lại danh sách môn học
            </a>
        </div>
        
        <div class="exams-grid">
            <c:choose>
                <c:when test="${not empty exams}">
                    <c:forEach items="${exams}" var="exam">
                        <div class="exam-card">
                            <div class="exam-info">
                                <h3>${exam.examTitle}</h3>
                                <div class="exam-details">
                                    <span>⏱️ ${exam.durationMinutes} phút</span>
                                    <span>📊 Điểm đạt: ${exam.passScore}%</span>
                                    <span>📅 ${exam.startTime}</span>
                                </div>
                            </div>
                            <div class="exam-stats">
                                <div class="stat-number">${exam.submissionCount != null ? exam.submissionCount : 0}</div>
                                <div class="stat-label">bài đã nộp</div>
                                <a href="${pageContext.request.contextPath}/teacher/grades?examId=${exam.examId}" 
                                   class="btn" style="margin-top: 10px; font-size: 14px;">
                                    Xem chi tiết →
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="no-exams">
                        <p>📭 Chưa có bài thi nào cho môn học này</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
