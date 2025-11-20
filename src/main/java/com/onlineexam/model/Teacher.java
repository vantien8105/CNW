package com.onlineexam.model;

public class Teacher {
    private int teacherId;
    private int userId;
    private String teacherCode;
    private String department;
    private String title;
    
    // Additional fields from User
    private User user;
    
    // Constructors
    public Teacher() {
    }
    
    public Teacher(int userId, String teacherCode, String department, String title) {
        this.userId = userId;
        this.teacherCode = teacherCode;
        this.department = department;
        this.title = title;
    }
    
    // Getters and Setters
    public int getTeacherId() {
        return teacherId;
    }
    
    public void setTeacherId(int teacherId) {
        this.teacherId = teacherId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getTeacherCode() {
        return teacherCode;
    }
    
    public void setTeacherCode(String teacherCode) {
        this.teacherCode = teacherCode;
    }
    
    public String getDepartment() {
        return department;
    }
    
    public void setDepartment(String department) {
        this.department = department;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    
    @Override
    public String toString() {
        return "Teacher{" +
                "teacherId=" + teacherId +
                ", userId=" + userId +
                ", teacherCode='" + teacherCode + '\'' +
                ", department='" + department + '\'' +
                ", title='" + title + '\'' +
                '}';
    }
}
