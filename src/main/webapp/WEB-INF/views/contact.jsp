<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | Contact</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Outfit:wght@200;300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/info-page.css" />
</head>
<body>
<main class="info-shell">
    <section class="info-card">
        <p class="info-kicker">- Contact us</p>
        <h1>We are here to help</h1>
        <p>For support, feedback, or any issue with bookings, send us an email and we will get back to you.</p>

        <div class="contact-lines">
            <p><strong>Email:</strong> support@skillsewa.com</p>
            <p><strong>Phone:</strong> +977 9800000000</p>
        </div>

        <div class="info-actions">
            <a class="info-btn primary" href="${pageContext.request.contextPath}/">Go Home</a>
            <a class="info-btn" href="${pageContext.request.contextPath}/about">About us</a>
        </div>
    </section>
</main>
</body>
</html>
