<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | My Skills</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Outfit:wght@200;300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/my-skills.css" />
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
        <div class="container hero-head">
            <div>
                <p class="micro-label">- Teaching</p>
                <h1>My skills</h1>
                <p class="hero-subtitle">Skills you offer to the community.</p>
            </div>
            <a class="add-skill-btn" href="${ctx}/user/add-skill"><i class="ri-add-line"></i> Add New Skill</a>
        </div>
    </section>

    <section class="skills-shell">
        <div class="container">
            <c:if test="${not empty success}">
                <div class="form-alert form-alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="form-alert form-alert-error">${error}</div>
            </c:if>

            <c:choose>
                <c:when test="${not empty mySkills}">
                    <div class="skills-grid">
                        <c:forEach var="skill" items="${mySkills}">
                            <article class="skill-card">
                                <div class="card-top">
                                    <span class="tag-pill">
                                        <c:choose>
                                            <c:when test="${not empty categoryNames[skill.categoryId]}">${categoryNames[skill.categoryId]}</c:when>
                                            <c:otherwise>Category</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="price-mini">$${skill.price_per_10min}/10m</span>
                                </div>

                                <div class="card-body">
                                    <h2>${skill.title}</h2>
                                    <p>
                                        <c:choose>
                                            <c:when test="${not empty skill.description}">${skill.description}</c:when>
                                            <c:otherwise>No description added yet.</c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>

                                <div class="card-actions">
                                    <a href="${ctx}/user/edit-skill?id=${skill.skillId}"><i class="ri-edit-line"></i> Edit</a>
                                    <a href="${ctx}/user/my-skill-requests?skillId=${skill.skillId}"><i class="ri-inbox-archive-line"></i> Requests</a>
                                    <form action="${ctx}/user/my-skills" method="post" class="inline-form" onsubmit="return confirm('Delete this skill? This action cannot be undone.');">
                                        <input type="hidden" name="action" value="delete" />
                                        <input type="hidden" name="skillId" value="${skill.skillId}" />
                                        <button type="submit" class="skill-action-btn"><i class="ri-delete-bin-line"></i> Delete</button>
                                    </form>
                                </div>
                            </article>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <section class="empty-state-card">
                        <h2>You haven't posted a skill yet.</h2>
                        <p>Share what you know - even ten minutes helps.</p>
                        <a class="add-skill-btn" href="${ctx}/user/add-skill">Post Your First Skill</a>
                    </section>
                </c:otherwise>
            </c:choose>
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
