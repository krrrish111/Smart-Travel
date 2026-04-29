<!-- ===== BACKGROUND SLIDER ===== -->
<div class="bg-slider-container" id="bgSliderContainer">
    <div class="bg-slide active" data-index="0"
        style="background-image: url('https://images.unsplash.com/photo-1524492412937-b28074a5d7da?auto=format,compress&fit=crop&w=1920&q=70')">
    </div>
    <div class="bg-slide" data-index="1"
        style="background-image: url('https://images.unsplash.com/photo-1602216056096-3b40cc0c9944?auto=format,compress&fit=crop&w=1920&q=70')">
    </div>
    <div class="bg-slide" data-index="2"
        style="background-image: url('https://images.unsplash.com/photo-1599661046289-e31897846e41?auto=format,compress&fit=crop&w=1920&q=70')">
    </div>
    <div class="bg-slide" data-index="3"
        style="background-image: url('https://images.unsplash.com/photo-1561359313-0639aad073f0?auto=format,compress&fit=crop&w=1920&q=70')">
    </div>
    <div class="bg-slide" data-index="4"
        style="background-image: url('https://images.unsplash.com/photo-1626082896492-766af4eb65ed?auto=format,compress&fit=crop&w=1920&q=70')">
    </div>
</div>

<!-- ===== SCROLL PROGRESS LINE ===== -->
<div class="scroll-line-container">
    <div class="scroll-line-progress" id="scrollProgress"></div>
</div>

<!-- ===== CUSTOM CURSOR ===== -->
<div class="cursor-dot" id="cursorDot"></div>
<div class="cursor-outline" id="cursorOutline"></div>

<script>
    (function () {
        // ── Theme persistence ──────────────────────────────────────────
        var savedTheme = localStorage.getItem('theme');
        if (savedTheme) {
            document.documentElement.setAttribute('data-theme', savedTheme);
            document.body.setAttribute('data-theme', savedTheme);
        }

        // ── Custom cursor ──────────────────────────────────────────────
        var dot = document.getElementById('cursorDot');
        var outline = document.getElementById('cursorOutline');
        if (dot && outline) {
            document.addEventListener('mousemove', function (e) {
                dot.style.left = e.clientX + 'px';
                dot.style.top = e.clientY + 'px';
                outline.style.left = e.clientX + 'px';
                outline.style.top = e.clientY + 'px';
            });
            document.addEventListener('mousedown', function () {
                dot.style.transform = 'translate(-50%,-50%) scale(1.8)';
                outline.style.transform = 'translate(-50%,-50%) scale(0.8)';
            });
            document.addEventListener('mouseup', function () {
                dot.style.transform = 'translate(-50%,-50%) scale(1)';
                outline.style.transform = 'translate(-50%,-50%) scale(1)';
            });

            // Hover scaling effect on buttons and links
            var addHoverEffects = function() {
                var interactives = document.querySelectorAll('a, button, .btn, .nav-link, .voyastra-logo, input, select');
                interactives.forEach(function(el) {
                    if(el.dataset.cursorBound) return;
                    el.dataset.cursorBound = "true";
                    el.addEventListener('mouseenter', function() {
                        outline.style.transform = 'translate(-50%,-50%) scale(1.5)';
                        outline.style.backgroundColor = 'rgba(212, 165, 116, 0.15)'; 
                        outline.style.borderColor = 'transparent';
                    });
                    el.addEventListener('mouseleave', function() {
                        outline.style.transform = 'translate(-50%,-50%) scale(1)';
                        outline.style.backgroundColor = 'transparent';
                        outline.style.borderColor = 'var(--color-accent)';
                    });
                });
            };
            
            // Run initially and observe DOM for dynamically added elements
            addHoverEffects();
            var observer = new MutationObserver(function(mutations) {
                if(mutations.length) addHoverEffects();
            });
            observer.observe(document.body, { childList: true, subtree: true });
        }

        // ── Scroll progress line ───────────────────────────────────────
        var prog = document.getElementById('scrollProgress');
        if (prog) {
            window.addEventListener('scroll', function () {
                var pct = (window.scrollY / (document.body.scrollHeight - window.innerHeight)) * 100;
                prog.style.height = Math.min(pct, 100) + '%';
            }, { passive: true });
        }

        // ── Auto-cycling background slides ────────────────────────────
        var slides = document.querySelectorAll('.bg-slide');
        if (slides.length > 1) {
            var currentSlide = 0;
            setInterval(function () {
                slides[currentSlide].classList.remove('active');
                currentSlide = (currentSlide + 1) % slides.length;
                slides[currentSlide].classList.add('active');
            }, 5000);
        }

        // ── Scroll-fade observer ───────────────────────────────────────
        document.addEventListener('DOMContentLoaded', function () {
            var fades = document.querySelectorAll('.scroll-fade');
            if (fades.length && 'IntersectionObserver' in window) {
                var obs = new IntersectionObserver(function (entries) {
                    entries.forEach(function (entry) {
                        if (entry.isIntersecting) { entry.target.classList.add('visible'); }
                    });
                }, { threshold: 0.1 });
                fades.forEach(function (el) { obs.observe(el); });
            }

            // ── Theme toggle wiring ──────────────────────────────────
            var toggle = document.getElementById('themeToggle');
            if (toggle) {
                toggle.addEventListener('click', function () {
                    var current = document.documentElement.getAttribute('data-theme') || 'dark';
                    var next = current === 'light' ? 'dark' : 'light';
                    document.documentElement.setAttribute('data-theme', next);
                    document.body.setAttribute('data-theme', next);
                    localStorage.setItem('theme', next);
                });
            }
        });
    })();
</script>

<%-- ══════════════════════════════════════════════════════════════════
     GLOBAL FLASH MESSAGE → TOAST BRIDGE
     Reads Java HttpSession flash attributes and fires VoyastraToast.
     Attributes are consumed (removed) immediately after reading so they
     don't appear on subsequent page navigations.
════════════════════════════════════════════════════════════════════ --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${not empty sessionScope.successMsg}">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            if (window.VoyastraToast) {
                VoyastraToast.show('<c:out value="${sessionScope.successMsg}" escapeXml="true"/>', 'success');
            }
        });
    </script>
    <c:remove var="successMsg" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.errorMsg}">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            if (window.VoyastraToast) {
                VoyastraToast.show('<c:out value="${sessionScope.errorMsg}" escapeXml="true"/>', 'error');
            }
        });
    </script>
    <c:remove var="errorMsg" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.warningMsg}">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            if (window.VoyastraToast) {
                VoyastraToast.show('<c:out value="${sessionScope.warningMsg}" escapeXml="true"/>', 'warning');
            }
        });
    </script>
    <c:remove var="warningMsg" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.infoMsg}">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            if (window.VoyastraToast) {
                VoyastraToast.show('<c:out value="${sessionScope.infoMsg}" escapeXml="true"/>', 'info');
            }
        });
    </script>
    <c:remove var="infoMsg" scope="session"/>
</c:if>

<%-- Also handle request-scoped flash (for forward-based responses like LoginServlet) --%>
<c:if test="${not empty requestScope.successMsg}">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            if (window.VoyastraToast) {
                VoyastraToast.show('<c:out value="${requestScope.successMsg}" escapeXml="true"/>', 'success');
            }
        });
    </script>
</c:if>

<c:if test="${not empty requestScope.errorMsg}">
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            if (window.VoyastraToast) {
                VoyastraToast.show('<c:out value="${requestScope.errorMsg}" escapeXml="true"/>', 'error');
            }
        });
    </script>
</c:if>