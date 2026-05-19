package com.inception.skillsewa.filter;

import com.inception.skillsewa.utils.SessionUtils;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        Filter.super.init(filterConfig);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        String url = req.getRequestURI();

        boolean isPublicPath = url.contains("/login") || url.contains("/register") || url.contains("/css") ||
                url.contains("/js") || url.endsWith(".ico") || url.contains("/assets") || url.equals(req.getContextPath() + "/")
                || url.equals(req.getContextPath() + "/login") || url.equals(req.getContextPath()) || url.contains("/user/browse-skills")
                || url.equals(req.getContextPath() + "/about") || url.equals(req.getContextPath() + "/contact");

        if (isPublicPath){
            chain.doFilter(request, response);
            return;
        }

        boolean isLoggedIn = SessionUtils.isLoggedIn(req);
        if(!isLoggedIn) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if(url.contains("/admin") && !SessionUtils.isAdmin(req)) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        Filter.super.destroy();
    }
}
