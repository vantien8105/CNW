package com.onlineexam.servlet;

import com.onlineexam.dao.CourseDAO;
import com.onlineexam.dao.ExamDAO;
import com.onlineexam.dao.ExamSubmissionDAO;
import com.onlineexam.model.Course;
import com.onlineexam.model.Exam;
import com.onlineexam.model.ExamSubmission;
import com.onlineexam.model.Student;
import com.onlineexam.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class StudentDashboardServlet extends HttpServlet {
    
    private CourseDAO courseDAO = new CourseDAO();
    private ExamDAO examDAO = new ExamDAO();
    private ExamSubmissionDAO submissionDAO = new ExamSubmissionDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !SessionUtil.isStudent(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Student student = SessionUtil.getStudent(session);
        
        try {
            // Get student's courses
            List<Course> courses = courseDAO.getCoursesByStudent(student.getStudentId());
            request.setAttribute("courses", courses);
            
            // Get recent submissions
            List<ExamSubmission> recentSubmissions = submissionDAO.getSubmissionsByStudent(student.getStudentId());
            if (recentSubmissions.size() > 5) {
                recentSubmissions = recentSubmissions.subList(0, 5);
            }
            request.setAttribute("recentSubmissions", recentSubmissions);
            
            // Count available exams
            int availableExamsCount = 0;
            for (Course course : courses) {
                List<Exam> exams = examDAO.getAvailableExamsForStudent(student.getStudentId(), course.getCourseId());
                availableExamsCount += exams.size();
            }
            request.setAttribute("availableExamsCount", availableExamsCount);
            
            request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu");
            request.getRequestDispatcher("/student/dashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
