package com.inception.skillsewa.utils;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;

public class CookieUtils {
    public static void setUserCookie(HttpServletResponse resp, String email) {
        Cookie cookie = new Cookie("userEmail", email);
        cookie.setMaxAge(10 * 24 * 60 * 60);
        cookie.setPath("/");
        resp.addCookie(cookie);
    }

    public static void clearUserCookie(HttpServletResponse resp) {
        Cookie cookie = new Cookie("userEmail", "");
        cookie.setMaxAge(0);
        cookie.setPath("/");
        resp.addCookie(cookie);
    }
}
