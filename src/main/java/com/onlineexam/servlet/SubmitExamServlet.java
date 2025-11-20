package com.onlineexam.servlet;

import com.onlineexam.dao.*;
import com.onlineexam.model.*;
import org.json.JSONArray;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/student/submit-exam")
public class SubmitExamServlet extends HttpServlet {
    private ExamDAO examDAO;
    private ExamQuestionDAO questionDAO;
    private ExamSubmissionDAO submissionDAO;
    
    @Override
    public void init() throws ServletException {
        examDAO = new ExamDAO();
        questionDAO = new ExamQuestionDAO();
        submissionDAO = new ExamSubmissionDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Student student = (Student) session.getAttribute("student");
        
        if (user == null || student == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        
        String examIdStr = request.getParameter("examId");
        if (examIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/student/exams");
            return;
        }
        
        try {
            int examId = Integer.parseInt(examIdStr);
            Exam exam = examDAO.getExamById(examId);
            
            if (exam == null) {
                response.sendRedirect(request.getContextPath() + "/student/exams?error=not_found");
                return;
            }
            
            // Check if already submitted
            ExamSubmission existingSubmission = submissionDAO.getSubmissionByExamAndStudent(
                examId, student.getStudentId());
            
            if (existingSubmission != null) {
                response.sendRedirect(request.getContextPath() + "/student/exams?error=already_submitted");
                return;
            }
            
            // Get all questions
            List<ExamQuestion> questions = questionDAO.getQuestionsByExam(examId);
            
            // Calculate score
            double totalScore = 0;
            double maxScore = 0;
            JSONArray answersJson = new JSONArray();
            
            for (ExamQuestion question : questions) {
                maxScore += question.getPoints();
                
                String answer = request.getParameter("question_" + question.getQuestionId());
                if (answer == null) {
                    answer = "";
                }
                
                JSONObject answerObj = new JSONObject();
                answerObj.put("questionId", question.getQuestionId());
                answerObj.put("answer", answer);
                answerObj.put("correctAnswer", question.getCorrectAnswer());
                answerObj.put("isCorrect", answer.equals(question.getCorrectAnswer()));
                
                if (answer.equals(question.getCorrectAnswer())) {
                    totalScore += question.getPoints();
                    answerObj.put("points", question.getPoints());
                } else {
                    answerObj.put("points", 0);
                }
                
                answersJson.put(answerObj);
            }
            
            // Calculate percentage
            double scorePercentage = maxScore > 0 ? (totalScore / maxScore) * 100 : 0;
            
            // Create submission
            ExamSubmission submission = new ExamSubmission();
            submission.setExamId(examId);
            submission.setStudentId(student.getStudentId());
            submission.setAnswersJson(answersJson.toString());
            submission.setScore(scorePercentage);
            submission.setSubmittedAt(new Timestamp(System.currentTimeMillis()));
            
            // Determine status
            submission.setPassed(scorePercentage >= exam.getPassScore());
            
            submissionDAO.createSubmission(submission);
            
            // Clear session
            session.removeAttribute("examStartTime");
            session.removeAttribute("examId");
            
            // Get the submission ID to redirect
            ExamSubmission savedSubmission = submissionDAO.getSubmissionByExamAndStudent(examId, student.getStudentId());
            
            // Redirect to result page
            response.sendRedirect(request.getContextPath() + "/student/exam-result?submissionId=" + 
                savedSubmission.getSubmissionId());
            
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}
