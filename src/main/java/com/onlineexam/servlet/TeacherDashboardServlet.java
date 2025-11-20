package com.onlineexam.servlet;

import com.onlineexam.dao.CourseDAO;
import com.onlineexam.dao.ExamDAO;
import com.onlineexam.model.Course;
import com.onlineexam.model.Exam;
import com.onlineexam.model.Teacher;
import com.onlineexam.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

public class TeacherDashboardServlet extends HttpServlet {
    
    private CourseDAO courseDAO = new CourseDAO();
    private ExamDAO examDAO = new ExamDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !SessionUtil.isTeacher(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Teacher teacher = SessionUtil.getTeacher(session);
        
        try {
            // Get teacher's courses
            List<Course> courses = courseDAO.getCoursesByTeacher(teacher.getTeacherId());
            request.setAttribute("courses", courses);
            
            // Count total exams
            int totalExams = 0;
            int activeExams = 0;
            int totalStudents = 0;
            
            for (Course course : courses) {
                List<Exam> exams = examDAO.getExamsByCourse(course.getCourseId());
                totalExams += exams.size();
                
                for (Exam exam : exams) {
                    if (exam.isAvailable()) {
                        activeExams++;
                    }
                }
                
                totalStudents += course.getEnrolledStudents();
            }
            
            request.setAttribute("totalExams", totalExams);
            request.setAttribute("activeExams", activeExams);
            request.setAttribute("totalStudents", totalStudents);
            
            request.getRequestDispatcher("/teacher/dashboard.jsp").forward(request, response);
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải dữ liệu");
            request.getRequestDispatcher("/teacher/dashboard.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
