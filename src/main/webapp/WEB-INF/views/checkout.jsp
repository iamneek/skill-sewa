<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | Checkout</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Outfit:wght@200;300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/checkout.css" />
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="currentUser" value="${sessionScope.user}" />
<c:set var="displayName" value="${empty currentUser ? 'Guest' : currentUser.fullName}" />
<c:if test="${not empty currentUser and fn:contains(currentUser.fullName, ' ')}">
    <c:set var="displayName" value="${fn:substringBefore(currentUser.fullName, ' ')}" />
</c:if>

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
            <a class="back-link" href="${ctx}/user/my-bookings?status=accepted"><i class="ri-arrow-left-line"></i> Back to bookings</a>
            <p class="micro-label">- Checkout</p>
            <h1>Pay &amp; unlock</h1>
        </div>
    </section>

    <section class="checkout-shell">
        <div class="container checkout-grid">
            <c:if test="${not empty success}">
                <div class="form-alert form-alert-success checkout-alert">${success}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="form-alert form-alert-error checkout-alert">${error}</div>
            </c:if>

            <article class="panel summary-panel">
                <p class="panel-label">- Order summary</p>
                <h2>${skillTitle}</h2>
                <p class="teacher-line">with ${teacherName}</p>

                <div class="summary-line">
                    <span>Duration</span>
                    <strong>${booking.durationMinutes} min</strong>
                </div>
                <div class="summary-line">
                    <span>Per 10 min</span>
                    <strong>$${pricePer10}</strong>
                </div>

                <div class="summary-total">
                    <span>Total</span>
                    <strong>$${booking.totalPrice}</strong>
                </div>
            </article>

            <article class="panel payment-panel">
                <p class="panel-label"><i class="ri-lock-line"></i> Card details</p>
                <form method="post" action="${ctx}/user/checkout">
                    <input type="hidden" name="bookingId" value="${booking.bookingId}" />

                    <label class="form-label" for="cardNumber">Card number</label>
                    <input id="cardNumber" name="cardNumber" type="text" placeholder="xxxx xxxx xxxx xxxx" inputmode="numeric" maxlength="23" pattern="[0-9 ]{13,23}" oninput="this.value = this.value.replace(/[^0-9 ]/g, '')" />

                    <div class="form-row">
                        <div>
                            <label class="form-label" for="expiry">Expiry</label>
                            <input id="expiry" name="expiry" type="text" placeholder="MMYY" inputmode="numeric" maxlength="4" pattern="[0-9]{4}" oninput="this.value = this.value.replace(/\D/g, '')" />
                        </div>
                        <div>
                            <label class="form-label" for="cvv">CVV</label>
                            <input id="cvv" name="cvv" type="text" placeholder="xxx" inputmode="numeric" maxlength="4" pattern="[0-9]{3,4}" oninput="this.value = this.value.replace(/\D/g, '')" />
                        </div>
                    </div>

                    <button type="submit" class="pay-btn">Pay $${booking.totalPrice}</button>
                </form>
            </article>
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
