<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main style="padding-top: 120px; padding-bottom: 80px;">
    <div class="container">
        <div class="glass-panel p-8 max-w-2xl mx-auto slide-up">
            <div class="flex items-center gap-4 mb-8">
                <div class="bg-primary p-3 rounded-full text-white">
                    <c:choose>
                        <c:when test="${param.type == 'flight'}">✈️</c:when>
                        <c:otherwise>🏨</c:otherwise>
                    </c:choose>
                </div>
                <div>
                    <h1 class="text-white editorial text-3xl m-0">Confirm Your Selection</h1>
                    <p class="text-white opacity-60">Please provide traveler details to continue.</p>
                </div>
            </div>

            <div class="bg-white bg-opacity-5 rounded-xl p-6 mb-8 border border-white border-opacity-10">
                <div class="flex justify-between items-center">
                    <div>
                        <h3 class="text-white font-bold text-xl">${param.name}</h3>
                        <p class="text-primary text-sm font-bold uppercase tracking-widest">${param.type} Selection</p>
                    </div>
                    <div class="text-right">
                        <div class="text-white opacity-50 text-xs">Total Amount</div>
                        <div class="text-white font-bold text-2xl">₹${param.price}</div>
                    </div>
                </div>
            </div>

            <!-- BOOKING FORM -->
            <form action="${pageContext.request.contextPath}/submit-booking" method="post" class="space-y-6">
                <input type="hidden" name="type" value="${param.type}">
                <input type="hidden" name="id" value="${param.id}">
                <input type="hidden" name="price" value="${param.price}">
                <input type="hidden" name="name" value="${param.name}">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <div class="space-y-2">
                        <label class="text-white text-sm font-bold opacity-80">Full Name</label>
                        <input type="text" name="customerName" required class="w-full bg-white bg-opacity-10 border border-white border-opacity-20 rounded-lg p-3 text-white focus:border-primary outline-none" placeholder="John Doe">
                    </div>
                    <div class="space-y-2">
                        <label class="text-white text-sm font-bold opacity-80">Email Address</label>
                        <input type="email" name="customerEmail" required class="w-full bg-white bg-opacity-10 border border-white border-opacity-20 rounded-lg p-3 text-white focus:border-primary outline-none" placeholder="john@example.com">
                    </div>
                </div>

                <div class="space-y-2">
                    <label class="text-white text-sm font-bold opacity-80">Contact Number</label>
                    <input type="tel" name="customerPhone" required class="w-full bg-white bg-opacity-10 border border-white border-opacity-20 rounded-lg p-3 text-white focus:border-primary outline-none" placeholder="+91 98765 43210">
                </div>

                <div class="pt-6">
                    <button type="submit" class="btn btn-primary w-full py-4 text-lg font-bold" style="border-radius: 12px;">
                        Proceed to Payment →
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>

<%@ include file="/components/footer.jsp" %>
