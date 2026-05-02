const header = document.querySelector(".site-header");

if (header && window.matchMedia("(min-width: 993px)").matches) {
    const onScroll = () => {
        if (window.scrollY > 8) {
            header.classList.add("is-scrolled");
        } else {
            header.classList.remove("is-scrolled");
        }
    };

    onScroll();
    window.addEventListener("scroll", onScroll, { passive: true });
}
