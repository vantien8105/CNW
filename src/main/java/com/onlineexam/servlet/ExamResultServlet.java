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
import java.util.ArrayList;
import java.util.List;

@WebServlet("/student/exam-result")
public class ExamResultServlet extends HttpServlet {
    private ExamSubmissionDAO submissionDAO;
    private ExamDAO examDAO;
    private ExamQuestionDAO questionDAO;
    
    @Override
    public void init() throws ServletException {
        submissionDAO = new ExamSubmissionDAO();
        examDAO = new ExamDAO();
        questionDAO = new ExamQuestionDAO();
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
        
        String submissionIdStr = request.getParameter("submissionId");
        if (submissionIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/student/exams");
            return;
        }
        
        try {
            int submissionId = Integer.parseInt(submissionIdStr);
            ExamSubmission submission = submissionDAO.getSubmissionById(submissionId);
            
            if (submission == null || submission.getStudentId() != student.getStudentId()) {
                response.sendRedirect(request.getContextPath() + "/student/exams?error=not_found");
                return;
            }
            
            Exam exam = examDAO.getExamById(submission.getExamId());
            List<ExamQuestion> questions = questionDAO.getQuestionsByExam(submission.getExamId());
            
            // Parse answers JSON
            JSONArray answersJson = new JSONArray(submission.getAnswersJson());
            
            // Calculate correct and incorrect counts
            int correctCount = 0;
            int incorrectCount = 0;
            for (int i = 0; i < answersJson.length(); i++) {
                JSONObject answerObj = answersJson.getJSONObject(i);
                if (answerObj.getBoolean("isCorrect")) {
                    correctCount++;
                } else {
                    incorrectCount++;
                }
            }
            
            request.setAttribute("submission", submission);
            request.setAttribute("exam", exam);
            request.setAttribute("questions", questions);
            request.setAttribute("answersJson", answersJson);
            request.setAttribute("correctCount", correctCount);
            request.setAttribute("incorrectCount", incorrectCount);
            
            request.getRequestDispatcher("/student/exam-result.jsp").forward(request, response);
            
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
}
