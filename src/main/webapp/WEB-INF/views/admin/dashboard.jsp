<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | Admin Dashboard</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Outfit:wght@200;300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css" />
</head>
<body class="admin-body admin-page admin-dashboard-page">
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="currentUser" value="${sessionScope.user}" />
<c:set var="displayName" value="${empty currentUser ? 'Admin' : currentUser.fullName}" />
<c:if test="${not empty currentUser and fn:contains(currentUser.fullName, ' ')}">
    <c:set var="displayName" value="${fn:substringBefore(currentUser.fullName, ' ')}" />
</c:if>

<c:set var="totalUsersValue" value="${empty totalUsers ? 0 : totalUsers}" />
<c:set var="totalSkillsValue" value="${empty totalSkills ? 0 : totalSkills}" />
<c:set var="totalBookingsValue" value="${empty totalBookings ? 0 : totalBookings}" />
<c:set var="pendingBookingsValue" value="${empty pendingBookings ? 0 : pendingBookings}" />

<div class="admin-layout">
    <aside class="admin-sidebar">
        <div>
            <a class="sidebar-brand" href="${ctx}/">
                <img src="${ctx}/assets/images/skillsewa-logo-light.svg" alt="Skill Sewa" />
            </a>
            <p class="sidebar-subtitle">/ Admin Console</p>

            <nav class="sidebar-nav">
                <a class="active" href="${ctx}/admin/dashboard"><i class="ri-dashboard-line"></i> Dashboard</a>
                <a href="${ctx}/admin/users"><i class="ri-user-line"></i> Users</a>
                <a href="${ctx}/admin/categories"><i class="ri-price-tag-3-line"></i> Categories</a>
                <a href="${ctx}/admin/skills"><i class="ri-book-open-line"></i> Skills</a>
                <a href="${ctx}/admin/bookings"><i class="ri-file-list-3-line"></i> Bookings</a>
            </nav>
        </div>

        <div class="sidebar-bottom">
            <a href="${ctx}/" class="view-site">View Site <i class="ri-arrow-right-up-line"></i></a>
            <a href="${ctx}/logout" class="logout-btn"><i class="ri-logout-box-r-line"></i> Logout</a>
        </div>
    </aside>

    <main class="admin-main">
        <header class="admin-top">
            <div>
                <p class="admin-kicker">Admin Console</p>
                <h1>Dashboard</h1>
            </div>
            <div class="signed-in">
                <span>Signed In</span>
                <strong>${displayName}</strong>
            </div>
        </header>

        <nav class="admin-mobile-topnav" aria-label="Admin sections">
            <a class="active" href="${ctx}/admin/dashboard">Dashboard</a>
            <a href="${ctx}/admin/users">Users</a>
            <a href="${ctx}/admin/categories">Categories</a>
            <a href="${ctx}/admin/skills">Skills</a>
            <a href="${ctx}/admin/bookings">Bookings</a>
        </nav>

        <section class="dashboard-content">
            <div class="metrics-grid">
                <article class="metric-card">
                    <div class="metric-head">
                        <p class="metric-label">Total Users</p>
                        <i class="ri-user-3-line"></i>
                    </div>
                    <p class="metric-value">${totalUsersValue}</p>
                </article>

                <article class="metric-card">
                    <div class="metric-head">
                        <p class="metric-label">Total Skills</p>
                        <i class="ri-book-open-line"></i>
                    </div>
                    <p class="metric-value">${totalSkillsValue}</p>
                </article>

                <article class="metric-card">
                    <div class="metric-head">
                        <p class="metric-label">Total Bookings</p>
                        <i class="ri-clipboard-line"></i>
                    </div>
                    <p class="metric-value">${totalBookingsValue}</p>
                </article>

                <article class="metric-card pending-card">
                    <div class="metric-head">
                        <p class="metric-label">Pending</p>
                        <i class="ri-hourglass-line"></i>
                    </div>
                    <p class="metric-value">${pendingBookingsValue}</p>
                </article>
            </div>

            <div class="dashboard-tables">
                <section class="dashboard-panel">
                    <div class="panel-head">
                        <h2>Recent Users</h2>
                        <a href="${ctx}/admin/users" class="panel-link">View All</a>
                    </div>
                    <div class="panel-table-wrap">
                        <table class="dashboard-table">
                            <thead>
                            <tr>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Status</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty recentUsers}">
                                    <c:forEach var="user" items="${recentUsers}" varStatus="loop">
                                        <c:if test="${loop.count le 5}">
                                            <tr>
                                                <td class="name-col">${user.fullName}</td>
                                                <td>${user.email}</td>
                                                <td class="user-role">${user.role}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.suspended}">
                                                            <span class="status-pill suspended">SUSPENDED</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-pill active">ACTIVE</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="empty-row">No recent users available.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </section>

                <section class="dashboard-panel">
                    <div class="panel-head">
                        <h2>Recent Bookings</h2>
                        <a href="${ctx}/admin/bookings" class="panel-link">View All</a>
                    </div>
                    <div class="panel-table-wrap">
                        <table class="dashboard-table">
                            <thead>
                            <tr>
                                <th>Skill</th>
                                <th>Learner</th>
                                <th>Status</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty recentBookings}">
                                    <c:forEach var="booking" items="${recentBookings}" varStatus="loop">
                                        <c:if test="${loop.count le 5}">
                                            <c:set var="bookingStatus" value="${empty booking.status ? 'PENDING' : booking.status}" />
                                            <c:set var="statusClass" value="pending" />
                                            <c:if test="${fn:toLowerCase(bookingStatus) eq 'accepted'}">
                                                <c:set var="statusClass" value="accepted" />
                                            </c:if>
                                            <c:if test="${fn:toLowerCase(bookingStatus) eq 'rejected'}">
                                                <c:set var="statusClass" value="rejected" />
                                            </c:if>
                                            <tr>
                                                <c:set var="skillTitle" value="${skillTitles[booking.skillId]}" />
                                                <td>
                                                    <span class="skill-title-cell" title="${empty skillTitle ? booking.skillId : skillTitle}">
                                                        <c:choose>
                                                            <c:when test="${not empty skillTitle}">${skillTitle}</c:when>
                                                            <c:otherwise>Skill #${booking.skillId}</c:otherwise>
                                                        </c:choose>
                                                    </span>
                                                </td>
                                                <td>${booking.learnerId}</td>
                                                <td>
                                                    <span class="booking-status ${statusClass}">${bookingStatus}</span>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="3" class="empty-row">No recent bookings available.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                </section>
            </div>
        </section>
    </main>
</div>
</body>
</html>
