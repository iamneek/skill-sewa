<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | Manage Skills</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Outfit:wght@200;300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css" />
</head>
<body class="admin-body admin-page admin-skills-page">
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
                <a class="active" href="${ctx}/admin/skills"><i class="ri-book-open-line"></i> Skills</a>
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
                <h1>Skills</h1>
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
            <a class="active" href="${ctx}/admin/skills">Skills</a>
            <a href="${ctx}/admin/bookings">Bookings</a>
        </nav>

        <section class="skills-content">
            <div class="skills-panel">
                <c:if test="${not empty success}">
                    <div class="admin-alert admin-alert-success">${success}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="admin-alert admin-alert-error">${error}</div>
                </c:if>

                <form action="${ctx}/admin/skills" method="get" class="skills-filter-row">
                    <label for="skillCategoryFilter">Filter</label>
                    <select id="skillCategoryFilter" name="category" onchange="this.form.submit()">
                        <option value="">All Categories</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.category}" ${selectedCategoryId eq category.category ? 'selected' : ''}>${category.name}</option>
                        </c:forEach>
                    </select>
                </form>

                <div class="panel-table-wrap">
                    <table class="dashboard-table skills-table">
                        <thead>
                        <tr>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Teacher</th>
                            <th>Per 10m</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:choose>
                            <c:when test="${not empty skills}">
                                <c:forEach var="skill" items="${skills}">
                                     <tr>
                                         <td class="name-col">${skill.title}</td>
                                        <td>
                                            <span class="skill-cat-pill">
                                                <c:choose>
                                                    <c:when test="${not empty categoryNames[skill.categoryId]}">${categoryNames[skill.categoryId]}</c:when>
                                                    <c:otherwise>#${skill.categoryId}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td>${skill.teacherId}</td>
                                        <td class="price-col">$${skill.price_per_10min}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${skill.active}">
                                                    <span class="status-pill active">ACTIVE</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-pill suspended">INACTIVE</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="actions-wrap">
                                                <form action="${ctx}/admin/skills" method="post" class="inline-form">
                                                    <input type="hidden" name="action" value="toggle" />
                                                    <input type="hidden" name="skillId" value="${skill.skillId}" />
                                                    <input type="hidden" name="isActive" value="${not skill.active}" />
                                                    <c:if test="${not empty selectedCategoryId}">
                                                        <input type="hidden" name="category" value="${selectedCategoryId}" />
                                                    </c:if>
                                                    <button type="submit" class="action-btn action-btn-success">
                                                        <i class="ri-refresh-line"></i>
                                                        <c:choose>
                                                            <c:when test="${skill.active}">Deactivate</c:when>
                                                            <c:otherwise>Activate</c:otherwise>
                                                        </c:choose>
                                                    </button>
                                                </form>

                                                <form action="${ctx}/admin/skills" method="post" class="inline-form">
                                                    <input type="hidden" name="action" value="delete" />
                                                    <input type="hidden" name="skillId" value="${skill.skillId}" />
                                                    <c:if test="${not empty selectedCategoryId}">
                                                        <input type="hidden" name="category" value="${selectedCategoryId}" />
                                                    </c:if>
                                                    <button type="submit" class="action-btn action-btn-danger">
                                                        <i class="ri-delete-bin-line"></i> Delete
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6" class="empty-row">No skills to display.</td>
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
