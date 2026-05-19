<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | Post a Skill</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Outfit:wght@200;300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/add-skill.css" />
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="currentUser" value="${sessionScope.user}" />
<c:set var="displayName" value="${empty currentUser ? 'Guest' : currentUser.fullName}" />
<c:if test="${not empty currentUser and fn:contains(currentUser.fullName, ' ')}">
    <c:set var="displayName" value="${fn:substringBefore(currentUser.fullName, ' ')}" />
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
    <section class="hero-strip">
        <div class="container hero-inner">
            <a class="back-link" href="${ctx}/user/my-skills"><i class="ri-arrow-left-line"></i> Back</a>
            <p class="micro-label">- New</p>
            <h1>Post a skill</h1>
        </div>
    </section>

    <section class="form-shell">
        <div class="container">
            <form class="skill-form" action="${ctx}/user/add-skill" method="post">
                <c:if test="${not empty success}">
                    <div class="form-alert form-alert-success">${success}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="form-alert form-alert-error">${error}</div>
                </c:if>

                <label for="title">Title</label>
                <input id="title" name="title" type="text" maxlength="150" value="${formTitle}" placeholder="e.g. Acoustic guitar fundamentals" required />

                <label for="categoryId">Category</label>
                <select id="categoryId" name="categoryId" required>
                    <c:forEach var="category" items="${categories}">
                        <option value="${category.category}" ${formCategoryId eq category.category ? 'selected' : ''}>${category.name}</option>
                    </c:forEach>
                </select>

                <label for="description">Description</label>
                <textarea id="description" name="description" maxlength="2000" rows="8" placeholder="Describe what you'll teach...">${formDescription}</textarea>

                <label for="pricePer10">Price per 10 minutes (USD)</label>
                <input id="pricePer10" name="pricePer10" type="number" min="0.01" max="9999" step="0.01" value="${empty formPrice ? '5.00' : formPrice}" required />

                <div class="form-actions">
                    <button type="submit" class="publish-btn">Publish Skill</button>
                    <a href="${ctx}/user/my-skills" class="cancel-btn">Cancel</a>
                </div>
            </form>
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
