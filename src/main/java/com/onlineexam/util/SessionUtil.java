package com.onlineexam.util;

import com.onlineexam.model.User;
import com.onlineexam.model.Student;
import com.onlineexam.model.Teacher;
import javax.servlet.http.HttpSession;

public class SessionUtil {
    
    // Session attribute keys
    public static final String USER_KEY = "user";
    public static final String STUDENT_KEY = "student";
    public static final String TEACHER_KEY = "teacher";
    public static final String USER_TYPE_KEY = "userType";
    
    /**
     * Set user in session
     */
    public static void setUser(HttpSession session, User user) {
        session.setAttribute(USER_KEY, user);
        session.setAttribute(USER_TYPE_KEY, user.getUserType().toString());
    }
    
    /**
     * Get user from session
     */
    public static User getUser(HttpSession session) {
        return (User) session.getAttribute(USER_KEY);
    }
    
    /**
     * Set student in session
     */
    public static void setStudent(HttpSession session, Student student) {
        session.setAttribute(STUDENT_KEY, student);
    }
    
    /**
     * Get student from session
     */
    public static Student getStudent(HttpSession session) {
        return (Student) session.getAttribute(STUDENT_KEY);
    }
    
    /**
     * Set teacher in session
     */
    public static void setTeacher(HttpSession session, Teacher teacher) {
        session.setAttribute(TEACHER_KEY, teacher);
    }
    
    /**
     * Get teacher from session
     */
    public static Teacher getTeacher(HttpSession session) {
        return (Teacher) session.getAttribute(TEACHER_KEY);
    }
    
    /**
     * Check if user is logged in
     */
    public static boolean isLoggedIn(HttpSession session) {
        return session.getAttribute(USER_KEY) != null;
    }
    
    /**
     * Check if user is student
     */
    public static boolean isStudent(HttpSession session) {
        User user = getUser(session);
        return user != null && user.getUserType() == User.UserType.STUDENT;
    }
    
    /**
     * Check if user is teacher
     */
    public static boolean isTeacher(HttpSession session) {
        User user = getUser(session);
        return user != null && user.getUserType() == User.UserType.TEACHER;
    }
    
    /**
     * Clear session (logout)
     */
    public static void clearSession(HttpSession session) {
        session.removeAttribute(USER_KEY);
        session.removeAttribute(STUDENT_KEY);
        session.removeAttribute(TEACHER_KEY);
        session.removeAttribute(USER_TYPE_KEY);
        session.invalidate();
    }
    
    /**
     * Get user ID from session
     */
    public static Integer getUserId(HttpSession session) {
        User user = getUser(session);
        return user != null ? user.getUserId() : null;
    }
    
    /**
     * Get student ID from session
     */
    public static Integer getStudentId(HttpSession session) {
        Student student = getStudent(session);
        return student != null ? student.getStudentId() : null;
    }
    
    /**
     * Get teacher ID from session
     */
    public static Integer getTeacherId(HttpSession session) {
        Teacher teacher = getTeacher(session);
        return teacher != null ? teacher.getTeacherId() : null;
    }
}
