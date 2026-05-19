<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | Browse Skills</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Outfit:wght@200;300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/browse-skills.css" />
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="currentUser" value="${sessionScope.user}" />
<c:set var="displayName" value="${empty currentUser ? '' : currentUser.fullName}" />
<c:if test="${not empty currentUser and fn:contains(currentUser.fullName, ' ')}">
    <c:set var="displayName" value="${fn:substringBefore(currentUser.fullName, ' ')}" />
</c:if>

<c:set var="searchQuery" value="${param.q}" />

<header class="site-header">
    <div class="container nav-shell">
        <a class="brand" href="${ctx}/">
            <img src="${ctx}/assets/images/skillsewa-logo.svg" alt="Skill Sewa" class="brand-logo" />
        </a>

        <nav class="main-nav">
            <a href="${ctx}/">Home</a>
            <a class="active" href="${ctx}/user/browse-skills">Browse</a>
            <a href="${ctx}/user/dashboard">Dashboard</a>
        </nav>

        <div class="nav-right">
            <c:choose>
                <c:when test="${not empty currentUser}">
                    <a class="user-name" href="${ctx}/user/profile"><i class="ri-user-line"></i> ${displayName}</a>
                    <a class="logout-link" href="${ctx}/logout"><i class="ri-logout-box-r-line"></i> Logout</a>
                </c:when>
                <c:otherwise>
                    <a class="login-link" href="${ctx}/login">Login</a>
                    <a class="join-btn" href="${ctx}/register">Join Sewa</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<main>
    <section class="browse-hero">
        <div class="container">
            <p class="micro-label">- The Directory</p>
            <h1>Browse skills</h1>

            <form class="search-wrap" action="${ctx}/user/browse-skills" method="get">
                <input type="hidden" name="category" value="${empty selectedCategoryId ? 'all' : selectedCategoryId}" />
                <i class="ri-search-line"></i>
                <input type="text" name="q" value="${searchQuery}" placeholder="Search skills, e.g. 'guitar' or 'python' ..." />
            </form>

            <div class="chip-row">
                <a class="chip ${empty selectedCategoryId ? 'active' : ''}" href="${ctx}/user/browse-skills?category=all&q=${searchQuery}">All</a>
                <c:forEach var="category" items="${categories}">
                    <a class="chip ${selectedCategoryId eq category.category ? 'active' : ''}" href="${ctx}/user/browse-skills?category=${category.category}&q=${searchQuery}">${category.name}</a>
                </c:forEach>
            </div>
        </div>
    </section>

    <section class="skills-section">
        <div class="container">
            <div class="skills-grid">
                <c:choose>
                    <c:when test="${not empty skills}">
                        <c:forEach var="skill" items="${skills}">
                            <article class="skill-card">
                                <div class="card-top">
                                    <span class="tag-pill">
                                        <c:choose>
                                            <c:when test="${not empty categoryNames[skill.categoryId]}">${categoryNames[skill.categoryId]}</c:when>
                                            <c:otherwise>Category</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <span class="slot"><i class="ri-time-line"></i> 10M</span>
                                </div>
                                <div class="card-body">
                                    <h2>${skill.title}</h2>
                                    <p class="desc">
                                        <c:choose>
                                            <c:when test="${not empty skill.description}">${skill.description}</c:when>
                                            <c:otherwise>No description available.</c:otherwise>
                                        </c:choose>
                                    </p>

                                    <div class="meta-row">
                                        <div>
                                            <p class="meta-label">Teacher</p>
                                            <p class="meta-value">
                                                <c:choose>
                                                    <c:when test="${not empty teacherNames[skill.teacherId]}">${teacherNames[skill.teacherId]}</c:when>
                                                    <c:otherwise>${skill.teacherId}</c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                        <div class="price-box">
                                            <p class="meta-label">Per 10m</p>
                                            <p class="price">$${skill.price_per_10min}</p>
                                        </div>
                                    </div>
                                </div>
                                <a class="card-cta" href="${ctx}/user/skill-detail?id=${skill.skillId}">
                                    <span>View &amp; Book</span>
                                    <i class="ri-arrow-right-up-line"></i>
                                </a>
                            </article>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <article class="skill-empty-card">
                            <div class="empty-icon-wrap">
                                <i class="ri-search-line"></i>
                            </div>
                            <h2>No skills have been registered</h2>
                            <p>Try again later or adjust your search and category filters.</p>
                        </article>
                    </c:otherwise>
                </c:choose>
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
