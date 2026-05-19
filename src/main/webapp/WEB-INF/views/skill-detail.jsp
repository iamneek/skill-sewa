<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | Skill Detail</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Outfit:wght@200;300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/skill-detail.css" />
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="currentUser" value="${sessionScope.user}" />
<c:set var="displayName" value="${empty currentUser ? 'Guest' : currentUser.fullName}" />
<c:if test="${not empty currentUser and fn:contains(currentUser.fullName, ' ')}">
    <c:set var="displayName" value="${fn:substringBefore(currentUser.fullName, ' ')}" />
</c:if>

<c:set var="skillTitle" value="${empty skillTitle ? 'Guitar' : skillTitle}" />
<c:set var="categoryName" value="${empty categoryName ? 'Art' : categoryName}" />
<c:set var="teacherName" value="${empty teacherName ? 'Neek' : teacherName}" />
<c:set var="skillDescription" value="${empty skillDescription ? 'asdf' : skillDescription}" />
<c:set var="pricePer10Value" value="${empty pricePer10 ? 5.0 : pricePer10}" />
<c:set var="hourPriceValue" value="${pricePer10Value * 6}" />
<c:set var="skillIdParam" value="${param.id}" />

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
    <section class="detail-shell">
        <div class="container detail-grid">
            <section class="skill-left">
                <a class="back-link" href="${ctx}/user/browse-skills"><i class="ri-arrow-left-line"></i> Back to Browse</a>

                <span class="category-pill">${categoryName}</span>
                <h1>${skillTitle}</h1>
                <p class="teacher-line"><i class="ri-user-line"></i> Taught by <strong>${teacherName}</strong></p>

                <div class="divider"></div>

                <p class="micro-label">- About this skill</p>
                <p class="about-copy">${skillDescription}</p>

                <div class="price-grid" data-price-per10="${pricePer10Value}">
                    <article>
                        <p class="price-label">Per 10 minutes</p>
                        <p class="price-main">$<span id="pricePer10Text">${pricePer10Value}</span></p>
                    </article>
                    <article>
                        <p class="price-label">Per hour</p>
                        <p class="price-main">$<span id="pricePerHourText">${hourPriceValue}</span></p>
                    </article>
                </div>
            </section>

            <section class="book-card" data-price-per10="${pricePer10Value}">
                <p class="micro-label">- Book this skill</p>
                <h2>Reserve a session</h2>

                <c:if test="${not empty success}">
                    <div class="form-alert form-alert-success">${success}</div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="form-alert form-alert-error">${error}</div>
                </c:if>

                <form class="book-form" action="${ctx}/user/skill-detail" method="post">
                    <input type="hidden" name="skillId" value="${skillIdParam}" />
                    <label for="duration">Duration</label>
                    <select id="duration" name="duration">
                        <option value="10">10 minutes</option>
                        <option value="20">20 minutes</option>
                        <option value="30" selected>30 minutes</option>
                        <option value="40">40 minutes</option>
                        <option value="50">50 minutes</option>
                        <option value="60">60 minutes</option>
                        <option value="70">70 minutes</option>
                        <option value="80">80 minutes</option>
                        <option value="90">90 minutes</option>
                        <option value="100">100 minutes</option>
                        <option value="110">110 minutes</option>
                        <option value="120">120 minutes</option>
                    </select>

                    <label for="message">Message to teacher (optional)</label>
                    <textarea id="message" name="message" rows="5" placeholder="Any learning goals or details?"></textarea>

                    <div class="form-divider"></div>

                    <div class="total-row">
                        <span>Total</span>
                        <strong>$<span id="totalAmount">15.00</span></strong>
                    </div>

                    <button type="submit" class="book-btn"><i class="ri-calendar-line"></i> Book Now</button>
                    <p class="help-note">You'll get teacher contact info after they accept and you pay.</p>
                </form>
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

<script>
    (function () {
        const wrapper = document.querySelector('.book-card');
        const duration = document.getElementById('duration');
        const totalAmount = document.getElementById('totalAmount');
        const pricePer10Text = document.getElementById('pricePer10Text');
        const pricePerHourText = document.getElementById('pricePerHourText');
        if (!wrapper || !duration || !totalAmount || !pricePer10Text || !pricePerHourText) {
            return;
        }

        const per10 = parseFloat(wrapper.getAttribute('data-price-per10')) || 0;
        pricePer10Text.textContent = per10.toFixed(2);
        pricePerHourText.textContent = (per10 * 6).toFixed(2);

        const updateTotal = function () {
            const mins = parseInt(duration.value, 10) || 0;
            const amount = (mins / 10) * per10;
            totalAmount.textContent = amount.toFixed(2);
        };

        duration.addEventListener('change', updateTotal);
        updateTotal();
    })();
</script>
</body>
</html>
