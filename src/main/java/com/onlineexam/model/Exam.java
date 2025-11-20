package com.onlineexam.model;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class Exam {
    private int examId;
    private int courseId;
    private String examTitle;
    private String description;
    private String examFilePath;
    private int durationMinutes;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private int totalQuestions;
    private double passScore;
    private Timestamp createdAt;
    private int createdBy;
    private boolean isActive;
    
    // Additional fields
    private Course course;
    private Teacher teacher;
    private int submissionCount;
    private boolean isSubmitted;
    
    // Constructors
    public Exam() {
    }
    
    public Exam(int courseId, String examTitle, String examFilePath, int durationMinutes,
                LocalDateTime startTime, LocalDateTime endTime, int totalQuestions, int createdBy) {
        this.courseId = courseId;
        this.examTitle = examTitle;
        this.examFilePath = examFilePath;
        this.durationMinutes = durationMinutes;
        this.startTime = startTime;
        this.endTime = endTime;
        this.totalQuestions = totalQuestions;
        this.createdBy = createdBy;
        this.passScore = 50.0;
        this.isActive = true;
    }
    
    // Helper methods
    public boolean isAvailable() {
        LocalDateTime now = LocalDateTime.now();
        return isActive && now.isAfter(startTime) && now.isBefore(endTime);
    }
    
    public boolean isUpcoming() {
        return isActive && LocalDateTime.now().isBefore(startTime);
    }
    
    public boolean isExpired() {
        return !isActive || LocalDateTime.now().isAfter(endTime);
    }
    
    // Getters and Setters
    public int getExamId() {
        return examId;
    }
    
    public void setExamId(int examId) {
        this.examId = examId;
    }
    
    public int getCourseId() {
        return courseId;
    }
    
    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }
    
    public String getExamTitle() {
        return examTitle;
    }
    
    public void setExamTitle(String examTitle) {
        this.examTitle = examTitle;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getExamFilePath() {
        return examFilePath;
    }
    
    public void setExamFilePath(String examFilePath) {
        this.examFilePath = examFilePath;
    }
    
    public int getDurationMinutes() {
        return durationMinutes;
    }
    
    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }
    
    public LocalDateTime getStartTime() {
        return startTime;
    }
    
    public void setStartTime(LocalDateTime startTime) {
        this.startTime = startTime;
    }
    
    public LocalDateTime getEndTime() {
        return endTime;
    }
    
    public void setEndTime(LocalDateTime endTime) {
        this.endTime = endTime;
    }
    
    public int getTotalQuestions() {
        return totalQuestions;
    }
    
    public void setTotalQuestions(int totalQuestions) {
        this.totalQuestions = totalQuestions;
    }
    
    public double getPassScore() {
        return passScore;
    }
    
    public void setPassScore(double passScore) {
        this.passScore = passScore;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    public int getCreatedBy() {
        return createdBy;
    }
    
    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }
    
    public boolean isActive() {
        return isActive;
    }
    
    public void setActive(boolean active) {
        isActive = active;
    }
    
    public Course getCourse() {
        return course;
    }
    
    public void setCourse(Course course) {
        this.course = course;
    }
    
    public Teacher getTeacher() {
        return teacher;
    }
    
    public void setTeacher(Teacher teacher) {
        this.teacher = teacher;
    }
    
    public int getSubmissionCount() {
        return submissionCount;
    }
    
    public void setSubmissionCount(int submissionCount) {
        this.submissionCount = submissionCount;
    }
    
    public boolean isSubmitted() {
        return isSubmitted;
    }
    
    public void setSubmitted(boolean submitted) {
        isSubmitted = submitted;
    }
    
    @Override
    public String toString() {
        return "Exam{" +
                "examId=" + examId +
                ", courseId=" + courseId +
                ", examTitle='" + examTitle + '\'' +
                ", durationMinutes=" + durationMinutes +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", totalQuestions=" + totalQuestions +
                ", isActive=" + isActive +
                '}';
    }
}
