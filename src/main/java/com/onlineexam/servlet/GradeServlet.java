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
import java.util.*;

@WebServlet("/teacher/grades")
public class GradeServlet extends HttpServlet {
    private ExamSubmissionDAO submissionDAO;
    private CourseDAO courseDAO;
    private ExamDAO examDAO;
    private StudentDAO studentDAO;
    private ExamQuestionDAO questionDAO;
    
    @Override
    public void init() throws ServletException {
        submissionDAO = new ExamSubmissionDAO();
        courseDAO = new CourseDAO();
        examDAO = new ExamDAO();
        studentDAO = new StudentDAO();
        questionDAO = new ExamQuestionDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Teacher teacher = (Teacher) session.getAttribute("teacher");
        
        if (user == null || teacher == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String courseIdStr = request.getParameter("courseId");
        String examIdStr = request.getParameter("examId");
        String submissionIdStr = request.getParameter("submissionId");
        
        try {
            if (submissionIdStr != null) {
                // Show submission details
                viewSubmissionDetail(request, response, Integer.parseInt(submissionIdStr));
            } else if (examIdStr != null) {
                // Show submissions for specific exam
                int examId = Integer.parseInt(examIdStr);
                Exam exam = examDAO.getExamById(examId);
                Course course = courseDAO.getCourseById(exam.getCourseId());
                List<ExamSubmission> submissions = submissionDAO.getSubmissionsByExam(examId);
                
                // Add student info to submissions
                Map<Integer, Student> studentMap = new HashMap<>();
                for (ExamSubmission sub : submissions) {
                    if (!studentMap.containsKey(sub.getStudentId())) {
                        Student student = studentDAO.getStudentById(sub.getStudentId());
                        studentMap.put(sub.getStudentId(), student);
                        // Add student info to submission for JSP
                        sub.setStudentCode(student.getUser().getUsername());
                        sub.setStudentName(student.getUser().getFullName());
                    }
                }
                
                request.setAttribute("exam", exam);
                request.setAttribute("course", course);
                request.setAttribute("submissions", submissions);
                request.getRequestDispatcher("/teacher/exam-grades.jsp").forward(request, response);
            } else if (courseIdStr != null) {
                // Show all exams for course
                int courseId = Integer.parseInt(courseIdStr);
                Course course = courseDAO.getCourseById(courseId);
                List<Exam> exams = examDAO.getExamsByCourse(courseId);
                
                request.setAttribute("course", course);
                request.setAttribute("exams", exams);
                request.getRequestDispatcher("/teacher/course-grades.jsp").forward(request, response);
            } else {
                // Show all courses
                List<Course> courses = courseDAO.getCoursesByTeacher(teacher.getTeacherId());
                request.setAttribute("courses", courses);
                request.getRequestDispatcher("/teacher/grades.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    private void viewSubmissionDetail(HttpServletRequest request, HttpServletResponse response, int submissionId) 
            throws SQLException, ServletException, IOException {
        // Get submission
        ExamSubmission submission = submissionDAO.getSubmissionById(submissionId);
        if (submission == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Submission not found");
            return;
        }
        
        // Get exam and questions
        Exam exam = examDAO.getExamById(submission.getExamId());
        List<ExamQuestion> questions = questionDAO.getQuestionsByExam(submission.getExamId());
        
        // Get student info
        Student student = studentDAO.getStudentById(submission.getStudentId());
        submission.setStudentCode(student.getUser().getUsername());
        submission.setStudentName(student.getUser().getFullName());
        
        // Parse answers JSON
        String answersJson = submission.getAnswersJson();
        Map<Integer, AnswerDetail> answersMap = new HashMap<>();
        int correctCount = 0;
        int incorrectCount = 0;
        
        if (answersJson != null && !answersJson.isEmpty()) {
            JSONArray answersArray = new JSONArray(answersJson);
            for (int i = 0; i < answersArray.length(); i++) {
                JSONObject answerObj = answersArray.getJSONObject(i);
                AnswerDetail detail = new AnswerDetail();
                detail.setQuestionId(answerObj.getInt("questionId"));
                detail.setStudentAnswer(answerObj.optString("answer", null));
                detail.setCorrectAnswer(answerObj.optString("correctAnswer", null));
                detail.setCorrect(answerObj.getBoolean("isCorrect"));
                detail.setPoints(answerObj.getDouble("points"));
                
                answersMap.put(detail.getQuestionId(), detail);
                
                if (detail.isCorrect()) {
                    correctCount++;
                } else {
                    incorrectCount++;
                }
            }
        }
        
        // Set attributes
        request.setAttribute("submission", submission);
        request.setAttribute("exam", exam);
        request.setAttribute("questions", questions);
        request.setAttribute("answersMap", answersMap);
        request.setAttribute("correctCount", correctCount);
        request.setAttribute("incorrectCount", incorrectCount);
        
        // Forward to detail page
        request.getRequestDispatcher("/teacher/submission-detail.jsp").forward(request, response);
    }
    
    // Inner class for answer details
    public static class AnswerDetail {
        private int questionId;
        private String studentAnswer;
        private String correctAnswer;
        private boolean isCorrect;
        private double points;
        
        public int getQuestionId() { return questionId; }
        public void setQuestionId(int questionId) { this.questionId = questionId; }
        
        public String getStudentAnswer() { return studentAnswer; }
        public void setStudentAnswer(String studentAnswer) { this.studentAnswer = studentAnswer; }
        
        public String getCorrectAnswer() { return correctAnswer; }
        public void setCorrectAnswer(String correctAnswer) { this.correctAnswer = correctAnswer; }
        
        public boolean isCorrect() { return isCorrect; }
        public void setCorrect(boolean correct) { isCorrect = correct; }
        
        public double getPoints() { return points; }
        public void setPoints(double points) { this.points = points; }
    }
}

