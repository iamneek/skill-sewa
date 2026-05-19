<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | Profile</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Outfit:wght@200;300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/profile.css" />
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="profile" value="${profileUser}" />
<c:set var="displayName" value="${empty profile ? 'User' : profile.fullName}" />
<c:if test="${not empty profile and fn:contains(profile.fullName, ' ')}">
    <c:set var="displayName" value="${fn:substringBefore(profile.fullName, ' ')}" />
</c:if>
<c:set var="avatarChar" value="U" />
<c:if test="${not empty displayName}">
    <c:set var="avatarChar" value="${fn:toUpperCase(fn:substring(displayName, 0, 1))}" />
</c:if>

<header class="site-header">
    <div class="container nav-shell">
        <a class="brand" href="${ctx}/">
            <img src="${ctx}/assets/images/skillsewa-logo.svg" alt="Skill Sewa" class="brand-logo" />
        </a>

        <nav class="main-nav">
            <a href="${ctx}/">Home</a>
            <a href="${ctx}/user/browse-skills">Browse</a>
            <a href="${ctx}/user/dashboard">Dashboard</a>
        </nav>

        <div class="nav-right">
            <a class="user-name" href="${ctx}/user/profile"><i class="ri-user-line"></i> ${displayName}</a>
            <a class="logout-link" href="${ctx}/logout"><i class="ri-logout-box-r-line"></i> Logout</a>
        </div>
    </div>
</header>

<main>
    <section class="profile-hero">
        <div class="container profile-head-wrap">
            <div class="avatar-block">${avatarChar}</div>
            <div>
                <p class="micro-label">- Account</p>
                <h1>${displayName}</h1>
                <p class="profile-email">${profile.email}</p>
            </div>
        </div>
    </section>

    <section class="profile-shell">
        <div class="container">
            <c:if test="${not empty success}">
                <div class="form-alert form-alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="form-alert form-alert-error">${error}</div>
            </c:if>

            <div class="profile-grid">
                <article class="profile-card">
                    <p class="section-label">- Edit profile</p>
                    <form method="post" action="${ctx}/user/profile" class="profile-form">
                        <input type="hidden" name="action" value="profile" />

                        <label for="fullName">Full name</label>
                        <input id="fullName" name="fullName" type="text" value="${profile.fullName}" required />

                        <label for="phone">Phone</label>
                        <input id="phone" name="phone" type="text" value="${profile.phone}" required />

                        <label for="sessionContactInfo">Session contact</label>
                        <input id="sessionContactInfo" name="sessionContactInfo" type="text" value="${profile.sessionContactInfo}" placeholder="WhatsApp / Telegram / Discord" />

                        <button type="submit" class="filled-btn">Save changes</button>
                    </form>
                </article>

                <article class="profile-card">
                    <p class="section-label">- Change password</p>
                    <form method="post" action="${ctx}/user/profile" class="profile-form">
                        <input type="hidden" name="action" value="password" />

                        <label for="currentPassword">Current password</label>
                        <input id="currentPassword" name="currentPassword" type="password" required />

                        <label for="newPassword">New password</label>
                        <input id="newPassword" name="newPassword" type="password" required />

                        <label for="confirmPassword">Confirm new password</label>
                        <input id="confirmPassword" name="confirmPassword" type="password" required />

                        <button type="submit" class="plain-btn">Update password</button>
                    </form>
                </article>
            </div>
        </div>
    </section>
</main>

<footer class="site-footer">
    <div class="container footer-grid minimal-footer">
        <div>
            <a class="brand footer-brand" href="${ctx}/">
                <img src="${ctx}/assets/images/skillsewa-logo.svg" alt="Skill Sewa" class="brand-logo" />
            </a>
            <p>A community of teachers &amp; learners.<br />Selfless service, ten minutes at a time.</p>
        </div>
        <div>
            <h4>DISCOVER</h4>
            <ul class="footer-links">
                <li><a href="${ctx}/user/browse-skills">Browse Skills</a></li>
                <li><a href="${ctx}/user/add-skill">Become a Teacher</a></li>
            </ul>
        </div>
        <div>
            <h4>ACCOUNT</h4>
            <ul class="footer-links">
                <li><a href="${ctx}/about">About Us</a></li>
                <li><a href="${ctx}/contact">Contact Us</a></li>
            </ul>
        </div>
        <div>
            <h4>MADE WITH CARE</h4>
            <ul class="footer-links">
                <li><small>&copy; 2026 Skill Sewa. All rights reserved.</small></li>
            </ul>
        </div>
    </div>
</footer>
</body>
</html>
