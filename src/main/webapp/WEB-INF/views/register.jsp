<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | Register</title>

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

<main class="register-main">
    <section class="register-wrap auth-container">
        <article class="register-card">
            <span class="auth-kicker">- Join the Community</span>
            <h2>Create your account</h2>
            <p class="auth-alt">Already a member? <a href="${pageContext.request.contextPath}/login">Sign in</a></p>

            <c:if test="${not empty error}">
                <div class="auth-alert auth-alert-error">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post" class="auth-form register-form">
                <label for="fullName">Full Name</label>
                <input id="fullName" name="fullName" type="text" placeholder="Elon Musk" required />

                <label for="email">Email</label>
                <input id="email" name="email" type="email" placeholder="you@example.com" required />

                <div class="form-grid-two">
                    <div>
                        <label for="password">Password</label>
                        <input id="password" name="password" type="password" placeholder="6+ characters" required />
                    </div>
                    <div>
                        <label for="confirmPassword">Confirm Password</label>
                        <input id="confirmPassword" name="confirmPassword" type="password" placeholder="Repeat password" required />
                    </div>
                </div>

                <div class="form-grid-two">
                    <div>
                        <label for="phone">Phone</label>
                        <input id="phone" name="phone" type="tel" placeholder="+9779812345678" inputmode="tel" maxlength="15" pattern="\+?[0-9]{7,14}" title="Enter a valid phone number (optional '+' and up to 14 digits)" oninput="this.value = this.value.replace(/(?!^\+)\D/g, ''); if (this.value.indexOf('+') > 0) { this.value = this.value.replace(/\+/g, ''); }" required />
                    </div>
                    <div>
                        <label for="sessionContactInfo">Session Contact</label>
                        <input id="sessionContactInfo" name="sessionContactInfo" type="text" placeholder="WhatsApp / Calendly / Discord" />
                    </div>
                </div>

                <button type="submit">Create Account</button>
            </form>
        </article>
    </section>
</main>
</body>
</html>
