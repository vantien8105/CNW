package com.onlineexam.util;

import org.json.JSONArray;
import org.json.JSONObject;
import com.onlineexam.model.ExamQuestion;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.List;

/**
 * Utility class for parsing exam JSON files
 */
public class ExamJsonParser {
    
    /**
     * Parse exam JSON file and return list of questions
     */
    public static List<ExamQuestion> parseExamFile(String filePath, int examId) throws IOException {
        // Read file content
        String content = new String(Files.readAllBytes(new File(filePath).toPath()));
        JSONObject examJson = new JSONObject(content);
        
        List<ExamQuestion> questions = new ArrayList<>();
        JSONArray questionsArray = examJson.getJSONArray("questions");
        
        for (int i = 0; i < questionsArray.length(); i++) {
            JSONObject questionObj = questionsArray.getJSONObject(i);
            
            ExamQuestion question = new ExamQuestion();
            question.setExamId(examId);
            question.setQuestionNumber(questionObj.getInt("questionNumber"));
            question.setQuestionText(questionObj.getString("questionText"));
            question.setQuestionType(ExamQuestion.QuestionType.valueOf(questionObj.getString("questionType")));
            question.setCorrectAnswer(questionObj.getString("correctAnswer"));
            question.setPoints(questionObj.getDouble("points"));
            
            // Store options as JSON string
            if (questionObj.has("options")) {
                question.setOptionsJson(questionObj.getJSONArray("options").toString());
            }
            
            questions.add(question);
        }
        
        return questions;
    }
    
    /**
     * Get exam metadata from JSON file
     */
    public static JSONObject getExamMetadata(String filePath) throws IOException {
        String content = new String(Files.readAllBytes(new File(filePath).toPath()));
        JSONObject examJson = new JSONObject(content);
        
        JSONObject metadata = new JSONObject();
        metadata.put("examTitle", examJson.optString("examTitle", ""));
        metadata.put("description", examJson.optString("description", ""));
        metadata.put("totalQuestions", examJson.optInt("totalQuestions", 0));
        metadata.put("durationMinutes", examJson.optInt("durationMinutes", 60));
        metadata.put("passScore", examJson.optDouble("passScore", 50.0));
        
        return metadata;
    }
    
    /**
     * Calculate score based on answers
     */
    public static double calculateScore(List<ExamQuestion> questions, JSONObject studentAnswers) {
        double totalScore = 0;
        double maxScore = 0;
        
        for (ExamQuestion question : questions) {
            maxScore += question.getPoints();
            
            String studentAnswer = studentAnswers.optString(String.valueOf(question.getQuestionNumber()));
            if (studentAnswer != null && studentAnswer.equalsIgnoreCase(question.getCorrectAnswer())) {
                totalScore += question.getPoints();
            }
        }
        
        // Return score as percentage
        return maxScore > 0 ? (totalScore / maxScore) * 100 : 0;
    }
    
    /**
     * Validate exam JSON structure
     */
    public static boolean validateExamJson(String content) {
        try {
            JSONObject examJson = new JSONObject(content);
            
            // Check required fields
            if (!examJson.has("examTitle") || !examJson.has("questions")) {
                return false;
            }
            
            JSONArray questions = examJson.getJSONArray("questions");
            if (questions.length() == 0) {
                return false;
            }
            
            // Validate each question
            for (int i = 0; i < questions.length(); i++) {
                JSONObject question = questions.getJSONObject(i);
                
                if (!question.has("questionNumber") || 
                    !question.has("questionText") ||
                    !question.has("correctAnswer")) {
                    return false;
                }
            }
            
            return true;
            
        } catch (Exception e) {
            return false;
        }
    }
}
