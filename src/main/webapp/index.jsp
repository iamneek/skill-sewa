<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Skill Sewa | Learn and Teach Skills</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=Outfit:wght@200;300;400;500;600;700&family=JetBrains+Mono:wght@300;400;500;600&display=swap" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet" />

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/global.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/navbar.css" />
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home.css" />
</head>
<body>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<c:set var="currentUser" value="${sessionScope.user}" />
<c:set var="displayName" value="${currentUser.fullName}" />
<c:if test="${not empty currentUser and fn:contains(currentUser.fullName, ' ')}">
    <c:set var="displayName" value="${fn:substringBefore(currentUser.fullName, ' ')}" />
</c:if>

<header class="site-header">
    <div class="container nav-shell">
        <a class="brand" href="${ctx}/">
            <img src="${ctx}/assets/images/skillsewa-logo.svg" alt="Skill Sewa" class="brand-logo" />
        </a>

        <button class="menu-toggle" type="button" aria-label="Toggle menu" aria-expanded="false" aria-controls="main-nav">
            <i class="ri-menu-line"></i>
        </button>

        <nav id="main-nav" class="main-nav">
            <a href="${ctx}/" class="active">Home</a>
            <a href="${ctx}/user/browse-skills">Browse</a>
            <c:if test="${not empty currentUser}">
                <a href="${ctx}/user/dashboard">Dashboard</a>
            </c:if>
        </nav>

        <div class="nav-right">
            <c:choose>
                <c:when test="${not empty currentUser}">
                    <span class="user-name"><i class="ri-user-line"></i> ${displayName}</span>
                    <a class="logout-link" href="${ctx}/logout"><i class="ri-logout-box-r-line"></i> Logout</a>
                </c:when>
                <c:otherwise>
                    <a class="login-link" href="${ctx}/login">Login</a>
                    <a class="join-btn" href="${ctx}/register">Join Sewa</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>

<main>
    <section class="hero-section">
        <div class="container hero-grid">
            <div class="hero-content">
                <span class="micro-label">VOL. 01 - A COMMUNITY OF GIVERS</span>
                <h1>
                    Teach what<br />
                    you know,<br />
                    <span class="accent-script">learn what</span><br />
                    <span class="italic-line">you don't.</span>
                </h1>
                <p>
                    Skill Sewa is a marketplace built around ten-minute moments - a quiet exchange between
                    teachers and learners, priced honestly and paid forward.
                </p>
                <div class="hero-actions">
                    <a class="primary-btn" href="${pageContext.request.contextPath}/user/browse-skills"><i class="ri-sparkling-line"></i> Start Learning</a>
                    <a class="ghost-btn" href="${pageContext.request.contextPath}/user/add-skill"><i class="ri-hand-heart-line"></i> Start Teaching</a>
                </div>
            </div>
            <div class="hero-media" aria-label="Hero image placeholder">
                <img
                        class="hero-image"
                        src="${pageContext.request.contextPath}/assets/images/hero_image.jpeg"
                        alt="Skill Sewa teaching and learning illustration"
                />
                <aside class="floating-note">
                    <small>SKILLS SHARED</small>
                    <h4>10-min.</h4>
                    <p>The unit of generosity.</p>
                </aside>
            </div>
        </div>
    </section>

    <section class="ticker-strip" aria-label="Popular categories">
        <div class="ticker-inner">
            <div class="ticker-track">
                <span>Business</span><span class="dot">&bull;</span><span>Music</span><span class="dot">&bull;</span><span>Coding</span><span class="dot">&bull;</span><span>Cooking</span><span class="dot">&bull;</span><span>Languages</span><span class="dot">&bull;</span><span>Fitness</span><span class="dot">&bull;</span><span>Art</span><span class="dot">&bull;</span><span>Technology</span><span class="dot">&bull;</span><span>Design</span><span class="dot">&bull;</span><span>Marketing</span><span class="dot">&bull;</span><span>Photography</span><span class="dot">&bull;</span><span>Business</span><span class="dot">&bull;</span><span>Music</span><span class="dot">&bull;</span><span>Coding</span><span class="dot">&bull;</span><span>Cooking</span><span class="dot">&bull;</span><span>Languages</span><span class="dot">&bull;</span><span>Fitness</span><span class="dot">&bull;</span><span>Art</span><span class="dot">&bull;</span>
            </div>
            <div class="ticker-track" aria-hidden="true">
                <span>Business</span><span class="dot">&bull;</span><span>Music</span><span class="dot">&bull;</span><span>Coding</span><span class="dot">&bull;</span><span>Cooking</span><span class="dot">&bull;</span><span>Languages</span><span class="dot">&bull;</span><span>Fitness</span><span class="dot">&bull;</span><span>Art</span><span class="dot">&bull;</span><span>Technology</span><span class="dot">&bull;</span><span>Design</span><span class="dot">&bull;</span><span>Marketing</span><span class="dot">&bull;</span><span>Photography</span><span class="dot">&bull;</span><span>Business</span><span class="dot">&bull;</span><span>Music</span><span class="dot">&bull;</span><span>Coding</span><span class="dot">&bull;</span><span>Cooking</span><span class="dot">&bull;</span><span>Languages</span><span class="dot">&bull;</span><span>Fitness</span><span class="dot">&bull;</span><span>Art</span><span class="dot">&bull;</span>
            </div>
        </div>
    </section>

    <section class="steps-section" id="how-it-works">
        <div class="container">
            <span class="micro-label">- HOW IT WORKS</span>
            <div class="steps-grid boxed-grid">
                <article class="step-card">
                    <span class="step-number">01 /</span>
                    <h3>Post a Skill</h3>
                    <p>Share what you can teach. Set a price per ten minutes - short, honest, accessible.</p>
                </article>
                <article class="step-card">
                    <span class="step-number">02 /</span>
                    <h3>Get Booked</h3>
                    <p>Learners send a request. You accept (or decline) on your own terms.</p>
                </article>
                <article class="step-card">
                    <span class="step-number">03 /</span>
                    <h3>Connect &amp; Teach</h3>
                    <p>After payment, the learner sees your contact info. Meet on your platform of choice.</p>
                </article>
            </div>
        </div>
    </section>

    <section class="categories-section" id="categories">
        <div class="container">
            <div class="section-row">
                <div>
                    <span class="micro-label">- BROWSE BY CATEGORY</span>
                    <h2>Find your craft.</h2>
                </div>
                <a class="explore-link" href="${pageContext.request.contextPath}/user/browse-skills">Explore all <i class="ri-arrow-right-up-line"></i></a>
            </div>
            <div class="craft-grid">
                <a class="craft-card" href="${pageContext.request.contextPath}/user/browse-skills?category=Art">
                    <i class="ri-palette-line"></i>
                    <h3>Art</h3>
                    <span>BROWSE</span>
                </a>
                <a class="craft-card" href="${pageContext.request.contextPath}/user/browse-skills?category=Business">
                    <i class="ri-briefcase-4-line"></i>
                    <h3>Business</h3>
                    <span>BROWSE</span>
                </a>
                <a class="craft-card" href="${pageContext.request.contextPath}/user/browse-skills?category=Coding">
                    <i class="ri-code-s-slash-line"></i>
                    <h3>Coding</h3>
                    <span>BROWSE</span>
                </a>
                <a class="craft-card" href="${pageContext.request.contextPath}/user/browse-skills?category=Cooking">
                    <i class="ri-restaurant-2-line"></i>
                    <h3>Cooking</h3>
                    <span>BROWSE</span>
                </a>
                <a class="craft-card" href="${pageContext.request.contextPath}/user/browse-skills?category=Fitness">
                    <i class="ri-heart-pulse-line"></i>
                    <h3>Fitness</h3>
                    <span>BROWSE</span>
                </a>
                <a class="craft-card" href="${pageContext.request.contextPath}/user/browse-skills?category=Language">
                    <i class="ri-translate-2"></i>
                    <h3>Languages</h3>
                    <span>BROWSE</span>
                </a>
                <a class="craft-card" href="${pageContext.request.contextPath}/user/browse-skills?category=Music">
                    <i class="ri-music-2-line"></i>
                    <h3>Music</h3>
                    <span>BROWSE</span>
                </a>
                <a class="craft-card" href="${pageContext.request.contextPath}/user/browse-skills?category=Other">
                    <i class="ri-shapes-line"></i>
                    <h3>Other</h3>
                    <span>BROWSE</span>
                </a>
            </div>
        </div>
    </section>

    <section class="begin-strip">
        <div class="container begin-grid">
            <div>
                <span class="micro-label">- BEGIN</span>
                <h2>Ten minutes is enough <em>to begin.</em></h2>
            </div>
            <div class="begin-actions">
                <a class="dark-btn" href="${pageContext.request.contextPath}/register">Create an Account</a>
                <a class="ghost-btn" href="${pageContext.request.contextPath}/user/browse-skills">Browse Skills</a>
            </div>
        </div>
    </section>
</main>

<footer class="site-footer">
    <div class="container footer-grid minimal-footer">
        <div>
            <a class="brand footer-brand" href="${pageContext.request.contextPath}/">
                <img src="${pageContext.request.contextPath}/assets/images/skillsewa-logo.svg" alt="Skill Sewa" class="brand-logo" />
            </a>
            <p>A community of teachers &amp; learners.<br />Selfless service, ten minutes at a time.</p>
        </div>
        <div>
            <h4>DISCOVER</h4>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/user/browse-skills">Browse Skills</a></li>
                <li><a href="${pageContext.request.contextPath}/user/add-skill">Become a Teacher</a></li>
            </ul>
        </div>
        <div>
            <h4>ACCOUNT</h4>
            <ul class="footer-links">
                <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
                <li><a href="${pageContext.request.contextPath}/register">Sign Up</a></li>
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

<script src="${pageContext.request.contextPath}/js/navbar.js"></script>
<script src="${pageContext.request.contextPath}/js/sticky-header.js"></script>
</body>
</html>
