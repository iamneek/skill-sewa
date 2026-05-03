<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | Manage Users</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Outfit:wght@200;300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css" />
</head>
<body class="admin-body admin-page admin-users-page">
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
                <a class="active" href="${ctx}/admin/users"><i class="ri-user-line"></i> Users</a>
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
                <h1>Manage Users</h1>
            </div>
            <div class="signed-in">
                <span>Signed In</span>
                <strong>${displayName}</strong>
            </div>
        </header>

        <nav class="admin-mobile-topnav" aria-label="Admin sections">
            <a href="${ctx}/admin/dashboard">Dashboard</a>
            <a class="active" href="${ctx}/admin/users">Users</a>
            <a href="${ctx}/admin/categories">Categories</a>
            <a href="${ctx}/admin/skills">Skills</a>
            <a href="${ctx}/admin/bookings">Bookings</a>
        </nav>

        <section class="users-panel">
            <c:if test="${not empty success}">
                <div class="admin-alert admin-alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="admin-alert admin-alert-error">${error}</div>
            </c:if>

            <div class="search-row">
                <i class="ri-search-line"></i>
                <input id="userSearch" type="text" placeholder="Search name or email..." />
            </div>

            <div class="table-wrap">
                <table>
                    <thead>
                    <tr>
                        <th class="user-id-col">ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody id="usersTableBody">
                    <c:choose>
                        <c:when test="${not empty users}">
                            <c:forEach var="user" items="${users}">
                                <tr>
                                    <td class="user-id-col">${user.userId}</td>
                                    <td class="name-col">${user.fullName}</td>
                                    <td>${user.email}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${empty user.phone}">-</c:when>
                                            <c:otherwise>${user.phone}</c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td class="status-col">
                                        <div class="status-wrap">
                                            <c:choose>
                                                <c:when test="${user.suspended}">
                                                    <span class="status-pill suspended">SUSPENDED</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-pill active">ACTIVE</span>
                                                </c:otherwise>
                                            </c:choose>

                                            <c:if test="${user.role eq 'admin'}">
                                                <span class="role-pill">ADMIN</span>
                                            </c:if>
                                        </div>
                                    </td>
                                    <td class="actions-col">
                                        <c:choose>
                                            <c:when test="${not empty currentUser and user.userId eq currentUser.userId}">
                                                <span class="self-account-label">Current account</span>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="actions-wrap">
                                                    <button type="button" class="user-actions-toggle" aria-label="Open actions">
                                                        <i class="ri-more-2-fill"></i>
                                                    </button>

                                                    <form action="${ctx}/admin/users" method="post" class="inline-form">
                                                        <input type="hidden" name="action" value="toggleSuspend" />
                                                        <input type="hidden" name="userId" value="${user.userId}" />
                                                        <input type="hidden" name="suspend" value="${not user.suspended}" />
                                                        <button type="submit" class="action-btn action-btn-success">
                                                            <i class="ri-forbid-line"></i>
                                                            <c:choose>
                                                                <c:when test="${user.suspended}">UNSUSPEND</c:when>
                                                                <c:otherwise>SUSPEND</c:otherwise>
                                                            </c:choose>
                                                        </button>
                                                    </form>

                                                    <form action="${ctx}/admin/users" method="post" class="inline-form">
                                                        <input type="hidden" name="action" value="delete" />
                                                        <input type="hidden" name="userId" value="${user.userId}" />
                                                        <button type="submit" class="action-btn action-btn-danger">
                                                            <i class="ri-delete-bin-line"></i> DELETE
                                                        </button>
                                                    </form>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="6" class="empty-row">No users found.</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                    </tbody>
                </table>
            </div>
        </section>
    </main>
</div>

<script>
    const actionToggles = document.querySelectorAll(".user-actions-toggle");
    actionToggles.forEach((toggle) => {
        toggle.addEventListener("click", (event) => {
            event.stopPropagation();
            const rowActions = toggle.closest(".actions-wrap");
            if (rowActions) {
                rowActions.classList.toggle("is-open");
            }
        });
    });

    document.addEventListener("click", () => {
        document.querySelectorAll(".actions-wrap.is-open").forEach((rowActions) => {
            rowActions.classList.remove("is-open");
        });
    });

    const searchInput = document.getElementById("userSearch");
    const tableBody = document.getElementById("usersTableBody");

    if (searchInput && tableBody) {
        searchInput.addEventListener("input", () => {
            const query = searchInput.value.trim().toLowerCase();
            const rows = tableBody.querySelectorAll("tr");

            rows.forEach((row) => {
                if (row.querySelector(".empty-row")) {
                    return;
                }

                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(query) ? "" : "none";
            });
        });
    }
</script>
</body>
</html>
