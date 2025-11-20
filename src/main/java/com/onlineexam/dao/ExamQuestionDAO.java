package com.onlineexam.dao;

import com.onlineexam.model.ExamQuestion;
import com.onlineexam.model.ExamQuestion.QuestionType;
import com.onlineexam.util.DatabaseConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ExamQuestionDAO {
    
    /**
     * Create a new exam question
     */
    public int createQuestion(ExamQuestion question) throws SQLException {
        String sql = "INSERT INTO exam_questions (exam_id, question_number, question_text, " +
                    "question_type, options_json, correct_answer, points) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, question.getExamId());
            pstmt.setInt(2, question.getQuestionNumber());
            pstmt.setString(3, question.getQuestionText());
            pstmt.setString(4, question.getQuestionType().toString());
            pstmt.setString(5, question.getOptionsJson());
            pstmt.setString(6, question.getCorrectAnswer());
            pstmt.setDouble(7, question.getPoints());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        }
        return 0;
    }
    
    /**
     * Get all questions for an exam
     */
    public List<ExamQuestion> getQuestionsByExam(int examId) throws SQLException {
        String sql = "SELECT * FROM exam_questions WHERE exam_id = ? ORDER BY question_number";
        List<ExamQuestion> questions = new ArrayList<>();
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, examId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                questions.add(extractQuestionFromResultSet(rs));
            }
        }
        
        return questions;
    }
    
    /**
     * Get a specific question by ID
     */
    public ExamQuestion getQuestionById(int questionId) throws SQLException {
        String sql = "SELECT * FROM exam_questions WHERE question_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, questionId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return extractQuestionFromResultSet(rs);
            }
        }
        return null;
    }
    
    /**
     * Update a question
     */
    public boolean updateQuestion(ExamQuestion question) throws SQLException {
        String sql = "UPDATE exam_questions SET question_number = ?, question_text = ?, " +
                    "question_type = ?, options_json = ?, correct_answer = ?, points = ? " +
                    "WHERE question_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, question.getQuestionNumber());
            pstmt.setString(2, question.getQuestionText());
            pstmt.setString(3, question.getQuestionType().toString());
            pstmt.setString(4, question.getOptionsJson());
            pstmt.setString(5, question.getCorrectAnswer());
            pstmt.setDouble(6, question.getPoints());
            pstmt.setInt(7, question.getQuestionId());
            
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Delete a question
     */
    public boolean deleteQuestion(int questionId) throws SQLException {
        String sql = "DELETE FROM exam_questions WHERE question_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, questionId);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Delete all questions for an exam
     */
    public boolean deleteQuestionsByExam(int examId) throws SQLException {
        String sql = "DELETE FROM exam_questions WHERE exam_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, examId);
            return pstmt.executeUpdate() > 0;
        }
    }
    
    /**
     * Count questions in an exam
     */
    public int countQuestionsByExam(int examId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM exam_questions WHERE exam_id = ?";
        
        try (Connection conn = DatabaseConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, examId);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    
    /**
     * Extract ExamQuestion object from ResultSet
     */
    private ExamQuestion extractQuestionFromResultSet(ResultSet rs) throws SQLException {
        ExamQuestion question = new ExamQuestion();
        question.setQuestionId(rs.getInt("question_id"));
        question.setExamId(rs.getInt("exam_id"));
        question.setQuestionNumber(rs.getInt("question_number"));
        question.setQuestionText(rs.getString("question_text"));
        question.setQuestionType(QuestionType.valueOf(rs.getString("question_type")));
        question.setOptionsJson(rs.getString("options_json"));
        question.setCorrectAnswer(rs.getString("correct_answer"));
        question.setPoints(rs.getDouble("points"));
        return question;
    }
}
