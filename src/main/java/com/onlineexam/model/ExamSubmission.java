package com.onlineexam.model;

import java.sql.Timestamp;

public class ExamSubmission {
    private int submissionId;
    private int examId;
    private int studentId;
    private String answersJson;
    private double score;
    private Timestamp submittedAt;
    private int timeTakenMinutes;
    private boolean isPassed;
    
    // Additional fields
    private Exam exam;
    private Student student;
    private String studentCode;
    private String studentName;
    
    // Constructors
    public ExamSubmission() {
    }
    
    public ExamSubmission(int examId, int studentId, String answersJson, double score, int timeTakenMinutes) {
        this.examId = examId;
        this.studentId = studentId;
        this.answersJson = answersJson;
        this.score = score;
        this.timeTakenMinutes = timeTakenMinutes;
    }
    
    // Getters and Setters
    public int getSubmissionId() {
        return submissionId;
    }
    
    public void setSubmissionId(int submissionId) {
        this.submissionId = submissionId;
    }
    
    public int getExamId() {
        return examId;
    }
    
    public void setExamId(int examId) {
        this.examId = examId;
    }
    
    public int getStudentId() {
        return studentId;
    }
    
    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }
    
    public String getAnswersJson() {
        return answersJson;
    }
    
    public void setAnswersJson(String answersJson) {
        this.answersJson = answersJson;
    }
    
    public double getScore() {
        return score;
    }
    
    public void setScore(double score) {
        this.score = score;
    }
    
    public Timestamp getSubmittedAt() {
        return submittedAt;
    }
    
    public void setSubmittedAt(Timestamp submittedAt) {
        this.submittedAt = submittedAt;
    }
    
    public int getTimeTakenMinutes() {
        return timeTakenMinutes;
    }
    
    public void setTimeTakenMinutes(int timeTakenMinutes) {
        this.timeTakenMinutes = timeTakenMinutes;
    }
    
    public boolean isPassed() {
        return isPassed;
    }
    
    public void setPassed(boolean passed) {
        isPassed = passed;
    }
    
    public Exam getExam() {
        return exam;
    }
    
    public void setExam(Exam exam) {
        this.exam = exam;
    }
    
    public Student getStudent() {
        return student;
    }
    
    public void setStudent(Student student) {
        this.student = student;
    }
    
    public String getStudentCode() {
        return studentCode;
    }
    
    public void setStudentCode(String studentCode) {
        this.studentCode = studentCode;
    }
    
    public String getStudentName() {
        return studentName;
    }
    
    public void setStudentName(String studentName) {
        this.studentName = studentName;
    }
    
    @Override
    public String toString() {
        return "ExamSubmission{" +
                "submissionId=" + submissionId +
                ", examId=" + examId +
                ", studentId=" + studentId +
                ", score=" + score +
                ", submittedAt=" + submittedAt +
                ", timeTakenMinutes=" + timeTakenMinutes +
                ", isPassed=" + isPassed +
                '}';
    }
}
