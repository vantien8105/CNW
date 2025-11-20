package com.onlineexam.servlet;

import com.onlineexam.dao.*;
import com.onlineexam.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.*;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.List;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/teacher/exams")
public class ExamServlet extends HttpServlet {
    private ExamDAO examDAO;
    private CourseDAO courseDAO;
    private ExamQuestionDAO questionDAO;
    
    @Override
    public void init() throws ServletException {
        examDAO = new ExamDAO();
        courseDAO = new CourseDAO();
        questionDAO = new ExamQuestionDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Teacher teacher = (Teacher) session.getAttribute("teacher");
        
        if (user == null || teacher == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        String courseIdStr = request.getParameter("courseId");
        
        try {
            if ("create".equals(action)) {
                // Show create exam form
                List<Course> courses = courseDAO.getCoursesByTeacher(teacher.getTeacherId());
                request.setAttribute("courses", courses);
                request.getRequestDispatcher("/teacher/create-exam.jsp").forward(request, response);
            } else if (courseIdStr != null) {
                // Show exams for specific course
                int courseId = Integer.parseInt(courseIdStr);
                Course course = courseDAO.getCourseById(courseId);
                List<Exam> exams = examDAO.getExamsByCourse(courseId);
                
                request.setAttribute("course", course);
                request.setAttribute("exams", exams);
                request.getRequestDispatcher("/teacher/exams.jsp").forward(request, response);
            } else {
                // Show all exams for this teacher
                List<Course> courses = courseDAO.getCoursesByTeacher(teacher.getTeacherId());
                request.setAttribute("courses", courses);
                request.getRequestDispatcher("/teacher/all-exams.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        Teacher teacher = (Teacher) session.getAttribute("teacher");
        
        if (user == null || teacher == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        
        try {
            String action = request.getParameter("action");
            
            if ("create".equals(action)) {
                createExam(request, response, teacher);
            } else if ("delete".equals(action)) {
                deleteExam(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("Database error", e);
        }
    }
    
    private void createExam(HttpServletRequest request, HttpServletResponse response, Teacher teacher) 
            throws SQLException, IOException {
        try {
            System.out.println("=== Starting exam creation ===");
            
            int courseId = Integer.parseInt(request.getParameter("courseId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            int duration = Integer.parseInt(request.getParameter("duration"));
            double passingScore = Double.parseDouble(request.getParameter("passingScore"));
            String startTimeStr = request.getParameter("startTime");
            String endTimeStr = request.getParameter("endTime");
            String examTemplate = request.getParameter("examTemplate");
            
            System.out.println("Course ID: " + courseId);
            System.out.println("Title: " + title);
            System.out.println("Duration: " + duration);
            System.out.println("Template: " + examTemplate);
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            java.time.LocalDateTime startTime = java.time.LocalDateTime.parse(startTimeStr, 
                java.time.format.DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            java.time.LocalDateTime endTime = java.time.LocalDateTime.parse(endTimeStr, 
                java.time.format.DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            
            // Create exam
            Exam exam = new Exam();
            exam.setCourseId(courseId);
            exam.setExamTitle(title);
            exam.setDescription(description);
            exam.setExamFilePath(examTemplate != null ? examTemplate : ""); // Set template file path
            exam.setDurationMinutes(duration);
            exam.setStartTime(startTime);
            exam.setEndTime(endTime);
            exam.setPassScore(passingScore);
            exam.setCreatedBy(teacher.getTeacherId());
            exam.setTotalQuestions(0); // Will be updated after importing questions
            exam.setActive(true);
            
            int examId = examDAO.createExam(exam);
            
            System.out.println("Created exam with ID: " + examId);
            
            // Import questions from JSON template if specified
            if (examTemplate != null && !examTemplate.isEmpty() && !examTemplate.equals("none")) {
                System.out.println("Importing questions from template: " + examTemplate);
                importQuestionsFromTemplate(examId, examTemplate);
            } else {
                System.out.println("No template selected, exam created without questions");
            }
            
            System.out.println("=== Exam creation completed successfully ===");
            response.sendRedirect(request.getContextPath() + "/teacher/exams?courseId=" + courseId);
        } catch (Exception e) {
            System.err.println("=== ERROR creating exam ===");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/teacher/exams?action=create&error=1");
        }
    }
    
    private void importQuestionsFromTemplate(int examId, String templateFile) throws IOException, SQLException {
        // Read JSON file from database folder (in project root)
        String projectRoot = getServletContext().getRealPath("/");
        
        // Navigate up to project root and into database folder
        File file = new File(projectRoot, "../../../database/" + templateFile);
        
        if (!file.exists()) {
            // Try alternative paths
            file = new File(System.getProperty("user.dir"), "database/" + templateFile);
        }
        
        if (!file.exists()) {
            System.err.println("Template file not found: " + templateFile);
            System.err.println("Tried paths:");
            System.err.println("  - " + new File(projectRoot, "../../../database/" + templateFile).getAbsolutePath());
            System.err.println("  - " + new File(System.getProperty("user.dir"), "database/" + templateFile).getAbsolutePath());
            return;
        }
        
        System.out.println("Reading template from: " + file.getAbsolutePath());
        
        // Read file content
        StringBuilder content = new StringBuilder();
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            String line;
            while ((line = reader.readLine()) != null) {
                content.append(line);
            }
        }
        
        // Parse JSON and create questions
        JSONObject jsonData = new JSONObject(content.toString());
        JSONArray questions = jsonData.getJSONArray("questions");
        
        int totalPoints = 0;
        for (int i = 0; i < questions.length(); i++) {
            JSONObject q = questions.getJSONObject(i);
            
            // Build options JSON
            JSONArray options = q.getJSONArray("options");
            String correctAnswer = "";
            
            for (int j = 0; j < options.length(); j++) {
                JSONObject opt = options.getJSONObject(j);
                if (opt.getBoolean("isCorrect")) {
                    correctAnswer = opt.getString("optionKey");
                    break;
                }
            }
            
            // Create question
            ExamQuestion question = new ExamQuestion();
            question.setExamId(examId);
            question.setQuestionNumber(q.getInt("questionNumber"));
            question.setQuestionText(q.getString("questionText"));
            question.setQuestionType(ExamQuestion.QuestionType.valueOf(q.getString("questionType")));
            question.setOptionsJson(options.toString());
            question.setCorrectAnswer(correctAnswer);
            question.setPoints(q.getDouble("points"));
            
            questionDAO.createQuestion(question);
            totalPoints += q.getDouble("points");
        }
        
        System.out.println("Imported " + questions.length() + " questions from template: " + templateFile);
        
        // Update exam with total questions
        Exam exam = examDAO.getExamById(examId);
        if (exam != null) {
            exam.setTotalQuestions(questions.length());
            examDAO.updateExam(exam);
        }
    }
    
    private void deleteExam(HttpServletRequest request, HttpServletResponse response) 
            throws SQLException, IOException {
        int examId = Integer.parseInt(request.getParameter("examId"));
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        
        examDAO.deleteExam(examId);
        response.sendRedirect(request.getContextPath() + "/teacher/exams?courseId=" + courseId);
    }
}
