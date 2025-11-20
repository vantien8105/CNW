<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${course.courseName} - Danh sách bài thi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .exam-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .exam-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 15px;
        }
        .exam-title {
            font-size: 1.5em;
            color: #333;
            margin: 0;
        }
        .exam-status {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: bold;
        }
        .status-available {
            background: #28a745;
            color: white;
        }
        .status-upcoming {
            background: #ffc107;
            color: black;
        }
        .status-ended {
            background: #dc3545;
            color: white;
        }
        .status-submitted {
            background: #17a2b8;
            color: white;
        }
        .exam-info {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin: 15px 0;
        }
        .info-item {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .info-item i {
            color: #007bff;
        }
        .btn-take-exam {
            background: #007bff;
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            font-size: 1.1em;
        }
        .btn-take-exam:hover {
            background: #0056b3;
        }
        .btn-take-exam:disabled {
            background: #ccc;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="page-header">
            <h1>📝 ${course.courseName}</h1>
            <p>Mã môn: ${course.courseCode}</p>
            <a href="${pageContext.request.contextPath}/student/exams" class="btn btn-secondary">
                ← Quay lại danh sách môn học
            </a>
        </div>
        
        <c:if test="${empty exams}">
            <div class="alert alert-info">
                <p>Chưa có bài thi nào trong môn học này.</p>
            </div>
        </c:if>
        
        <c:forEach var="exam" items="${exams}">
            <div class="exam-card">
                <div class="exam-header">
                    <h2 class="exam-title">${exam.examTitle}</h2>
                    <span class="exam-status 
                        <c:choose>
                            <c:when test="${exam.submitted}">status-submitted</c:when>
                            <c:when test="${exam.available}">status-available</c:when>
                            <c:when test="${exam.upcoming}">status-upcoming</c:when>
                            <c:otherwise>status-ended</c:otherwise>
                        </c:choose>">
                        <c:choose>
                            <c:when test="${exam.submitted}">Đã nộp bài</c:when>
                            <c:when test="${exam.available}">Đang mở</c:when>
                            <c:when test="${exam.upcoming}">Sắp diễn ra</c:when>
                            <c:otherwise>Đã kết thúc</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                
                <c:if test="${not empty exam.description}">
                    <p>${exam.description}</p>
                </c:if>
                
                <div class="exam-info">
                    <div class="info-item">
                        <i>⏱️</i>
                        <span><strong>Thời gian:</strong> ${exam.durationMinutes} phút</span>
                    </div>
                    <div class="info-item">
                        <i>📋</i>
                        <span><strong>Số câu hỏi:</strong> ${exam.totalQuestions}</span>
                    </div>
                    <div class="info-item">
                        <i>✅</i>
                        <span><strong>Điểm đạt:</strong> ${exam.passScore}%</span>
                    </div>
                    <div class="info-item">
                        <i>🕐</i>
                        <span><strong>Bắt đầu:</strong> ${exam.startTime}</span>
                    </div>
                    <div class="info-item">
                        <i>🕑</i>
                        <span><strong>Kết thúc:</strong> ${exam.endTime}</span>
                    </div>
                </div>
                
                <div style="margin-top: 20px;">
                    <c:choose>
                        <c:when test="${exam.submitted}">
                            <button class="btn-take-exam" disabled>Đã nộp bài</button>
                        </c:when>
                        <c:when test="${exam.available}">
                            <a href="${pageContext.request.contextPath}/student/take-exam?examId=${exam.examId}" 
                               class="btn-take-exam"
                               onclick="return confirm('Bạn có chắc muốn bắt đầu làm bài thi này không?');">
                                🚀 Bắt đầu làm bài
                            </a>
                        </c:when>
                        <c:when test="${exam.upcoming}">
                            <button class="btn-take-exam" disabled>Chưa đến giờ thi</button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn-take-exam" disabled>Đã hết hạn</button>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:forEach>
    </div>
</body>
</html>
