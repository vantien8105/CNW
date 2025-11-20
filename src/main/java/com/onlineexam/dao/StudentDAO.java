package com.onlineexam.dao;

import com.onlineexam.model.Student;
import com.onlineexam.model.User;
import com.onlineexam.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StudentDAO {
    
    private UserDAO userDAO = new UserDAO();
    
    /**
     * Create a new student
     */
    public int createStudent(Student student) throws SQLException {
        String sql = "INSERT INTO students (user_id, student_code, major, year_of_study) VALUES (?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, student.getUserId());
            pstmt.setString(2, student.getStudentCode());
            pstmt.setString(3, student.getMajor());
            pstmt.setInt(4, student.getYearOfStudy());
            
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
     * Get student by ID
     */
    public Student getStudentById(int studentId) throws SQLException {
        String sql = "SELECT * FROM students WHERE student_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Student student = extractStudentFromResultSet(rs);
                student.setUser(userDAO.getUserById(student.getUserId()));
                return student;
            }
        }
        return null;
    }
    
    /**
     * Get student by user ID
     */
    public Student getStudentByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM students WHERE user_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Student student = extractStudentFromResultSet(rs);
                student.setUser(userDAO.getUserById(userId));
                return student;
            }
        }
        return null;
    }
    
    /**
     * Get student by student code
     */
    public Student getStudentByCode(String studentCode) throws SQLException {
        String sql = "SELECT * FROM students WHERE student_code = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, studentCode);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Student student = extractStudentFromResultSet(rs);
                student.setUser(userDAO.getUserById(student.getUserId()));
                return student;
            }
        }
        return null;
    }
    
    /**
     * Update student
     */
    public boolean updateStudent(Student student) throws SQLException {
        String sql = "UPDATE students SET major = ?, year_of_study = ? WHERE student_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, student.getMajor());
            pstmt.setInt(2, student.getYearOfStudy());
            pstmt.setInt(3, student.getStudentId());
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Delete student
     */
    public boolean deleteStudent(int studentId) throws SQLException {
        String sql = "DELETE FROM students WHERE student_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Get all students
     */
    public List<Student> getAllStudents() throws SQLException {
        String sql = "SELECT s.*, u.username, u.email, u.full_name FROM students s " +
                    "JOIN users u ON s.user_id = u.user_id ORDER BY u.full_name";
        List<Student> students = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Student student = extractStudentFromResultSet(rs);
                User user = new User();
                user.setUserId(student.getUserId());
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setFullName(rs.getString("full_name"));
                student.setUser(user);
                students.add(student);
            }
        }
        
        return students;
    }
    
    /**
     * Get students by course ID
     */
    public List<Student> getStudentsByCourse(int courseId) throws SQLException {
        String sql = "SELECT s.*, u.username, u.email, u.full_name, u.is_active " +
                    "FROM students s " +
                    "JOIN users u ON s.user_id = u.user_id " +
                    "JOIN course_enrollments ce ON s.student_id = ce.student_id " +
                    "WHERE ce.course_id = ? AND ce.status = 'ACTIVE' " +
                    "ORDER BY u.full_name";
        List<Student> students = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, courseId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Student student = extractStudentFromResultSet(rs);
                User user = new User();
                user.setUserId(student.getUserId());
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                user.setFullName(rs.getString("full_name"));
                user.setActive(rs.getBoolean("is_active"));
                student.setUser(user);
                students.add(student);
            }
        }
        
        return students;
    }
    
    /**
     * Extract Student object from ResultSet
     */
    private Student extractStudentFromResultSet(ResultSet rs) throws SQLException {
        Student student = new Student();
        student.setStudentId(rs.getInt("student_id"));
        student.setUserId(rs.getInt("user_id"));
        student.setStudentCode(rs.getString("student_code"));
        student.setMajor(rs.getString("major"));
        student.setYearOfStudy(rs.getInt("year_of_study"));
        return student;
    }
}
