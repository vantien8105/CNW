package com.onlineexam.dao;

import com.onlineexam.model.Teacher;
import com.onlineexam.model.User;
import com.onlineexam.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TeacherDAO {
    
    private UserDAO userDAO = new UserDAO();
    
    /**
     * Create a new teacher
     */
    public int createTeacher(Teacher teacher) throws SQLException {
        String sql = "INSERT INTO teachers (user_id, teacher_code, department, title) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, teacher.getUserId());
            pstmt.setString(2, teacher.getTeacherCode());
            pstmt.setString(3, teacher.getDepartment());
            pstmt.setString(4, teacher.getTitle());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        }
        return -1;
    }
    
    /**
     * Get teacher by ID
     */
    public Teacher getTeacherById(int teacherId) throws SQLException {
        String sql = "SELECT * FROM teachers WHERE teacher_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, teacherId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Teacher teacher = extractTeacherFromResultSet(rs);
                teacher.setUser(userDAO.getUserById(teacher.getUserId()));
                return teacher;
            }
        }
        return null;
    }
    
    /**
     * Get teacher by user ID
     */
    public Teacher getTeacherByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM teachers WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Teacher teacher = extractTeacherFromResultSet(rs);
                teacher.setUser(userDAO.getUserById(userId));
                return teacher;
            }
        }
        return null;
    }
    
    /**
     * Get teacher by teacher code
     */
    public Teacher getTeacherByCode(String teacherCode) throws SQLException {
        String sql = "SELECT * FROM teachers WHERE teacher_code = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, teacherCode);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Teacher teacher = extractTeacherFromResultSet(rs);
                teacher.setUser(userDAO.getUserById(teacher.getUserId()));
                return teacher;
            }
        }
        return null;
    }
    
    /**
     * Update teacher
     */
    public boolean updateTeacher(Teacher teacher) throws SQLException {
        String sql = "UPDATE teachers SET department = ?, title = ? WHERE teacher_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, teacher.getDepartment());
            pstmt.setString(2, teacher.getTitle());
            pstmt.setInt(3, teacher.getTeacherId());
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Delete teacher
     */
    public boolean deleteTeacher(int teacherId) throws SQLException {
        String sql = "DELETE FROM teachers WHERE teacher_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, teacherId);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Get all teachers
     */
    public List<Teacher> getAllTeachers() throws SQLException {
        String sql = "SELECT t.*, u.username, u.email, u.full_name FROM teachers t " +
                    "JOIN users u ON t.user_id = u.user_id ORDER BY u.full_name";
        List<Teacher> teachers = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Teacher teacher = extractTeacherFromResultSet(rs);
                User user = new User();
                user.setUserId(teacher.getUserId());
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setFullName(rs.getString("full_name"));
                teacher.setUser(user);
                teachers.add(teacher);
            }
        }
        
        return teachers;
    }
    
    /**
     * Extract Teacher object from ResultSet
     */
    private Teacher extractTeacherFromResultSet(ResultSet rs) throws SQLException {
        Teacher teacher = new Teacher();
        teacher.setTeacherId(rs.getInt("teacher_id"));
        teacher.setUserId(rs.getInt("user_id"));
        teacher.setTeacherCode(rs.getString("teacher_code"));
        teacher.setDepartment(rs.getString("department"));
        teacher.setTitle(rs.getString("title"));
        return teacher;
    }
}
