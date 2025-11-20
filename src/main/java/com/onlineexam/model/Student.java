package com.onlineexam.model;

public class Student {
    private int studentId;
    private int userId;
    private String studentCode;
    private String major;
    private int yearOfStudy;
    
    // Additional fields from User
    private User user;
    
    // Constructors
    public Student() {
    }
    
    public Student(int userId, String studentCode, String major, int yearOfStudy) {
        this.userId = userId;
        this.studentCode = studentCode;
        this.major = major;
        this.yearOfStudy = yearOfStudy;
    }
    
    // Getters and Setters
    public int getStudentId() {
        return studentId;
    }
    
    public void setStudentId(int studentId) {
        this.studentId = studentId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getStudentCode() {
        return studentCode;
    }
    
    public void setStudentCode(String studentCode) {
        this.studentCode = studentCode;
    }
    
    public String getMajor() {
        return major;
    }
    
    public void setMajor(String major) {
        this.major = major;
    }
    
    public int getYearOfStudy() {
        return yearOfStudy;
    }
    
    public void setYearOfStudy(int yearOfStudy) {
        this.yearOfStudy = yearOfStudy;
    }
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    
    @Override
    public String toString() {
        return "Student{" +
                "studentId=" + studentId +
                ", userId=" + userId +
                ", studentCode='" + studentCode + '\'' +
                ", major='" + major + '\'' +
                ", yearOfStudy=" + yearOfStudy +
                '}';
    }
}
