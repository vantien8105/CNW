<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết bài thi - Hệ thống thi trực tuyến</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/teacher-style.css">
    <style>
        .detail-container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .student-info {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .info-item {
            display: flex;
            flex-direction: column;
        }
        
        .info-label {
            font-size: 12px;
            color: #666;
            text-transform: uppercase;
            margin-bottom: 5px;
        }
        
        .info-value {
            font-size: 18px;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .score-display {
            text-align: center;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 10px;
            color: white;
        }
        
        .score-value {
            font-size: 48px;
            font-weight: bold;
            margin: 10px 0;
        }
        
        .score-label {
            font-size: 14px;
            opacity: 0.9;
        }
        
        .statistics-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin-top: 20px;
        }
        
        .stat-card {
            text-align: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .stat-value {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 12px;
            color: #666;
        }
        
        .stat-correct .stat-value {
            color: #27ae60;
        }
        
        .stat-incorrect .stat-value {
            color: #e74c3c;
        }
        
        .stat-total .stat-value {
            color: #3498db;
        }
        
        .section-title {
            font-size: 20px;
            font-weight: bold;
            color: #2c3e50;
            margin: 30px 0 20px 0;
            padding-bottom: 10px;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .question-detail-card {
            background: white;
            padding: 25px;
            margin-bottom: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border-left: 4px solid #e0e0e0;
        }
        
        .question-detail-card.correct {
            border-left-color: #27ae60;
            background: #f8fff8;
        }
        
        .question-detail-card.incorrect {
            border-left-color: #e74c3c;
            background: #fff8f8;
        }
        
        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .question-number-badge {
            background: #667eea;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 14px;
        }
        
        .result-badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 14px;
        }
        
        .result-badge.correct {
            background: #27ae60;
            color: white;
        }
        
        .result-badge.incorrect {
            background: #e74c3c;
            color: white;
        }
        
        .question-text {
            font-size: 16px;
            color: #2c3e50;
            margin-bottom: 20px;
            line-height: 1.6;
        }
        
        .answer-comparison {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        
        .answer-box {
            padding: 15px;
            border-radius: 8px;
            border: 2px solid;
        }
        
        .answer-box.student-answer {
            border-color: #3498db;
            background: #e3f2fd;
        }
        
        .answer-box.student-wrong {
            border-color: #e74c3c;
            background: #ffebee;
        }
        
        .answer-box.correct-answer {
            border-color: #27ae60;
            background: #e8f5e9;
        }
        
        .answer-label {
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
            margin-bottom: 8px;
            color: #666;
        }
        
        .answer-content {
            font-size: 15px;
            color: #2c3e50;
        }
        
        .option-key {
            display: inline-block;
            width: 28px;
            height: 28px;
            line-height: 28px;
            text-align: center;
            background: #667eea;
            color: white;
            border-radius: 50%;
            font-weight: bold;
            margin-right: 8px;
            font-size: 14px;
        }
        
        .actions-section {
            margin-top: 30px;
            text-align: center;
            padding: 20px;
        }
        
        .btn {
            display: inline-block;
            padding: 12px 30px;
            margin: 5px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
            transition: all 0.3s;
        }
        
        .btn-primary {
            background: #667eea;
            color: white;
        }
        
        .btn-primary:hover {
            background: #5568d3;
            transform: translateY(-2px);
        }
        
        .btn-secondary {
            background: #95a5a6;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #7f8c8d;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <%@ include file="/common/teacher-header.jsp" %>
    
    <div class="detail-container">
        <h1>📝 Chi tiết bài thi</h1>
        
        <!-- Header Section -->
        <div class="header-section">
            <div class="student-info">
                <div class="info-item">
                    <span class="info-label">Sinh viên</span>
                    <span class="info-value">${submission.studentName}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Mã sinh viên</span>
                    <span class="info-value">${submission.studentCode}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Bài thi</span>
                    <span class="info-value">${exam.examTitle}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Thời gian nộp</span>
                    <span class="info-value">
                        <fmt:formatDate value="${submission.submittedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                    </span>
                </div>
            </div>
            
            <div class="score-display">
                <div class="score-label">Điểm số</div>
                <div class="score-value">
                    <fmt:formatNumber value="${submission.score}" pattern="0.0"/>
                    <span style="font-size: 24px;">/10.0</span>
                </div>
                <div class="score-label">
                    <c:choose>
                        <c:when test="${submission.passed}">✓ ĐẠT</c:when>
                        <c:otherwise>✗ KHÔNG ĐẠT</c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <div class="statistics-grid">
                <div class="stat-card stat-correct">
                    <div class="stat-value">${correctCount}</div>
                    <div class="stat-label">Câu đúng</div>
                </div>
                <div class="stat-card stat-incorrect">
                    <div class="stat-value">${incorrectCount}</div>
                    <div class="stat-label">Câu sai</div>
                </div>
                <div class="stat-card stat-total">
                    <div class="stat-value">${correctCount + incorrectCount}</div>
                    <div class="stat-label">Tổng số câu</div>
                </div>
            </div>
        </div>
        
        <!-- Section Title -->
        <div class="section-title">
            📋 Chi tiết từng câu hỏi
        </div>
        
        <!-- Questions Review -->
        <c:forEach var="question" items="${questions}" varStatus="status">
            <c:set var="answer" value="${answersMap[question.questionId]}"/>
            <c:set var="isCorrect" value="${answer.isCorrect}"/>
            
            <div class="question-detail-card ${isCorrect ? 'correct' : 'incorrect'}">
                <div class="question-header">
                    <span class="question-number-badge">Câu ${question.questionNumber}</span>
                    <div style="display: flex; gap: 10px; align-items: center;">
                        <span style="color: #666; font-size: 14px;">${question.points} điểm</span>
                        <span class="result-badge ${isCorrect ? 'correct' : 'incorrect'}">
                            <c:choose>
                                <c:when test="${isCorrect}">✓ Đúng</c:when>
                                <c:otherwise>✗ Sai</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
                
                <div class="question-text">
                    ${question.questionText}
                </div>
                
                <div class="answer-comparison">
                    <!-- Student Answer -->
                    <div class="answer-box ${isCorrect ? 'student-answer' : 'student-wrong'}">
                        <div class="answer-label">
                            <c:choose>
                                <c:when test="${isCorrect}">✓ Sinh viên đã chọn:</c:when>
                                <c:otherwise>✗ Sinh viên đã chọn:</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="answer-content">
                            <c:choose>
                                <c:when test="${not empty answer.studentAnswer}">
                                    <c:forEach var="option" items="${question.options}">
                                        <c:if test="${option.optionKey == answer.studentAnswer}">
                                            <span class="option-key">${option.optionKey}</span>
                                            ${option.optionText}
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <em style="color: #999;">Không có câu trả lời</em>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    
                    <!-- Correct Answer -->
                    <div class="answer-box correct-answer">
                        <div class="answer-label">✓ Đáp án đúng:</div>
                        <div class="answer-content">
                            <c:forEach var="option" items="${question.options}">
                                <c:if test="${option.correct}">
                                    <span class="option-key">${option.optionKey}</span>
                                    ${option.optionText}
                                </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>
        
        <!-- Actions -->
        <div class="actions-section">
            <a href="${pageContext.request.contextPath}/teacher/grades?examId=${exam.examId}" class="btn btn-primary">
                ← Quay lại danh sách bài thi
            </a>
            <a href="${pageContext.request.contextPath}/teacher/grades" class="btn btn-secondary">
                📊 Xem tất cả điểm
            </a>
        </div>
    </div>
</body>
</html>
