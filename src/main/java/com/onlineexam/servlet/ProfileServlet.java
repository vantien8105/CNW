package com.onlineexam.servlet;

import com.onlineexam.dao.UserDAO;
import com.onlineexam.model.User;
import com.onlineexam.model.Student;
import com.onlineexam.model.Teacher;
import com.onlineexam.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

public class ProfileServlet extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !SessionUtil.isLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = SessionUtil.getUser(session);
        request.setAttribute("user", user);
        
        if (SessionUtil.isStudent(session)) {
            Student student = SessionUtil.getStudent(session);
            request.setAttribute("student", student);
            request.getRequestDispatcher("/student/profile.jsp").forward(request, response);
        } else if (SessionUtil.isTeacher(session)) {
            Teacher teacher = SessionUtil.getTeacher(session);
            request.setAttribute("teacher", teacher);
            request.getRequestDispatcher("/teacher/profile.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || !SessionUtil.isLoggedIn(session)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User user = SessionUtil.getUser(session);
        
        // Get form data
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        
        // Update user info
        user.setEmail(email);
        user.setFullName(fullName);
        
        try {
            boolean updated = userDAO.updateUser(user);
            
            if (updated) {
                SessionUtil.setUser(session, user);
                request.setAttribute("success", "Cập nhật thông tin thành công!");
            } else {
                request.setAttribute("error", "Không thể cập nhật thông tin!");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }
        
        doGet(request, response);
    }
}
