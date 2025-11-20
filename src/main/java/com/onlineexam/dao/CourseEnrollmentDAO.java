package com.onlineexam.dao;

import com.onlineexam.model.CourseEnrollment;
import com.onlineexam.model.CourseEnrollment.EnrollmentStatus;
import com.onlineexam.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseEnrollmentDAO {
    
    /**
     * Create a new enrollment
     */
    public int createEnrollment(CourseEnrollment enrollment) throws SQLException {
        String sql = "INSERT INTO course_enrollments (student_id, course_id, status) VALUES (?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, enrollment.getStudentId());
            pstmt.setInt(2, enrollment.getCourseId());
            pstmt.setString(3, enrollment.getStatus().toString());
            
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
     * Get enrollment by ID
     */
    public CourseEnrollment getEnrollmentById(int enrollmentId) throws SQLException {
        String sql = "SELECT * FROM course_enrollments WHERE enrollment_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, enrollmentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractEnrollmentFromResultSet(rs);
            }
        }
        return null;
    }
    
    /**
     * Check if student is enrolled in course
     */
    public boolean isStudentEnrolled(int studentId, int courseId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM course_enrollments " +
                    "WHERE student_id = ? AND course_id = ? AND status = 'ACTIVE'";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, courseId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }
    
    /**
     * Update enrollment status
     */
    public boolean updateEnrollmentStatus(int enrollmentId, EnrollmentStatus status) throws SQLException {
        String sql = "UPDATE course_enrollments SET status = ? WHERE enrollment_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, status.toString());
            pstmt.setInt(2, enrollmentId);
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Delete enrollment
     */
    public boolean deleteEnrollment(int enrollmentId) throws SQLException {
        String sql = "DELETE FROM course_enrollments WHERE enrollment_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, enrollmentId);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Get enrollments by student
     */
    public List<CourseEnrollment> getEnrollmentsByStudent(int studentId) throws SQLException {
        String sql = "SELECT * FROM course_enrollments WHERE student_id = ? ORDER BY enrollment_date DESC";
        List<CourseEnrollment> enrollments = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                enrollments.add(extractEnrollmentFromResultSet(rs));
            }
        }
        
        return enrollments;
    }
    
    /**
     * Get enrollments by course
     */
    public List<CourseEnrollment> getEnrollmentsByCourse(int courseId) throws SQLException {
        String sql = "SELECT * FROM course_enrollments WHERE course_id = ? ORDER BY enrollment_date DESC";
        List<CourseEnrollment> enrollments = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, courseId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                enrollments.add(extractEnrollmentFromResultSet(rs));
            }
        }
        
        return enrollments;
    }
    
    /**
     * Extract CourseEnrollment object from ResultSet
     */
    private CourseEnrollment extractEnrollmentFromResultSet(ResultSet rs) throws SQLException {
        CourseEnrollment enrollment = new CourseEnrollment();
        enrollment.setEnrollmentId(rs.getInt("enrollment_id"));
        enrollment.setStudentId(rs.getInt("student_id"));
        enrollment.setCourseId(rs.getInt("course_id"));
        enrollment.setEnrollmentDate(rs.getTimestamp("enrollment_date"));
        enrollment.setStatus(EnrollmentStatus.valueOf(rs.getString("status")));
        return enrollment;
        }
}
