<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | Manage Categories</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Outfit:wght@200;300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css" />
</head>
<body class="admin-body admin-page admin-categories-page">
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="currentUser" value="${sessionScope.user}" />
<c:set var="displayName" value="${empty currentUser ? 'Admin' : currentUser.fullName}" />
<c:if test="${not empty currentUser and fn:contains(currentUser.fullName, ' ')}">
    <c:set var="displayName" value="${fn:substringBefore(currentUser.fullName, ' ')}" />
</c:if>
<c:set var="prefillCategoryName" value="${empty addCategoryName ? '' : addCategoryName}" />

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
                <a class="active" href="${ctx}/admin/categories"><i class="ri-price-tag-3-line"></i> Categories</a>
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
                <h1>Manage Categories</h1>
            </div>
            <div class="signed-in">
                <span>Signed In</span>
                <strong>${displayName}</strong>
            </div>
        </header>

        <nav class="admin-mobile-topnav" aria-label="Admin sections">
            <a href="${ctx}/admin/dashboard">Dashboard</a>
            <a href="${ctx}/admin/users">Users</a>
            <a class="active" href="${ctx}/admin/categories">Categories</a>
            <a href="${ctx}/admin/skills">Skills</a>
            <a href="${ctx}/admin/bookings">Bookings</a>
        </nav>

        <section class="categories-content">
            <div class="categories-grid">
                <section class="category-form-card">
                    <p class="admin-kicker">New Category</p>
                    <h2>Add Category</h2>

                    <c:if test="${not empty success}">
                        <div class="admin-alert admin-alert-success">${success}</div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="admin-alert admin-alert-error">${error}</div>
                    </c:if>

                    <form action="${ctx}/admin/categories" method="post" class="category-form-fields">
                        <input type="hidden" name="action" value="add" />
                        <input
                                type="text"
                                name="categoryName"
                                value="${prefillCategoryName}"
                                placeholder="e.g. Photography"
                                maxlength="100"
                                required
                        />
                        <p class="info-note">Add a category to organize skills.</p>
                        <button type="submit" class="category-add-btn">
                            <i class="ri-add-line"></i> Add
                        </button>
                    </form>
                </section>

                <section class="category-list-card">
                    <div class="panel-head">
                        <h2>All Categories</h2>
                    </div>
                    <div class="panel-table-wrap">
                        <table class="dashboard-table category-table">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Created</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${not empty categories}">
                                    <c:forEach var="category" items="${categories}">
                                        <tr>
                                            <td class="mono-id">${category.category}</td>
                                            <td class="name-col">${category.name}</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty category.createdAt}">${category.createdAt}</c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <form action="${ctx}/admin/categories" method="post" class="inline-form">
                                                    <input type="hidden" name="action" value="delete" />
                                                    <input type="hidden" name="categoryId" value="${category.category}" />
                                                    <button type="submit" class="action-btn action-btn-danger">
                                                        <i class="ri-delete-bin-line"></i> Delete
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="4" class="empty-row">No categories to display yet.</td>
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
