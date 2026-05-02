<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | Login</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Outfit:wght@200;300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css" />
</head>
<body>
<header class="auth-topbar">
    <div class="auth-container">
        <a class="auth-brand" href="${pageContext.request.contextPath}/">
            <img src="${pageContext.request.contextPath}/assets/images/skillsewa-logo.svg" alt="Skill Sewa" class="auth-logo" />
        </a>
    </div>
</header>

<main class="auth-main">
    <section class="auth-split auth-container">
        <div class="auth-left">
            <span class="auth-kicker">- Welcome Back</span>
            <h1>The teacher <span>remembered.</span></h1>
            <p>Pick up where you left off. Your skills, your bookings, your community.</p>
        </div>

        <div class="auth-right">
            <article class="auth-card">
                <span class="auth-kicker">- Login</span>
                <h2>Sign in</h2>
                <p class="auth-alt">No account? <a href="${pageContext.request.contextPath}/register">Create one</a></p>

                <c:if test="${not empty error}">
                    <div class="auth-alert auth-alert-error">${error}</div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post" class="auth-form">
                    <label for="email">Email</label>
                    <input id="email" name="email" type="email" placeholder="you@example.com" required />

                    <label for="password">Password</label>
                    <input id="password" name="password" type="password" placeholder="........" required />

                    <button type="submit">Sign In</button>
                </form>
            </article>
        </div>
    </section>
</main>
</body>
</html>
