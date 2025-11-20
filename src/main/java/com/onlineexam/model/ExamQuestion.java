package com.onlineexam.model;

import org.json.JSONArray;
import org.json.JSONObject;
import java.util.ArrayList;
import java.util.List;

public class ExamQuestion {
    private int questionId;
    private int examId;
    private int questionNumber;
    private String questionText;
    private QuestionType questionType;
    private String optionsJson;
    private String correctAnswer;
    private double points;
    
    public enum QuestionType {
        MULTIPLE_CHOICE, TRUE_FALSE
    }
    
    // Constructors
    public ExamQuestion() {
    }
    
    public ExamQuestion(int examId, int questionNumber, String questionText, 
                       QuestionType questionType, String optionsJson, String correctAnswer, double points) {
        this.examId = examId;
        this.questionNumber = questionNumber;
        this.questionText = questionText;
        this.questionType = questionType;
        this.optionsJson = optionsJson;
        this.correctAnswer = correctAnswer;
        this.points = points;
    }
    
    // Getters and Setters
    public int getQuestionId() {
        return questionId;
    }
    
    public void setQuestionId(int questionId) {
        this.questionId = questionId;
    }
    
    public int getExamId() {
        return examId;
    }
    
    public void setExamId(int examId) {
        this.examId = examId;
    }
    
    public int getQuestionNumber() {
        return questionNumber;
    }
    
    public void setQuestionNumber(int questionNumber) {
        this.questionNumber = questionNumber;
    }
    
    public String getQuestionText() {
        return questionText;
    }
    
    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }
    
    public QuestionType getQuestionType() {
        return questionType;
    }
    
    public void setQuestionType(QuestionType questionType) {
        this.questionType = questionType;
    }
    
    public String getOptionsJson() {
        return optionsJson;
    }
    
    public void setOptionsJson(String optionsJson) {
        this.optionsJson = optionsJson;
    }
    
    public String getCorrectAnswer() {
        return correctAnswer;
    }
    
    public void setCorrectAnswer(String correctAnswer) {
        this.correctAnswer = correctAnswer;
    }
    
    public double getPoints() {
        return points;
    }
    
    public void setPoints(double points) {
        this.points = points;
    }
    
    // Helper method to get options as a List for JSP
    public List<QuestionOption> getOptions() {
        List<QuestionOption> options = new ArrayList<>();
        if (optionsJson != null && !optionsJson.isEmpty()) {
            try {
                org.json.JSONArray jsonArray = new org.json.JSONArray(optionsJson);
                for (int i = 0; i < jsonArray.length(); i++) {
                    org.json.JSONObject jsonObj = jsonArray.getJSONObject(i);
                    QuestionOption option = new QuestionOption();
                    option.setOptionKey(jsonObj.getString("optionKey"));
                    option.setOptionText(jsonObj.getString("optionText"));
                    option.setCorrect(jsonObj.optBoolean("isCorrect", false));
                    options.add(option);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return options;
    }
    
    // Inner class for question options
    public static class QuestionOption {
        private String optionKey;
        private String optionText;
        private boolean isCorrect;
        
        public String getOptionKey() {
            return optionKey;
        }
        
        public void setOptionKey(String optionKey) {
            this.optionKey = optionKey;
        }
        
        public String getOptionText() {
            return optionText;
        }
        
        public void setOptionText(String optionText) {
            this.optionText = optionText;
        }
        
        public boolean isCorrect() {
            return isCorrect;
        }
        
        public void setCorrect(boolean correct) {
            isCorrect = correct;
        }
    }
    
    @Override
    public String toString() {
        return "ExamQuestion{" +
                "questionId=" + questionId +
                ", examId=" + examId +
                ", questionNumber=" + questionNumber +
                ", questionText='" + questionText + '\'' +
                ", questionType=" + questionType +
                ", points=" + points +
                '}';
    }
}
