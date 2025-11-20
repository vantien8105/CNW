package com.onlineexam.servlet;

import com.onlineexam.dao.*;
import com.onlineexam.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/teacher/courses")
public class CourseServlet extends HttpServlet {
    private CourseDAO courseDAO;
    private StudentDAO studentDAO;
    
    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        studentDAO = new StudentDAO();
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
        
        try {
            if (courseIdStr != null) {
                // Show specific course details
                int courseId = Integer.parseInt(courseIdStr);
                Course course = courseDAO.getCourseById(courseId);
                List<Student> students = studentDAO.getStudentsByCourse(courseId);
                
                request.setAttribute("course", course);
                request.setAttribute("students", students);
                request.getRequestDispatcher("/teacher/course-detail.jsp").forward(request, response);
            } else {
                // Show all courses for this teacher
                List<Course> courses = courseDAO.getCoursesByTeacher(teacher.getTeacherId());
                request.setAttribute("courses", courses);
                request.getRequestDispatcher("/teacher/courses.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Teacher teacher = (Teacher) session.getAttribute("teacher");
        
        if (user == null || teacher == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        try {
            if ("create".equals(action)) {
                createCourse(request, response, teacher);
            } else if ("update".equals(action)) {
                updateCourse(request, response);
            } else if ("delete".equals(action)) {
                deleteCourse(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    private void createCourse(HttpServletRequest request, HttpServletResponse response, Teacher teacher) 
            throws SQLException, IOException {
        String courseCode = request.getParameter("courseCode");
        String courseName = request.getParameter("courseName");
        String semester = request.getParameter("semester");
        int year = Integer.parseInt(request.getParameter("year"));
        String description = request.getParameter("description");
        
        Course course = new Course();
        course.setCourseCode(courseCode);
        course.setCourseName(courseName);
        course.setTeacherId(teacher.getTeacherId());
        course.setSemester(semester);
        course.setYear(year);
        course.setDescription(description);
        
        courseDAO.createCourse(course);
        response.sendRedirect(request.getContextPath() + "/teacher/courses");
    }
    
    private void updateCourse(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        String courseName = request.getParameter("courseName");
        String description = request.getParameter("description");
        
        Course course = courseDAO.getCourseById(courseId);
        course.setCourseName(courseName);
        course.setDescription(description);
        
        courseDAO.updateCourse(course);
        response.sendRedirect(request.getContextPath() + "/teacher/courses?courseId=" + courseId);
    }
    
    private void deleteCourse(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        courseDAO.deleteCourse(courseId);
        response.sendRedirect(request.getContextPath() + "/teacher/courses");
    }
}
