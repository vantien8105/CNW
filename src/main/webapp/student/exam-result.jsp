<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả bài thi - ${exam.examTitle}</title>
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
        
        .result-container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .result-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
            text-align: center;
        }
        
        .result-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .exam-name {
            font-size: 16px;
            opacity: 0.9;
        }
        
        .score-section {
            padding: 30px;
            text-align: center;
            background: #f8f9fa;
            border-bottom: 3px solid #e0e0e0;
        }
        
        .score-circle {
            width: 180px;
            height: 180px;
            border-radius: 50%;
            margin: 0 auto 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-size: 48px;
            font-weight: bold;
            border: 8px solid;
            position: relative;
        }
        
        .score-circle.passed {
            background: linear-gradient(135deg, #28a745, #20c997);
            border-color: #28a745;
            color: white;
        }
        
        .score-circle.failed {
            background: linear-gradient(135deg, #dc3545, #fd7e14);
            border-color: #dc3545;
            color: white;
        }
        
        .score-label {
            font-size: 16px;
            margin-top: 5px;
        }
        
        .result-status {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 15px;
        }
        
        .result-status.passed {
            color: #28a745;
        }
        
        .result-status.failed {
            color: #dc3545;
        }
        
        .result-stats {
            display: flex;
            justify-content: center;
            gap: 40px;
            margin-top: 20px;
            flex-wrap: wrap;
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-value {
            font-size: 28px;
            font-weight: bold;
            color: #667eea;
        }
        
        .stat-label {
            font-size: 14px;
            color: #666;
            margin-top: 5px;
        }
        
        .exam-info-box {
            background: #e7f3ff;
            border-left: 4px solid #667eea;
            padding: 15px 20px;
            margin: 20px;
            border-radius: 5px;
        }
        
        .exam-info-box h3 {
            color: #667eea;
            margin-bottom: 10px;
            font-size: 16px;
        }
        
        .exam-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 10px;
            font-size: 14px;
        }
        
        .exam-info-item {
            display: flex;
            justify-content: space-between;
        }
        
        .exam-info-item .label {
            color: #666;
        }
        
        .exam-info-item .value {
            font-weight: bold;
            color: #333;
        }
        
        .section-title {
            background: #667eea;
            color: white;
            padding: 15px 25px;
            font-size: 18px;
            font-weight: bold;
        }
        
        .questions-review {
            padding: 25px;
        }
        
        .question-review-card {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            border-left: 4px solid #667eea;
        }
        
        .question-review-card.correct {
            border-left-color: #28a745;
            background: #f1f9f3;
        }
        
        .question-review-card.incorrect {
            border-left-color: #dc3545;
            background: #fff5f5;
        }
        
        .question-review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        
        .question-review-number {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .question-number-badge {
            background: #667eea;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 14px;
        }
        
        .result-badge {
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .result-badge.correct {
            background: #28a745;
            color: white;
        }
        
        .result-badge.incorrect {
            background: #dc3545;
            color: white;
        }
        
        .question-review-text {
            font-size: 16px;
            line-height: 1.6;
            color: #333;
            margin-bottom: 15px;
            font-weight: 500;
        }
        
        .answer-section {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        
        .answer-item {
            display: flex;
            align-items: start;
            padding: 12px;
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 6px;
            font-size: 14px;
        }
        
        .answer-item.student-answer {
            border-color: #667eea;
            background: #f0f4ff;
        }
        
        .answer-item.correct-answer {
            border-color: #28a745;
            background: #f1f9f3;
        }
        
        .answer-item.student-wrong {
            border-color: #dc3545;
            background: #fff5f5;
        }
        
        .answer-label {
            font-weight: bold;
            margin-right: 10px;
            min-width: 120px;
            color: #666;
        }
        
        .answer-content {
            flex: 1;
            color: #333;
        }
        
        .option-key {
            display: inline-block;
            background: #e0e0e0;
            padding: 2px 8px;
            border-radius: 4px;
            margin-right: 8px;
            font-weight: bold;
            font-size: 13px;
        }
        
        .actions-section {
            background: #f8f9fa;
            padding: 25px;
            border-top: 2px solid #e0e0e0;
            display: flex;
            justify-content: center;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
        }
        
        .btn-primary {
            background: #667eea;
            color: white;
        }
        
        .btn-primary:hover {
            background: #5568d3;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.3);
        }
        
        .summary-box {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            padding: 15px;
            margin: 20px;
        }
        
        .summary-title {
            font-size: 16px;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 10px;
        }
        
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
        }
        
        .summary-item {
            text-align: center;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 6px;
        }
        
        .summary-item .number {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .summary-item.correct .number {
            color: #28a745;
        }
        
        .summary-item.incorrect .number {
            color: #dc3545;
        }
        
        .summary-item.total .number {
            color: #667eea;
        }
        
        .summary-item .label {
            font-size: 13px;
            color: #666;
        }
    </style>
</head>
<body>
    <div class="result-container">
        <!-- Result Header -->
        <div class="result-header">
            <div class="result-title">KẾT QUẢ BÀI THI</div>
            <div class="exam-name">${exam.examTitle}</div>
        </div>
        
        <!-- Score Section -->
        <div class="score-section">
            <div class="score-circle ${submission.isPassed() ? 'passed' : 'failed'}">
                <div>
                    <fmt:formatNumber value="${submission.score}" maxFractionDigits="1"/>%
                    <div class="score-label">Điểm</div>
                </div>
            </div>
            
            <div class="result-status ${submission.isPassed() ? 'passed' : 'failed'}">
                <c:choose>
                    <c:when test="${submission.isPassed()}">
                        ✓ ĐẠT
                    </c:when>
                    <c:otherwise>
                        ✗ KHÔNG ĐẠT
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="result-stats">
                <div class="stat-item">
                    <div class="stat-value">${correctCount}</div>
                    <div class="stat-label">Câu đúng</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">${incorrectCount}</div>
                    <div class="stat-label">Câu sai</div>
                </div>
                <div class="stat-item">
                    <div class="stat-value">${questions.size()}</div>
                    <div class="stat-label">Tổng câu</div>
                </div>
            </div>
        </div>
        
        <!-- Exam Info -->
        <div class="exam-info-box">
            <h3>📋 Thông tin bài thi</h3>
            <div class="exam-info-grid">
                <div class="exam-info-item">
                    <span class="label">Thời gian nộp:</span>
                    <span class="value">
                        <fmt:formatDate value="${submission.submittedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                    </span>
                </div>
                <div class="exam-info-item">
                    <span class="label">Điểm đạt:</span>
                    <span class="value">${exam.passScore}%</span>
                </div>
                <div class="exam-info-item">
                    <span class="label">Thời gian làm bài:</span>
                    <span class="value">${exam.durationMinutes} phút</span>
                </div>
            </div>
        </div>
        
        <!-- Summary Box -->
        <div class="summary-box">
            <div class="summary-title">Tổng quan kết quả</div>
            <div class="summary-grid">
                <div class="summary-item correct">
                    <div class="number">${correctCount}</div>
                    <div class="label">Câu trả lời đúng</div>
                </div>
                <div class="summary-item incorrect">
                    <div class="number">${incorrectCount}</div>
                    <div class="label">Câu trả lời sai</div>
                </div>
                <div class="summary-item total">
                    <div class="number">${questions.size()}</div>
                    <div class="label">Tổng số câu hỏi</div>
                </div>
            </div>
        </div>
        
        
        <!-- Actions -->
        <div class="actions-section">
            <a href="${pageContext.request.contextPath}/student/dashboard.jsp" class="btn btn-primary">
                ← Quay lại Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/student/exams" class="btn btn-secondary">
                📚 Xem các môn học khác
            </a>
        </div>
    </div>
</body>
</html>

