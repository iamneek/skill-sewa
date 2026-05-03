<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | Manage Bookings</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Outfit:wght@200;300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css" />
</head>
<body class="admin-body admin-page admin-bookings-page">
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="currentUser" value="${sessionScope.user}" />
<c:set var="displayName" value="${empty currentUser ? 'Admin' : currentUser.fullName}" />
<c:if test="${not empty currentUser and fn:contains(currentUser.fullName, ' ')}">
    <c:set var="displayName" value="${fn:substringBefore(currentUser.fullName, ' ')}" />
</c:if>

<div class="admin-layout">
    <aside class="admin-sidebar">
        <div>
            <a class="sidebar-brand" href="${ctx}/">
                <img src="${ctx}/assets/images/skillsewa-logo-light.svg" alt="Skill Sewa" />
            </a>
            <p class="sidebar-subtitle">/ Admin Console</p>

            <nav class="sidebar-nav">
                <a href="${ctx}/admin/dashboard"><i class="ri-dashboard-line"></i> Dashboard</a>
                <a href="${ctx}/admin/users"><i class="ri-user-line"></i> Users</a>
                <a href="${ctx}/admin/categories"><i class="ri-price-tag-3-line"></i> Categories</a>
                <a href="${ctx}/admin/skills"><i class="ri-book-open-line"></i> Skills</a>
                <a class="active" href="${ctx}/admin/bookings"><i class="ri-file-list-3-line"></i> Bookings</a>
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
                <h1>Bookings</h1>
            </div>
            <div class="signed-in">
                <span>Signed In</span>
                <strong>${displayName}</strong>
            </div>
        </header>

        <nav class="admin-mobile-topnav" aria-label="Admin sections">
            <a href="${ctx}/admin/dashboard">Dashboard</a>
            <a href="${ctx}/admin/users">Users</a>
            <a href="${ctx}/admin/categories">Categories</a>
            <a href="${ctx}/admin/skills">Skills</a>
            <a class="active" href="${ctx}/admin/bookings">Bookings</a>
        </nav>

        <section class="bookings-content">
            <div class="bookings-panel">
                <c:if test="${not empty success}">
                    <div class="admin-alert admin-alert-success">${success}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="admin-alert admin-alert-error">${error}</div>
                </c:if>

                <form action="${ctx}/admin/bookings" method="get" class="bookings-filter-row">
                    <label for="bookingStatusFilter">Filter</label>
                    <select id="bookingStatusFilter" name="status" onchange="this.form.submit()">
                        <option value="">All Statuses</option>
                        <option value="accepted" ${selectedStatus eq 'accepted' ? 'selected' : ''}>Accepted</option>
                        <option value="pending" ${selectedStatus eq 'pending' ? 'selected' : ''}>Pending</option>
                        <option value="rejected" ${selectedStatus eq 'rejected' ? 'selected' : ''}>Rejected</option>
                    </select>
                </form>

                <div class="panel-table-wrap">
                    <table class="dashboard-table bookings-table">
                        <thead>
                            <tr>
                                <th>Learner</th>
                                <th>Skill</th>
                                <th>Teacher</th>
                                <th>Duration</th>
                                <th>Price</th>
                                <th>Status</th>
                                <th>Date</th>
                            </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty bookings}">
                                <c:forEach var="booking" items="${bookings}">
                                    <c:set var="bookingStatus" value="${empty booking.status ? 'PENDING' : booking.status}" />
                                    <c:set var="statusClass" value="pending" />
                                    <c:if test="${fn:toLowerCase(bookingStatus) eq 'accepted'}">
                                        <c:set var="statusClass" value="accepted" />
                                    </c:if>
                                    <c:if test="${fn:toLowerCase(bookingStatus) eq 'rejected'}">
                                        <c:set var="statusClass" value="rejected" />
                                    </c:if>
                                    <tr>
                                        <td class="name-col">${booking.learnerId}</td>
                                        <c:set var="skillTitle" value="${skillTitles[booking.skillId]}" />
                                        <td>
                                            <span class="skill-title-cell" title="${empty skillTitle ? booking.skillId : skillTitle}">
                                                <c:choose>
                                                    <c:when test="${not empty skillTitle}">${skillTitle}</c:when>
                                                    <c:otherwise>Skill #${booking.skillId}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>-</td>
                                        <td>${booking.durationMinutes}m</td>
                                        <td class="price-col">$${booking.totalPrice}</td>
                                        <td><span class="booking-status ${statusClass}">${bookingStatus}</span></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty booking.createdAt}">${booking.createdAt}</c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="7" class="empty-row">No bookings to display.</td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>
    </main>
</div>
</body>
</html>
