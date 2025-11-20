package com.onlineexam.servlet;

import com.onlineexam.dao.*;
import com.onlineexam.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/student/take-exam")
public class TakeExamServlet extends HttpServlet {
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Student student = (Student) session.getAttribute("student");
        
        if (user == null || student == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
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
            
            // Check if exam is available
            LocalDateTime now = LocalDateTime.now();
            if (now.isBefore(exam.getStartTime())) {
                response.sendRedirect(request.getContextPath() + "/student/exams?error=not_started");
                return;
            }
            
            if (now.isAfter(exam.getEndTime())) {
                response.sendRedirect(request.getContextPath() + "/student/exams?error=ended");
                return;
            }
            
            // Check if already submitted
            ExamSubmission existingSubmission = submissionDAO.getSubmissionByExamAndStudent(
                exam.getExamId(), student.getStudentId());
            
            if (existingSubmission != null) {
                response.sendRedirect(request.getContextPath() + "/student/exams?error=already_submitted");
                return;
            }
            
            // Get questions
            List<ExamQuestion> questions = questionDAO.getQuestionsByExam(examId);
            
            // Store exam start time in session
            session.setAttribute("examStartTime", System.currentTimeMillis());
            session.setAttribute("examId", examId);
            
            request.setAttribute("exam", exam);
            request.setAttribute("questions", questions);
            request.getRequestDispatcher("/student/take-exam.jsp").forward(request, response);
            
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}
