package com.onlineexam.servlet;

import com.onlineexam.dao.StudentDAO;
import com.onlineexam.dao.TeacherDAO;
import com.onlineexam.dao.UserDAO;
import com.onlineexam.model.Student;
import com.onlineexam.model.Teacher;
import com.onlineexam.model.User;
import com.onlineexam.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

public class LoginServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    private StudentDAO studentDAO = new StudentDAO();
    private TeacherDAO teacherDAO = new TeacherDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forward to login page
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        try {
            // Authenticate user
            User user = userDAO.authenticate(username, password);
            
            if (user != null && user.isActive()) {
                // Set user in session
                HttpSession session = request.getSession();
                SessionUtil.setUser(session, user);
                
                // Get additional info based on user type
                if (user.getUserType() == User.UserType.STUDENT) {
                    Student student = studentDAO.getStudentByUserId(user.getUserId());
                    if (student != null) {
                        SessionUtil.setStudent(session, student);
                        response.sendRedirect(request.getContextPath() + "/student/dashboard");
                    } else {
                        request.setAttribute("error", "Không tìm thấy thông tin sinh viên");
                        request.getRequestDispatcher("/login.jsp").forward(request, response);
                    }
                } else if (user.getUserType() == User.UserType.TEACHER) {
                    Teacher teacher = teacherDAO.getTeacherByUserId(user.getUserId());
                    if (teacher != null) {
                        SessionUtil.setTeacher(session, teacher);
                        response.sendRedirect(request.getContextPath() + "/teacher/dashboard");
                    } else {
                        request.setAttribute("error", "Không tìm thấy thông tin giảng viên");
                        request.getRequestDispatcher("/login.jsp").forward(request, response);
                    }
                }
            } else {
                // Authentication failed
                request.setAttribute("error", "Tên đăng nhập hoặc mật khẩu không đúng");
                request.setAttribute("username", username);
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống. Vui lòng thử lại sau.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
