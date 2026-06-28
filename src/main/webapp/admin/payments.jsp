<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<jsp:include page="/admin/common/layout_start.jsp" />

<!-- Manage Payments Section -->
<section id="managePayments" class="admin-section active">
    <div class="flex justify-between items-center" style="margin-bottom: 24px;">
        <h2>Payment Management</h2>
        
        <div style="display:flex; gap:16px;">
            <button class="btn btn-outline" id="tabPaymentsBtn" onclick="switchTab('payments')" style="border-color:var(--color-primary); color:var(--color-primary);">All Payments</button>
            <button class="btn btn-outline" id="tabRefundsBtn" onclick="switchTab('refunds')">Refunds</button>
        </div>
    </div>

    <div id="paymentsTab" style="display:block;">
        <div class="table-container">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>User ID</th>
                        <th>Booking ID</th>
                        <th>Amount</th>
                        <th>Method</th>
                        <th>Transaction ID</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="paymentsTableBody">
                    <tr><td colspan="8" style="text-align:center;">Loading payments...</td></tr>
                </tbody>
            </table>
        </div>
    </div>

    <div id="refundsTab" style="display:none;">
        <div class="table-container">
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Refund ID</th>
                        <th>Booking ID</th>
                        <th>Amount</th>
                        <th>Method</th>
                        <th>Date Requested</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody id="refundsTableBody">
                    <tr><td colspan="7" style="text-align:center;">Loading refunds...</td></tr>
                </tbody>
            </table>
        </div>
    </div>
</section>

<!-- Page Specific JS -->
<script src="${pageContext.request.contextPath}/admin/js/payments.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        if (typeof loadPayments === 'function') loadPayments();
    });
</script>

<jsp:include page="/admin/common/layout_end.jsp" />
