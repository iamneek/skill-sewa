<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | My Bookings</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Outfit:wght@200;300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/my-bookings.css" />
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="currentUser" value="${sessionScope.user}" />
<c:set var="displayName" value="${empty currentUser ? 'Guest' : currentUser.fullName}" />
<c:if test="${not empty currentUser and fn:contains(currentUser.fullName, ' ')}">
    <c:set var="displayName" value="${fn:substringBefore(currentUser.fullName, ' ')}" />
</c:if>
<c:set var="selectedStatus" value="${empty selectedStatus ? 'pending' : selectedStatus}" />
<c:set var="pendingCount" value="${empty pendingCount ? 0 : pendingCount}" />
<c:set var="acceptedCount" value="${empty acceptedCount ? 0 : acceptedCount}" />
<c:set var="rejectedCount" value="${empty rejectedCount ? 0 : rejectedCount}" />
<c:set var="completedCount" value="${empty completedCount ? 0 : completedCount}" />

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
        <div class="container">
            <p class="micro-label">- Learning</p>
            <h1>My bookings</h1>

            <div class="status-tabs">
                <a class="status-tab ${selectedStatus eq 'pending' ? 'active' : ''}" href="${ctx}/user/my-bookings?status=pending">Pending (${pendingCount})</a>
                <a class="status-tab ${selectedStatus eq 'accepted' ? 'active' : ''}" href="${ctx}/user/my-bookings?status=accepted">Accepted (${acceptedCount})</a>
                <a class="status-tab ${selectedStatus eq 'rejected' ? 'active' : ''}" href="${ctx}/user/my-bookings?status=rejected">Rejected (${rejectedCount})</a>
                <a class="status-tab ${selectedStatus eq 'completed' ? 'active' : ''}" href="${ctx}/user/my-bookings?status=completed">Completed (${completedCount})</a>
            </div>
        </div>
    </section>

    <section class="bookings-shell">
        <div class="container">
            <c:if test="${not empty success}">
                <div class="form-alert form-alert-success">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="form-alert form-alert-error">${error}</div>
            </c:if>

            <c:choose>
                <c:when test="${not empty bookings}">
                    <div class="booking-cards">
                        <c:forEach var="booking" items="${bookings}">
                            <article class="booking-card ${selectedStatus eq 'accepted' and not booking.paid ? 'with-action' : ''} ${selectedStatus eq 'accepted' and booking.paid ? 'paid' : ''}">
                                <div class="booking-main">
                                <div class="booking-top">
                                    <span class="status-pill ${selectedStatus}">${fn:toUpperCase(selectedStatus)}</span>
                                    <p class="booking-time">${booking.createdAt}</p>
                                </div>
                                <h2 class="booking-title">
                                    <c:choose>
                                        <c:when test="${not empty skillTitles[booking.skillId]}">${skillTitles[booking.skillId]}</c:when>
                                        <c:otherwise>Skill #${booking.skillId}</c:otherwise>
                                    </c:choose>
                                </h2>
                                <p class="booking-meta">
                                    w/
                                    <c:choose>
                                        <c:when test="${not empty teacherNames[booking.skillId]}">${teacherNames[booking.skillId]}</c:when>
                                        <c:otherwise>Teacher</c:otherwise>
                                    </c:choose>
                                    &middot; ${booking.durationMinutes}m &middot;
                                    <span class="booking-price">$${booking.totalPrice}</span>
                                </p>

                                <c:if test="${selectedStatus eq 'accepted' and not empty booking.acceptanceNote}">
                                    <div class="teacher-note-wrap">
                                        <p class="teacher-note-label">Teacher's Note</p>
                                        <p class="teacher-note">"${booking.acceptanceNote}"</p>
                                    </div>
                                </c:if>

                                <c:if test="${selectedStatus eq 'rejected' and not empty booking.rejectionNote}">
                                    <div class="teacher-note-wrap">
                                        <p class="teacher-note-label">Rejection Reason</p>
                                        <p class="teacher-note">"${booking.rejectionNote}"</p>
                                    </div>
                                </c:if>

                                <c:if test="${selectedStatus eq 'accepted' and booking.paid}">
                                    <div class="paid-awaiting-hint">
                                        <i class="ri-information-line"></i>
                                        Paid, waiting for teacher to mark completed.
                                    </div>
                                    <div class="contact-unlocked">
                                        <p class="contact-unlocked-label">- Contact unlocked</p>
                                        <div class="contact-items">
                                            <c:set var="contactValue" value="${teacherContacts[booking.bookingId]}" />
                                            <c:choose>
                                                <c:when test="${empty contactValue}">
                                                    <p><i class="ri-information-line"></i> Contact info not provided yet.</p>
                                                </c:when>
                                                <c:when test="${not empty contactValue and fn:contains(contactValue, '@')}">
                                                    <p><i class="ri-mail-line"></i> ${contactValue}</p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p><i class="ri-phone-line"></i> ${contactValue}</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </div>
                                </c:if>
                                </div>

                                <c:if test="${selectedStatus eq 'accepted' and not booking.paid}">
                                    <div class="booking-side">
                                        <a href="${ctx}/user/checkout?bookingId=${booking.bookingId}" class="pay-now-btn"><i class="ri-bank-card-line"></i> Pay Now</a>
                                    </div>
                                </c:if>
                            </article>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="empty-line">
                        <c:choose>
                            <c:when test="${selectedStatus eq 'accepted'}">No accepted bookings.</c:when>
                            <c:when test="${selectedStatus eq 'rejected'}">No rejected bookings.</c:when>
                            <c:when test="${selectedStatus eq 'completed'}">No completed bookings.</c:when>
                            <c:otherwise>No pending bookings.</c:otherwise>
                        </c:choose>
                    </p>
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
