<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Làm bài thi - ${exam.examTitle}</title>
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
        
        .exam-container {
            max-width: 900px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .exam-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 25px;
        }
        
        .exam-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .exam-info {
            display: flex;
            gap: 30px;
            font-size: 14px;
            opacity: 0.95;
        }
        
        .exam-info-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .timer-container {
            background: #f8f9fa;
            border-bottom: 3px solid #667eea;
            padding: 15px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .timer {
            font-size: 28px;
            font-weight: bold;
            color: #667eea;
            font-family: 'Courier New', monospace;
        }
        
        .timer.warning {
            color: #ff6b6b;
            animation: pulse 1s infinite;
        }
        
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.6; }
        }
        
        .timer-label {
            font-size: 14px;
            color: #666;
            margin-bottom: 5px;
        }
        
        .questions-container {
            padding: 25px;
        }
        
        .question-card {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
            border-left: 4px solid #667eea;
        }
        
        .question-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 15px;
        }
        
        .question-number {
            background: #667eea;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-weight: bold;
            font-size: 14px;
        }
        
        .question-points {
            background: #28a745;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 14px;
        }
        
        .question-text {
            font-size: 16px;
            line-height: 1.6;
            color: #333;
            margin-bottom: 15px;
            font-weight: 500;
        }
        
        .options-container {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        
        .option-label {
            display: flex;
            align-items: start;
            padding: 15px;
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .option-label:hover {
            border-color: #667eea;
            background: #f0f4ff;
        }
        
        .option-label input[type="radio"] {
            margin-right: 12px;
            margin-top: 3px;
            width: 18px;
            height: 18px;
            cursor: pointer;
        }
        
        .option-label input[type="radio"]:checked + .option-content {
            color: #667eea;
            font-weight: 500;
        }
        
        .option-label:has(input[type="radio"]:checked) {
            border-color: #667eea;
            background: #f0f4ff;
        }
        
        .option-content {
            flex: 1;
            line-height: 1.5;
        }
        
        .option-key {
            display: inline-block;
            background: #e0e0e0;
            padding: 2px 8px;
            border-radius: 4px;
            margin-right: 10px;
            font-weight: bold;
            font-size: 14px;
        }
        
        .submit-container {
            background: #f8f9fa;
            padding: 25px;
            border-top: 2px solid #e0e0e0;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .progress-info {
            font-size: 14px;
            color: #666;
        }
        
        .progress-info strong {
            color: #667eea;
            font-size: 16px;
        }
        
        .submit-btn {
            background: #28a745;
            color: white;
            border: none;
            padding: 15px 40px;
            font-size: 16px;
            font-weight: bold;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .submit-btn:hover {
            background: #218838;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
        }
        
        .submit-btn:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }
        
        .warning-message {
            background: #fff3cd;
            border: 1px solid #ffc107;
            border-radius: 8px;
            padding: 15px;
            margin: 20px 25px;
            color: #856404;
        }
        
        .warning-message strong {
            display: block;
            margin-bottom: 5px;
        }
        
        .back-btn {
            display: inline-block;
            background: #6c757d;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        
        .back-btn:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="exam-container">
        <!-- Exam Header -->
        <div class="exam-header">
            <div class="exam-title">${exam.examTitle}</div>
            <div class="exam-info">
                <div class="exam-info-item">
                    <span>📚</span>
                    <span>Môn: ${course.courseName}</span>
                </div>
                <div class="exam-info-item">
                    <span>📝</span>
                    <span>${questions.size()} câu hỏi</span>
                </div>
                <div class="exam-info-item">
                    <span>⏱️</span>
                    <span>${exam.durationMinutes} phút</span>
                </div>
                <div class="exam-info-item">
                    <span>🎯</span>
                    <span>Điểm đạt: ${exam.passScore}%</span>
                </div>
            </div>
        </div>
        
        <!-- Timer -->
        <div class="timer-container">
            <div>
                <div class="timer-label">Thời gian còn lại:</div>
                <div class="timer" id="timer">--:--:--</div>
            </div>
            <a href="${pageContext.request.contextPath}/student/exams?action=viewExams&courseId=${course.courseId}" class="back-btn">← Quay lại</a>
        </div>
        
        <!-- Warning Message -->
        <div class="warning-message">
            <strong>⚠️ Lưu ý quan trọng:</strong>
            <ul style="margin-left: 20px; margin-top: 5px;">
                <li>Bài thi sẽ tự động nộp khi hết thời gian</li>
                <li>Không tải lại trang hoặc thoát ra trong khi làm bài</li>
                <li>Đảm bảo kết nối internet ổn định trước khi nộp bài</li>
            </ul>
        </div>
        
        <!-- Exam Form -->
        <form id="examForm" method="post" action="${pageContext.request.contextPath}/student/submit-exam">
            <input type="hidden" name="examId" value="${exam.examId}">
            <input type="hidden" name="courseId" value="${course.courseId}">
            
            <div class="questions-container">
                <c:forEach var="question" items="${questions}" varStatus="status">
                    <div class="question-card">
                        <div class="question-header">
                            <span class="question-number">Câu ${question.questionNumber}</span>
                            <span class="question-points">${question.points} điểm</span>
                        </div>
                        
                        <div class="question-text">
                            ${question.questionText}
                        </div>
                        
                        <div class="options-container">
                            <c:forEach var="option" items="${question.options}">
                                <label class="option-label">
                                    <input type="radio" 
                                           name="question_${question.questionId}" 
                                           value="${option.optionKey}"
                                           required>
                                    <div class="option-content">
                                        <span class="option-key">${option.optionKey}</span>
                                        ${option.optionText}
                                    </div>
                                </label>
                            </c:forEach>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
            <!-- Submit Container -->
            <div class="submit-container">
                <div class="progress-info">
                    Đã trả lời: <strong><span id="answeredCount">0</span>/${questions.size()}</strong> câu
                </div>
                <button type="submit" class="submit-btn" id="submitBtn">
                    Nộp bài thi
                </button>
            </div>
        </form>
    </div>
    
    <script>
        // Timer countdown
        const durationMinutes = ${exam.durationMinutes};
        const examStartTime = ${examStartTime};
        const endTime = examStartTime + (durationMinutes * 60 * 1000);
        
        function updateTimer() {
            const now = Date.now();
            const remaining = endTime - now;
            
            if (remaining <= 0) {
                document.getElementById('timer').textContent = '00:00:00';
                document.getElementById('timer').classList.add('warning');
                alert('Hết thời gian! Bài thi sẽ được tự động nộp.');
                document.getElementById('examForm').submit();
                return;
            }
            
            const hours = Math.floor(remaining / (1000 * 60 * 60));
            const minutes = Math.floor((remaining % (1000 * 60 * 60)) / (1000 * 60));
            const seconds = Math.floor((remaining % (1000 * 60)) / 1000);
            
            const timeString = 
                String(hours).padStart(2, '0') + ':' +
                String(minutes).padStart(2, '0') + ':' +
                String(seconds).padStart(2, '0');
            
            document.getElementById('timer').textContent = timeString;
            
            // Warning when less than 5 minutes
            if (remaining < 5 * 60 * 1000) {
                document.getElementById('timer').classList.add('warning');
            }
            
            setTimeout(updateTimer, 1000);
        }
        
        updateTimer();
        
        // Track answered questions
        const form = document.getElementById('examForm');
        const totalQuestions = ${questions.size()};
        
        function updateAnsweredCount() {
            const answered = new Set();
            const radios = form.querySelectorAll('input[type="radio"]:checked');
            radios.forEach(radio => {
                answered.add(radio.name);
            });
            document.getElementById('answeredCount').textContent = answered.size;
        }
        
        form.addEventListener('change', updateAnsweredCount);
        
        // Confirm before submit
        form.addEventListener('submit', function(e) {
            const answeredCount = document.querySelectorAll('input[type="radio"]:checked').length;
            
            if (answeredCount < totalQuestions) {
                const unanswered = totalQuestions - answeredCount;
                if (!confirm(`Bạn còn ${unanswered} câu chưa trả lời. Bạn có chắc muốn nộp bài không?`)) {
                    e.preventDefault();
                    return false;
                }
            } else {
                if (!confirm('Bạn có chắc chắn muốn nộp bài thi không? Bạn sẽ không thể sửa đổi sau khi nộp.')) {
                    e.preventDefault();
                    return false;
                }
            }
            
            // Disable submit button to prevent double submission
            document.getElementById('submitBtn').disabled = true;
            document.getElementById('submitBtn').textContent = 'Đang nộp bài...';
        });
        
        // Prevent accidental page close
        window.addEventListener('beforeunload', function(e) {
            e.preventDefault();
            e.returnValue = '';
            return '';
        });
        
        // Auto-save to localStorage (optional recovery)
        setInterval(function() {
            const answers = {};
            const radios = form.querySelectorAll('input[type="radio"]:checked');
            radios.forEach(radio => {
                answers[radio.name] = radio.value;
            });
            localStorage.setItem('exam_${exam.examId}_answers', JSON.stringify(answers));
        }, 30000); // Save every 30 seconds
        
        // Restore from localStorage on page load
        window.addEventListener('load', function() {
            const saved = localStorage.getItem('exam_${exam.examId}_answers');
            if (saved) {
                try {
                    const answers = JSON.parse(saved);
                    Object.keys(answers).forEach(name => {
                        const radio = form.querySelector(`input[name="${name}"][value="${answers[name]}"]`);
                        if (radio) {
                            radio.checked = true;
                        }
                    });
                    updateAnsweredCount();
                } catch (e) {
                    console.error('Error restoring answers:', e);
                }
            }
        });
        
        // Clear localStorage after successful submit
        form.addEventListener('submit', function() {
            setTimeout(function() {
                localStorage.removeItem('exam_${exam.examId}_answers');
            }, 1000);
        });
    </script>
</body>
</html>
