<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bài thi của tôi - Online Exam</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .course-card {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: transform 0.2s;
        }
        .course-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.15);
        }
        .course-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        .course-title {
            font-size: 1.5em;
            color: #333;
            margin: 0;
        }
        .course-code {
            background: #007bff;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
        }
        .course-info {
            color: #666;
            margin-bottom: 10px;
        }
        .btn-view-exams {
            background: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        .btn-view-exams:hover {
            background: #218838;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="page-header">
            <h1>📚 Môn học của tôi</h1>
            <p>Chọn môn học để xem danh sách bài thi</p>
        </div>
        
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger">
                <c:choose>
                    <c:when test="${param.error == 'not_found'}">Không tìm thấy bài thi!</c:when>
                    <c:when test="${param.error == 'not_started'}">Bài thi chưa bắt đầu!</c:when>
                    <c:when test="${param.error == 'ended'}">Bài thi đã kết thúc!</c:when>
                    <c:when test="${param.error == 'already_submitted'}">Bạn đã nộp bài thi này rồi!</c:when>
                    <c:otherwise>Có lỗi xảy ra!</c:otherwise>
                </c:choose>
            </div>
        </c:if>
        
        <c:if test="${empty courses}">
            <div class="alert alert-info">
                <p>Bạn chưa đăng ký môn học nào.</p>
            </div>
        </c:if>
        
        <c:forEach var="course" items="${courses}">
            <div class="course-card">
                <div class="course-header">
                    <h2 class="course-title">${course.courseName}</h2>
                    <span class="course-code">${course.courseCode}</span>
                </div>
                <div class="course-info">
                    <p><strong>Giảng viên:</strong> ${course.teacher.user.fullName}</p>
                    <p><strong>Mô tả:</strong> ${course.description}</p>
                </div>
                <a href="${pageContext.request.contextPath}/student/exams?courseId=${course.courseId}" 
                   class="btn-view-exams">
                    Xem bài thi
                </a>
            </div>
        </c:forEach>
    </div>
</body>
</html>
