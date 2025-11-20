<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Điểm thi - ${exam.examTitle}</title>
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
        
        .header .exam-info {
            color: #666;
            font-size: 14px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .stat-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .stat-card .stat-value {
            font-size: 32px;
            font-weight: bold;
            color: #667eea;
            margin-bottom: 5px;
        }
        
        .stat-card .stat-label {
            color: #666;
            font-size: 14px;
        }
        
        .grades-table {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th {
            background: #f8f9fa;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            color: #333;
            border-bottom: 2px solid #dee2e6;
        }
        
        td {
            padding: 12px;
            border-bottom: 1px solid #dee2e6;
        }
        
        tr:hover {
            background: #f8f9fa;
        }
        
        .score-badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 14px;
        }
        
        .score-passed {
            background: #d4edda;
            color: #155724;
        }
        
        .score-failed {
            background: #f8d7da;
            color: #721c24;
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
        
        .actions {
            margin-bottom: 20px;
        }
        
        .btn-detail {
            display: inline-block;
            padding: 5px 15px;
            background: #667eea;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 13px;
            font-weight: 500;
            transition: background 0.3s;
        }
        
        .btn-detail:hover {
            background: #5568d3;
        }
        
        .no-submissions {
            text-align: center;
            padding: 40px;
            color: #999;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>📊 Điểm thi: ${exam.examTitle}</h1>
            <div class="exam-info">
                <strong>Môn học:</strong> ${course.courseName} | 
                <strong>Thời gian:</strong> ${exam.durationMinutes} phút | 
                <strong>Điểm đạt:</strong> ${exam.passScore}%
            </div>
        </div>
        
        <c:if test="${not empty submissions}">
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-value">${submissions.size()}</div>
                    <div class="stat-label">Tổng bài nộp</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">
                        <c:set var="passedCount" value="0"/>
                        <c:forEach items="${submissions}" var="sub">
                            <c:if test="${sub.passed}">
                                <c:set var="passedCount" value="${passedCount + 1}"/>
                            </c:if>
                        </c:forEach>
                        ${passedCount}
                    </div>
                    <div class="stat-label">Đạt yêu cầu</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${submissions.size() - passedCount}</div>
                    <div class="stat-label">Chưa đạt</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">
                        <c:set var="totalScore" value="0"/>
                        <c:forEach items="${submissions}" var="sub">
                            <c:set var="totalScore" value="${totalScore + sub.score}"/>
                        </c:forEach>
                        <fmt:formatNumber value="${totalScore / submissions.size()}" maxFractionDigits="1"/>%
                    </div>
                    <div class="stat-label">Điểm trung bình</div>
                </div>
            </div>
        </c:if>
        
        <div class="actions">
            <a href="${pageContext.request.contextPath}/teacher/grades?courseId=${exam.courseId}" class="btn btn-secondary">
                ← Quay lại danh sách bài thi
            </a>
        </div>
        
        <div class="grades-table">
            <h2 style="margin-bottom: 20px;">Danh sách điểm</h2>
            
            <c:choose>
                <c:when test="${not empty submissions}">
                    <table>
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Mã sinh viên</th>
                                <th>Họ tên</th>
                                <th>Điểm</th>
                                <th>Trạng thái</th>
                                <th>Thời gian nộp</th>
                                <th>Thao tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${submissions}" var="submission" varStatus="status">
                                <tr>
                                    <td>${status.index + 1}</td>
                                    <td>${submission.studentCode}</td>
                                    <td>${submission.studentName}</td>
                                    <td><strong><fmt:formatNumber value="${submission.score}" maxFractionDigits="1"/>%</strong></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${submission.passed}">
                                                <span class="score-badge score-passed">✓ Đạt</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="score-badge score-failed">✗ Không đạt</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <fmt:formatDate value="${submission.submittedAt}" 
                                                       pattern="dd/MM/yyyy HH:mm"/>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/teacher/grades?submissionId=${submission.submissionId}" 
                                           class="btn-detail">
                                            🔍 Xem chi tiết
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div class="no-submissions">
                        <p>📭 Chưa có sinh viên nào nộp bài</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
