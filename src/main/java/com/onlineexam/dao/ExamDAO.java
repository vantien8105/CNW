package com.onlineexam.dao;

import com.onlineexam.model.Exam;
import com.onlineexam.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExamDAO {
    
    /**
     * Create a new exam
     */
    public int createExam(Exam exam) throws SQLException {
        String sql = "INSERT INTO exams (course_id, exam_title, description, exam_file_path, " +
                    "duration_minutes, start_time, end_time, total_questions, pass_score, created_by, is_active) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, exam.getCourseId());
            pstmt.setString(2, exam.getExamTitle());
            pstmt.setString(3, exam.getDescription());
            pstmt.setString(4, exam.getExamFilePath());
            pstmt.setInt(5, exam.getDurationMinutes());
            pstmt.setTimestamp(6, Timestamp.valueOf(exam.getStartTime()));
            pstmt.setTimestamp(7, Timestamp.valueOf(exam.getEndTime()));
            pstmt.setInt(8, exam.getTotalQuestions());
            pstmt.setDouble(9, exam.getPassScore());
            pstmt.setInt(10, exam.getCreatedBy());
            pstmt.setBoolean(11, exam.isActive());
            
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
     * Get exam by ID
     */
    public Exam getExamById(int examId) throws SQLException {
        String sql = "SELECT e.*, COUNT(DISTINCT es.submission_id) as submission_count " +
                    "FROM exams e " +
                    "LEFT JOIN exam_submissions es ON e.exam_id = es.exam_id " +
                    "WHERE e.exam_id = ? " +
                    "GROUP BY e.exam_id";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, examId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Exam exam = extractExamFromResultSet(rs);
                exam.setSubmissionCount(rs.getInt("submission_count"));
                return exam;
            }
        }
        return null;
    }
    
    /**
     * Update exam
     */
    public boolean updateExam(Exam exam) throws SQLException {
        String sql = "UPDATE exams SET exam_title = ?, description = ?, duration_minutes = ?, " +
                    "start_time = ?, end_time = ?, pass_score = ?, is_active = ? WHERE exam_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, exam.getExamTitle());
            pstmt.setString(2, exam.getDescription());
            pstmt.setInt(3, exam.getDurationMinutes());
            pstmt.setTimestamp(4, Timestamp.valueOf(exam.getStartTime()));
            pstmt.setTimestamp(5, Timestamp.valueOf(exam.getEndTime()));
            pstmt.setDouble(6, exam.getPassScore());
            pstmt.setBoolean(7, exam.isActive());
            pstmt.setInt(8, exam.getExamId());
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Delete exam
     */
    public boolean deleteExam(int examId) throws SQLException {
        String sql = "DELETE FROM exams WHERE exam_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, examId);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Get exams by course ID
     */
    public List<Exam> getExamsByCourse(int courseId) throws SQLException {
        String sql = "SELECT e.*, COUNT(DISTINCT es.submission_id) as submission_count " +
                    "FROM exams e " +
                    "LEFT JOIN exam_submissions es ON e.exam_id = es.exam_id " +
                    "WHERE e.course_id = ? " +
                    "GROUP BY e.exam_id " +
                    "ORDER BY e.start_time DESC";
        List<Exam> exams = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, courseId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Exam exam = extractExamFromResultSet(rs);
                exam.setSubmissionCount(rs.getInt("submission_count"));
                exams.add(exam);
            }
        }
        
        return exams;
    }
    
    /**
     * Get available exams for a student in a course
     */
    public List<Exam> getAvailableExamsForStudent(int studentId, int courseId) throws SQLException {
        String sql = "SELECT e.*, " +
                    "CASE WHEN es.submission_id IS NOT NULL THEN 1 ELSE 0 END as has_submitted " +
                    "FROM exams e " +
                    "LEFT JOIN exam_submissions es ON e.exam_id = es.exam_id AND es.student_id = ? " +
                    "WHERE e.course_id = ? AND e.is_active = true " +
                    "AND e.start_time <= NOW() AND e.end_time >= NOW() " +
                    "ORDER BY e.start_time";
        List<Exam> exams = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, courseId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                boolean hasSubmitted = rs.getInt("has_submitted") == 1;
                if (!hasSubmitted) { // Only return exams not yet submitted
                    exams.add(extractExamFromResultSet(rs));
                }
            }
        }
        
        return exams;
    }
    
    /**
     * Check if student has submitted exam
     */
    public boolean hasStudentSubmitted(int examId, int studentId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM exam_submissions WHERE exam_id = ? AND student_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, examId);
            pstmt.setInt(2, studentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }
    
    /**
     * Extract Exam object from ResultSet
     */
    private Exam extractExamFromResultSet(ResultSet rs) throws SQLException {
        Exam exam = new Exam();
        exam.setExamId(rs.getInt("exam_id"));
        exam.setCourseId(rs.getInt("course_id"));
        exam.setExamTitle(rs.getString("exam_title"));
        exam.setDescription(rs.getString("description"));
        exam.setExamFilePath(rs.getString("exam_file_path"));
        exam.setDurationMinutes(rs.getInt("duration_minutes"));
        
        Timestamp startTime = rs.getTimestamp("start_time");
        if (startTime != null) {
            exam.setStartTime(startTime.toLocalDateTime());
        }
        
        Timestamp endTime = rs.getTimestamp("end_time");
        if (endTime != null) {
            exam.setEndTime(endTime.toLocalDateTime());
        }
        
        exam.setTotalQuestions(rs.getInt("total_questions"));
        exam.setPassScore(rs.getDouble("pass_score"));
        exam.setCreatedAt(rs.getTimestamp("created_at"));
        exam.setCreatedBy(rs.getInt("created_by"));
        exam.setActive(rs.getBoolean("is_active"));
        return exam;
    }
}
