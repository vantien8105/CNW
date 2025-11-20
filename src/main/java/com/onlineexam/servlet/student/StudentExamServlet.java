package com.onlineexam.servlet.student;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.onlineexam.dao.CourseDAO;
import com.onlineexam.dao.ExamDAO;
import com.onlineexam.dao.ExamSubmissionDAO;
import com.onlineexam.dao.StudentDAO;
import com.onlineexam.model.Course;
import com.onlineexam.model.Exam;
import com.onlineexam.model.ExamSubmission;
import com.onlineexam.model.Student;
import com.onlineexam.model.User;
import com.onlineexam.util.SessionUtil;

@WebServlet("/student/exams")
public class StudentExamServlet extends HttpServlet {
    private ExamDAO examDAO;
    private CourseDAO courseDAO;
    private StudentDAO studentDAO;
    private ExamSubmissionDAO submissionDAO;
    
    @Override
    public void init() {
        examDAO = new ExamDAO();
        courseDAO = new CourseDAO();
        studentDAO = new StudentDAO();
        submissionDAO = new ExamSubmissionDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || !SessionUtil.isLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        User user = SessionUtil.getUser(session);
        String action = request.getParameter("action");
        
        try {
            Student student = studentDAO.getStudentByUserId(user.getUserId());
            
            if (student == null) {
                request.setAttribute("error", "Không tìm thấy thông tin sinh viên");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            
            if ("viewExams".equals(action)) {
                String courseIdStr = request.getParameter("courseId");
                if (courseIdStr != null) {
                    int courseId = Integer.parseInt(courseIdStr);
                    viewCourseExams(request, response, student.getStudentId(), courseId);
                }
            } else {
                viewAllCourses(request, response, student.getStudentId());
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    private void viewAllCourses(HttpServletRequest request, HttpServletResponse response, 
                                int studentId) throws ServletException, IOException {
        try {
            List<Course> courses = courseDAO.getCoursesByStudent(studentId);
            
            System.out.println("=== Student Courses ===");
            System.out.println("Student ID: " + studentId);
            System.out.println("Number of courses: " + courses.size());
            
            request.setAttribute("courses", courses);
            request.getRequestDispatcher("/student/exams.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
    
    private void viewCourseExams(HttpServletRequest request, HttpServletResponse response,
                                 int studentId, int courseId) throws ServletException, IOException {
        try {
            Course course = courseDAO.getCourseById(courseId);
            List<Exam> exams = examDAO.getExamsByCourse(courseId);
            
            // Check submission status for each exam
            Map<Integer, ExamSubmission> submissionMap = new HashMap<>();
            for (Exam exam : exams) {
                ExamSubmission submission = submissionDAO.getSubmissionByExamAndStudent(
                    exam.getExamId(), studentId);
                if (submission != null) {
                    submissionMap.put(exam.getExamId(), submission);
                }
            }
            
            System.out.println("=== Course Exams ===");
            System.out.println("Course ID: " + courseId);
            System.out.println("Course Name: " + (course != null ? course.getCourseName() : "N/A"));
            System.out.println("Number of exams: " + exams.size());
            System.out.println("Submissions: " + submissionMap.size());
            
            request.setAttribute("course", course);
            request.setAttribute("exams", exams);
            request.setAttribute("submissions", submissionMap);
            request.getRequestDispatcher("/student/course-exams.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(e);
        }
    }
}
