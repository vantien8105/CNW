package com.onlineexam.util;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filter to check authentication for protected pages
 */
public class AuthenticationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Allow access to login page, logout, and static resources
        if (uri.endsWith("login.jsp") || 
            uri.endsWith("login") || 
            uri.endsWith("logout") ||
            uri.contains("/css/") ||
            uri.contains("/js/") ||
            uri.contains("/images/")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Check if user is logged in
        if (session == null || !SessionUtil.isLoggedIn(session)) {
            httpResponse.sendRedirect(contextPath + "/login.jsp");
            return;
        }
        
        // Check role-based access
        if (uri.contains("/student/")) {
            if (!SessionUtil.isStudent(session)) {
                httpResponse.sendRedirect(contextPath + "/teacher/dashboard");
                return;
            }
        } else if (uri.contains("/teacher/")) {
            if (!SessionUtil.isTeacher(session)) {
                httpResponse.sendRedirect(contextPath + "/student/dashboard");
                return;
            }
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
