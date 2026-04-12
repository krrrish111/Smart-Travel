<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- ====== SECONDARY NAV ====== -->
<div class="secondary-nav-wrapper">
    <div class="container relative">
        <div class="secondary-nav-inner glass-panel" style="backdrop-filter: blur(14px); background: var(--color-surface); opacity:0.98; border-radius: 16px; padding: 12px 24px; box-shadow: var(--shadow-md); margin-bottom: 24px;">
            <ul class="sec-nav-list flex gap-6 overflow-x-auto no-scrollbar items-center justify-between" style="white-space: nowrap;">
                <!-- To ensure this component acts as a router on non-booking pages, these could become a tags, but for now they trigger JS if available -->
                <li class="sec-nav-item active" data-tab="flights"><a href="booking.jsp?tab=flights" class="flex flex-col items-center gap-1 text-inherit no-underline"><span class="icon">✈️</span> Flights</a></li>
                <li class="sec-nav-item" data-tab="hotels"><a href="booking.jsp?tab=hotels" class="flex flex-col items-center gap-1 text-inherit no-underline"><span class="icon">🏨</span> Hotels</a></li>
                <li class="sec-nav-item" data-tab="homestays"><a href="booking.jsp?tab=homestays" class="flex flex-col items-center gap-1 text-inherit no-underline"><span class="icon">🏡</span> Villas <span class="badge-new">NEW</span></a></li>
                <li class="sec-nav-item" data-tab="packages"><a href="booking.jsp?tab=packages" class="flex flex-col items-center gap-1 text-inherit no-underline"><span class="icon">🌍</span> Packages</a></li>
                <li class="sec-nav-item" data-tab="trains"><a href="booking.jsp?tab=trains" class="flex flex-col items-center gap-1 text-inherit no-underline"><span class="icon">🚆</span> Trains</a></li>
                <li class="sec-nav-item" data-tab="buses"><a href="booking.jsp?tab=buses" class="flex flex-col items-center gap-1 text-inherit no-underline"><span class="icon">🚌</span> Buses</a></li>
                <li class="sec-nav-item" data-tab="cabs"><a href="booking.jsp?tab=cabs" class="flex flex-col items-center gap-1 text-inherit no-underline"><span class="icon">🚖</span> Cabs</a></li>
                <li class="sec-nav-item" data-tab="tours"><a href="booking.jsp?tab=activities" class="flex flex-col items-center gap-1 text-inherit no-underline"><span class="icon">🎟️</span> Tours</a></li>
                <li class="sec-nav-item" data-tab="visa"><a href="booking.jsp?tab=visa" class="flex flex-col items-center gap-1 text-inherit no-underline"><span class="icon">🛂</span> Visa</a></li>
            </ul>
        </div>
    </div>
</div>

<style>
/* Remove default anchor tag styles so the JS or CSS flex column works natively */
.sec-nav-item a {
    color: inherit;
    text-decoration: none;
    pointer-events: inherit;
}
/* For index/booking page where JS is used, we can prevent default anchor jump */
.sec-nav-list[data-routed="false"] a {
    pointer-events: none;
}
</style>
