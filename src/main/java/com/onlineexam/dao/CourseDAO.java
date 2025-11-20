package com.onlineexam.dao;

import com.onlineexam.model.Course;
import com.onlineexam.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CourseDAO {
    
    private TeacherDAO teacherDAO = new TeacherDAO();
    
    /**
     * Create a new course
     */
    public int createCourse(Course course) throws SQLException {
        String sql = "INSERT INTO courses (course_code, course_name, teacher_id, semester, year, description, is_active) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, course.getCourseCode());
            pstmt.setString(2, course.getCourseName());
            pstmt.setInt(3, course.getTeacherId());
            pstmt.setString(4, course.getSemester());
            pstmt.setInt(5, course.getYear());
            pstmt.setString(6, course.getDescription());
            pstmt.setBoolean(7, course.isActive());
            
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
     * Get course by ID
     */
    public Course getCourseById(int courseId) throws SQLException {
        String sql = "SELECT c.*, COUNT(DISTINCT ce.student_id) as enrolled_count " +
                    "FROM courses c " +
                    "LEFT JOIN course_enrollments ce ON c.course_id = ce.course_id AND ce.status = 'ACTIVE' " +
                    "WHERE c.course_id = ? " +
                    "GROUP BY c.course_id";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, courseId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Course course = extractCourseFromResultSet(rs);
                course.setEnrolledStudents(rs.getInt("enrolled_count"));
                course.setTeacher(teacherDAO.getTeacherById(course.getTeacherId()));
                return course;
            }
        }
        return null;
    }
    
    /**
     * Get course by code
     */
    public Course getCourseByCode(String courseCode) throws SQLException {
        String sql = "SELECT * FROM courses WHERE course_code = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, courseCode);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Course course = extractCourseFromResultSet(rs);
                course.setTeacher(teacherDAO.getTeacherById(course.getTeacherId()));
                return course;
            }
        }
        return null;
    }
    
    /**
     * Update course
     */
    public boolean updateCourse(Course course) throws SQLException {
        String sql = "UPDATE courses SET course_name = ?, semester = ?, year = ?, " +
                    "description = ?, is_active = ? WHERE course_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, course.getCourseName());
            pstmt.setString(2, course.getSemester());
            pstmt.setInt(3, course.getYear());
            pstmt.setString(4, course.getDescription());
            pstmt.setBoolean(5, course.isActive());
            pstmt.setInt(6, course.getCourseId());
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Delete course
     */
    public boolean deleteCourse(int courseId) throws SQLException {
        String sql = "DELETE FROM courses WHERE course_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, courseId);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Get all courses
     */
    public List<Course> getAllCourses() throws SQLException {
        String sql = "SELECT c.*, COUNT(DISTINCT ce.student_id) as enrolled_count " +
                    "FROM courses c " +
                    "LEFT JOIN course_enrollments ce ON c.course_id = ce.course_id AND ce.status = 'ACTIVE' " +
                    "WHERE c.is_active = true " +
                    "GROUP BY c.course_id " +
                    "ORDER BY c.year DESC, c.semester DESC, c.course_name";
        List<Course> courses = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Course course = extractCourseFromResultSet(rs);
                course.setEnrolledStudents(rs.getInt("enrolled_count"));
                courses.add(course);
            }
        }
        
        return courses;
    }
    
    /**
     * Get courses by teacher ID
     */
    public List<Course> getCoursesByTeacher(int teacherId) throws SQLException {
        String sql = "SELECT c.*, COUNT(DISTINCT ce.student_id) as enrolled_count " +
                    "FROM courses c " +
                    "LEFT JOIN course_enrollments ce ON c.course_id = ce.course_id AND ce.status = 'ACTIVE' " +
                    "WHERE c.teacher_id = ? AND c.is_active = true " +
                    "GROUP BY c.course_id " +
                    "ORDER BY c.year DESC, c.semester DESC, c.course_name";
        List<Course> courses = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, teacherId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Course course = extractCourseFromResultSet(rs);
                course.setEnrolledStudents(rs.getInt("enrolled_count"));
                courses.add(course);
            }
        }
        
        return courses;
    }
    
    /**
     * Get courses by student ID
     */
    public List<Course> getCoursesByStudent(int studentId) throws SQLException {
        String sql = "SELECT c.*, ce.enrollment_date, ce.status " +
                    "FROM courses c " +
                    "JOIN course_enrollments ce ON c.course_id = ce.course_id " +
                    "WHERE ce.student_id = ? AND ce.status = 'ACTIVE' " +
                    "ORDER BY c.year DESC, c.semester DESC, c.course_name";
        List<Course> courses = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Course course = extractCourseFromResultSet(rs);
                courses.add(course);
            }
        }
        
        return courses;
    }
    
    /**
     * Extract Course object from ResultSet
     */
    private Course extractCourseFromResultSet(ResultSet rs) throws SQLException {
        Course course = new Course();
        course.setCourseId(rs.getInt("course_id"));
        course.setCourseCode(rs.getString("course_code"));
        course.setCourseName(rs.getString("course_name"));
        course.setTeacherId(rs.getInt("teacher_id"));
        course.setSemester(rs.getString("semester"));
        course.setYear(rs.getInt("year"));
        course.setDescription(rs.getString("description"));
        course.setCreatedAt(rs.getTimestamp("created_at"));
        course.setActive(rs.getBoolean("is_active"));
        return course;
    }
}
