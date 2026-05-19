<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | Page Not Found</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Outfit:wght@200;300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/error.css" />
</head>
<body>
<main class="error-shell">
    <section class="error-card">
        <p class="error-kicker">- Not found</p>
        <h1 class="error-title">404</h1>
        <p class="error-subtitle">The page you are looking for does not exist or has been moved.</p>

        <div class="error-actions">
            <a class="error-btn primary" href="${pageContext.request.contextPath}/">Go Home</a>
            <a class="error-btn" href="${pageContext.request.contextPath}/user/browse-skills">Browse Skills</a>
        </div>

        <details class="error-details">
            <summary>Request details</summary>
            <div class="error-meta">
                <p><strong>Status</strong>${requestScope['jakarta.servlet.error.status_code']}</p>
                <p><strong>Path</strong>${requestScope['jakarta.servlet.error.request_uri']}</p>
                <p><strong>Message</strong>${requestScope['jakarta.servlet.error.message']}</p>
            </div>
        </details>
    </section>
</main>
</body>
</html>
