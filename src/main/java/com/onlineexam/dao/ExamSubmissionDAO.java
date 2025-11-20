package com.onlineexam.dao;

import com.onlineexam.model.ExamSubmission;
import com.onlineexam.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExamSubmissionDAO {
    
    /**
     * Create a new exam submission
     */
    public int createSubmission(ExamSubmission submission) throws SQLException {
        String sql = "INSERT INTO exam_submissions (exam_id, student_id, answers_json, score, " +
                    "time_taken_minutes, is_passed) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, submission.getExamId());
            pstmt.setInt(2, submission.getStudentId());
            pstmt.setString(3, submission.getAnswersJson());
            pstmt.setDouble(4, submission.getScore());
            pstmt.setInt(5, submission.getTimeTakenMinutes());
            pstmt.setBoolean(6, submission.isPassed());
            
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
     * Get submission by ID
     */
    public ExamSubmission getSubmissionById(int submissionId) throws SQLException {
        String sql = "SELECT * FROM exam_submissions WHERE submission_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, submissionId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractSubmissionFromResultSet(rs);
            }
        }
        return null;
    }
    
    /**
     * Get submission by exam and student
     */
    public ExamSubmission getSubmissionByExamAndStudent(int examId, int studentId) throws SQLException {
        String sql = "SELECT * FROM exam_submissions WHERE exam_id = ? AND student_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, examId);
            pstmt.setInt(2, studentId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractSubmissionFromResultSet(rs);
            }
        }
        return null;
    }
    
    /**
     * Get submissions by exam ID
     */
    public List<ExamSubmission> getSubmissionsByExam(int examId) throws SQLException {
        String sql = "SELECT es.*, s.student_code, u.full_name " +
                    "FROM exam_submissions es " +
                    "JOIN students s ON es.student_id = s.student_id " +
                    "JOIN users u ON s.user_id = u.user_id " +
                    "WHERE es.exam_id = ? " +
                    "ORDER BY es.score DESC, es.submitted_at";
        List<ExamSubmission> submissions = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, examId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                submissions.add(extractSubmissionFromResultSet(rs));
            }
        }
        
        return submissions;
    }
    
    /**
     * Get submissions by student ID
     */
    public List<ExamSubmission> getSubmissionsByStudent(int studentId) throws SQLException {
        String sql = "SELECT es.*, e.exam_title, e.total_questions, c.course_name " +
                    "FROM exam_submissions es " +
                    "JOIN exams e ON es.exam_id = e.exam_id " +
                    "JOIN courses c ON e.course_id = c.course_id " +
                    "WHERE es.student_id = ? " +
                    "ORDER BY es.submitted_at DESC";
        List<ExamSubmission> submissions = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                submissions.add(extractSubmissionFromResultSet(rs));
            }
        }
        
        return submissions;
    }
    
    /**
     * Get submissions by course for a student
     */
    public List<ExamSubmission> getSubmissionsByStudentAndCourse(int studentId, int courseId) throws SQLException {
        String sql = "SELECT es.*, e.exam_title, e.total_questions " +
                    "FROM exam_submissions es " +
                    "JOIN exams e ON es.exam_id = e.exam_id " +
                    "WHERE es.student_id = ? AND e.course_id = ? " +
                    "ORDER BY es.submitted_at DESC";
        List<ExamSubmission> submissions = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, studentId);
            pstmt.setInt(2, courseId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                submissions.add(extractSubmissionFromResultSet(rs));
            }
        }
        
        return submissions;
    }
    
    /**
     * Delete submission
     */
    public boolean deleteSubmission(int submissionId) throws SQLException {
        String sql = "DELETE FROM exam_submissions WHERE submission_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, submissionId);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Extract ExamSubmission object from ResultSet
     */
    private ExamSubmission extractSubmissionFromResultSet(ResultSet rs) throws SQLException {
        ExamSubmission submission = new ExamSubmission();
        submission.setSubmissionId(rs.getInt("submission_id"));
        submission.setExamId(rs.getInt("exam_id"));
        submission.setStudentId(rs.getInt("student_id"));
        submission.setAnswersJson(rs.getString("answers_json"));
        submission.setScore(rs.getDouble("score"));
        submission.setSubmittedAt(rs.getTimestamp("submitted_at"));
        submission.setTimeTakenMinutes(rs.getInt("time_taken_minutes"));
        submission.setPassed(rs.getBoolean("is_passed"));
        return submission;
    }
}
