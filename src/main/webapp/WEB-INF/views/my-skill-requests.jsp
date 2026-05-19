<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | Booking Requests</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Outfit:wght@200;300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/my-bookings.css" />
</head>
<body class="teacher-requests-page">
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
            <a class="back-link" href="${ctx}/user/my-skills"><i class="ri-arrow-left-line"></i> Back to My Skills</a>
            <p class="micro-label">- Inbox</p>
            <h1>Booking requests</h1>

            <div class="status-tabs">
                <a class="status-tab ${selectedStatus eq 'pending' ? 'active' : ''}" href="${ctx}/user/my-skill-requests?status=pending">Pending (${pendingCount})</a>
                <a class="status-tab ${selectedStatus eq 'accepted' ? 'active' : ''}" href="${ctx}/user/my-skill-requests?status=accepted">Accepted (${acceptedCount})</a>
                <a class="status-tab ${selectedStatus eq 'rejected' ? 'active' : ''}" href="${ctx}/user/my-skill-requests?status=rejected">Rejected (${rejectedCount})</a>
                <a class="status-tab ${selectedStatus eq 'completed' ? 'active' : ''}" href="${ctx}/user/my-skill-requests?status=completed">Completed (${completedCount})</a>
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
                <c:when test="${not empty requests}">
                    <div class="booking-cards">
                        <c:forEach var="booking" items="${requests}">
                            <article class="booking-card teacher-request-card">
                                <div class="request-content">
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
                                        From
                                        <c:choose>
                                            <c:when test="${not empty learnerNames[booking.learnerId]}">${learnerNames[booking.learnerId]}</c:when>
                                            <c:otherwise>${booking.learnerId}</c:otherwise>
                                        </c:choose>
                                        &middot; ${booking.durationMinutes}m &middot;
                                        <span class="booking-price">$${booking.totalPrice}</span>
                                    </p>
                                    <c:if test="${selectedStatus eq 'accepted'}">
                                        <p class="payment-status-line">
                                            <span class="payment-pill ${booking.paid ? 'paid' : 'unpaid'}">${booking.paid ? 'Paid' : 'Unpaid'}</span>
                                        </p>
                                    </c:if>
                                    <c:if test="${not empty booking.message}">
                                        <p class="request-message">"${booking.message}"</p>
                                    </c:if>
                                </div>

                                <c:if test="${selectedStatus eq 'pending'}">
                                    <div class="request-actions">
                                        <form action="${ctx}/user/my-skill-requests" method="post" class="inline-form">
                                            <input type="hidden" name="action" value="accept" />
                                            <input type="hidden" name="bookingId" value="${booking.bookingId}" />
                                            <input type="hidden" name="status" value="${selectedStatus}" />
                                            <button type="button" class="request-btn accept-btn js-decision-btn" data-action-label="Accept request" data-required-note="false">✓ Accept</button>
                                            <input type="hidden" name="note" value="" />
                                        </form>
                                        <form action="${ctx}/user/my-skill-requests" method="post" class="inline-form">
                                            <input type="hidden" name="action" value="reject" />
                                            <input type="hidden" name="bookingId" value="${booking.bookingId}" />
                                            <input type="hidden" name="status" value="${selectedStatus}" />
                                            <button type="button" class="request-btn reject-btn js-decision-btn" data-action-label="Reject request" data-required-note="true">✕ Reject</button>
                                            <input type="hidden" name="note" value="" />
                                        </form>
                                    </div>
                                </c:if>

                                <c:if test="${selectedStatus eq 'accepted'}">
                                    <div class="request-actions">
                                        <c:if test="${booking.paid}">
                                            <form action="${ctx}/user/my-skill-requests" method="post" class="inline-form">
                                                <input type="hidden" name="action" value="complete" />
                                                <input type="hidden" name="bookingId" value="${booking.bookingId}" />
                                                <input type="hidden" name="status" value="${selectedStatus}" />
                                                <button type="submit" class="request-btn complete-btn"><i class="ri-check-double-line"></i> Mark Completed</button>
                                            </form>
                                        </c:if>
                                    </div>
                                </c:if>
                            </article>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="empty-line">No ${selectedStatus} requests.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </section>
</main>

<div id="decisionModal" class="decision-modal" hidden>
    <div class="decision-modal-overlay" data-close-modal="true"></div>
    <div class="decision-modal-card" role="dialog" aria-modal="true" aria-labelledby="decisionModalTitle">
        <p class="decision-modal-kicker">- Request note</p>
        <h3 id="decisionModalTitle">Update request</h3>
        <p id="decisionModalHelp" class="decision-modal-help"></p>
        <textarea id="decisionNote" class="decision-modal-input" rows="5" maxlength="500" placeholder="Write your note..."></textarea>
        <p id="decisionModalError" class="decision-modal-error" hidden>Please add a note before continuing.</p>
        <div class="decision-modal-actions">
            <button type="button" id="decisionCancel" class="request-btn reject-btn">Cancel</button>
            <button type="button" id="decisionSubmit" class="request-btn accept-btn">Confirm</button>
        </div>
    </div>
</div>

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

<script>
    (function () {
        const modal = document.getElementById('decisionModal');
        const modalTitle = document.getElementById('decisionModalTitle');
        const modalHelp = document.getElementById('decisionModalHelp');
        const noteInput = document.getElementById('decisionNote');
        const errorLine = document.getElementById('decisionModalError');
        const cancelBtn = document.getElementById('decisionCancel');
        const submitBtn = document.getElementById('decisionSubmit');
        const triggerButtons = document.querySelectorAll('.js-decision-btn');
        let activeForm = null;
        let noteRequired = false;

        function closeModal() {
            modal.hidden = true;
            errorLine.hidden = true;
            noteInput.value = '';
            activeForm = null;
            noteRequired = false;
        }

        triggerButtons.forEach((button) => {
            button.addEventListener('click', () => {
                activeForm = button.closest('form');
                noteRequired = button.dataset.requiredNote === 'true';
                const actionLabel = button.dataset.actionLabel || 'Update request';
                const existingNoteInput = activeForm.querySelector('input[name="note"]');

                modalTitle.textContent = actionLabel;
                modalHelp.textContent = noteRequired
                    ? 'Add a reason for the learner. This note is required.'
                    : 'Add an optional note for the learner.';
                noteInput.value = existingNoteInput ? existingNoteInput.value : '';
                submitBtn.textContent = noteRequired ? 'Reject request' : 'Accept request';
                errorLine.hidden = true;
                modal.hidden = false;
                noteInput.focus();
            });
        });

        cancelBtn.addEventListener('click', closeModal);
        modal.addEventListener('click', (event) => {
            if (event.target && event.target.dataset.closeModal === 'true') {
                closeModal();
            }
        });

        document.addEventListener('keydown', (event) => {
            if (event.key === 'Escape' && !modal.hidden) {
                closeModal();
            }
        });

        submitBtn.addEventListener('click', () => {
            if (!activeForm) {
                closeModal();
                return;
            }

            const noteValue = noteInput.value.trim();
            if (noteRequired && noteValue.length === 0) {
                errorLine.hidden = false;
                noteInput.focus();
                return;
            }

            const noteField = activeForm.querySelector('input[name="note"]');
            if (noteField) {
                noteField.value = noteValue;
            }
            activeForm.submit();
        });
    })();
</script>
</body>
</html>
