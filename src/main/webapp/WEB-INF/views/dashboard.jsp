<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | Dashboard</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Outfit:wght@200;300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user-dashboard.css" />
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="currentUser" value="${sessionScope.user}" />
<c:set var="displayName" value="${empty currentUser ? 'Guest' : currentUser.fullName}" />
<c:if test="${not empty currentUser and fn:contains(currentUser.fullName, ' ')}">
    <c:set var="displayName" value="${fn:substringBefore(currentUser.fullName, ' ')}" />
</c:if>

<c:set var="skillsPostedCount" value="${empty skillsPostedCount ? 0 : skillsPostedCount}" />
<c:set var="bookingsMadeCount" value="${empty bookingsMadeCount ? 0 : bookingsMadeCount}" />
<c:set var="sessionsCompletedCount" value="${empty sessionsCompletedCount ? 0 : sessionsCompletedCount}" />

<header class="site-header user-dash-header">
    <div class="container nav-shell">
        <a class="brand" href="${ctx}/">
            <img src="${ctx}/assets/images/skillsewa-logo.svg" alt="Skill Sewa" class="brand-logo" />
        </a>

        <nav class="main-nav">
            <a href="${ctx}/">Home</a>
            <a href="${ctx}/user/browse-skills">Browse</a>
            <a class="active" href="${ctx}/user/dashboard">Dashboard</a>
        </nav>

        <div class="nav-right">
            <a class="user-name" href="${ctx}/user/profile"><i class="ri-user-line"></i> ${displayName}</a>
            <a class="logout-link" href="${ctx}/logout"><i class="ri-logout-box-r-line"></i> Logout</a>
        </div>
    </div>
</header>

<main class="dashboard-main">
    <section class="hero-strip">
        <div class="container">
            <p class="micro-label">- Welcome back, ${displayName}</p>
            <h1>Your studio</h1>

            <div class="metrics-grid">
                <article class="metric-card">
                    <div class="metric-head">
                        <p class="metric-label">Skills Posted</p>
                        <i class="ri-book-open-line"></i>
                    </div>
                    <p class="metric-value">${skillsPostedCount}</p>
                </article>

                <article class="metric-card">
                    <div class="metric-head">
                        <p class="metric-label">Bookings Made</p>
                        <i class="ri-search-line"></i>
                    </div>
                    <p class="metric-value">${bookingsMadeCount}</p>
                </article>

                <article class="metric-card">
                    <div class="metric-head">
                        <p class="metric-label">Sessions Completed</p>
                        <i class="ri-checkbox-circle-line"></i>
                    </div>
                    <p class="metric-value">${sessionsCompletedCount}</p>
                </article>
            </div>

            <div class="quick-actions">
                <a class="action-btn primary" href="${ctx}/user/add-skill"><i class="ri-add-line"></i> Post a Skill</a>
                <a class="action-btn" href="${ctx}/user/browse-skills"><i class="ri-search-line"></i> Browse Skills</a>
                <a class="action-btn" href="${ctx}/user/my-skills"><i class="ri-book-open-line"></i> My Skills</a>
                <a class="action-btn" href="${ctx}/user/my-bookings"><i class="ri-archive-line"></i> My Bookings</a>
            </div>
        </div>
    </section>

    <section class="boards-strip">
        <div class="container boards-grid">
            <section class="dash-panel">
                <div class="panel-head">
                    <h2>My Recent Bookings</h2>
                    <a href="${ctx}/user/my-bookings">View All</a>
                </div>
                <div class="panel-body">
                    <c:choose>
                        <c:when test="${not empty recentBookings}">
                            <ul class="booking-list">
                                <c:forEach var="booking" items="${recentBookings}" varStatus="loop">
                                    <c:if test="${loop.count le 4}">
                                        <c:set var="bookingStatus" value="${empty booking.status ? 'PENDING' : booking.status}" />
                                        <li>
                                            <div>
                                                <p class="list-title">
                                                    <c:choose>
                                                        <c:when test="${not empty skillTitles[booking.skillId]}">${skillTitles[booking.skillId]}</c:when>
                                                        <c:otherwise>Skill #${booking.skillId}</c:otherwise>
                                                    </c:choose>
                                                </p>
                                                <p class="list-meta">${booking.durationMinutes}m</p>
                                            </div>
                                            <span class="booking-status ${fn:toLowerCase(bookingStatus)}">${bookingStatus}</span>
                                        </li>
                                    </c:if>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <p class="empty-note">No bookings yet. <a href="${ctx}/user/browse-skills">Browse skills &rarr;</a></p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>

            <section class="dash-panel">
                <div class="panel-head">
                    <h2>Recent Requests (As Teacher)</h2>
                    <a href="${ctx}/user/my-skill-requests">Manage</a>
                </div>
                <div class="panel-body">
                    <c:choose>
                        <c:when test="${not empty teacherRequests}">
                            <ul class="booking-list">
                                <c:forEach var="booking" items="${teacherRequests}" varStatus="loop">
                                    <c:if test="${loop.count le 4}">
                                        <c:set var="bookingStatus" value="${empty booking.status ? 'PENDING' : booking.status}" />
                                        <li>
                                            <div>
                                                <p class="list-title">
                                                    <c:choose>
                                                        <c:when test="${not empty skillTitles[booking.skillId]}">${skillTitles[booking.skillId]}</c:when>
                                                        <c:otherwise>Skill #${booking.skillId}</c:otherwise>
                                                    </c:choose>
                                                </p>
                                                <p class="list-meta">
                                                    from
                                                    <c:choose>
                                                        <c:when test="${not empty learnerNames[booking.learnerId]}">${learnerNames[booking.learnerId]}</c:when>
                                                        <c:otherwise>${booking.learnerId}</c:otherwise>
                                                    </c:choose>
                                                    &middot; ${booking.durationMinutes}m
                                                </p>
                                            </div>
                                            <span class="booking-status ${fn:toLowerCase(bookingStatus)}">${bookingStatus}</span>
                                        </li>
                                    </c:if>
                                </c:forEach>
                            </ul>
                        </c:when>
                        <c:otherwise>
                            <p class="empty-note">No pending requests as teacher yet.</p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
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
