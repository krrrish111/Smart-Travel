let allPayments = [];
let allRefunds = [];

function switchTab(tab) {
    const pTab = document.getElementById('paymentsTab');
    const rTab = document.getElementById('refundsTab');
    const pBtn = document.getElementById('tabPaymentsBtn');
    const rBtn = document.getElementById('tabRefundsBtn');

    if (tab === 'payments') {
        pTab.style.display = 'block';
        rTab.style.display = 'none';
        pBtn.style.borderColor = 'var(--color-primary)';
        pBtn.style.color = 'var(--color-primary)';
        rBtn.style.borderColor = 'transparent';
        rBtn.style.color = 'inherit';
    } else {
        pTab.style.display = 'none';
        rTab.style.display = 'block';
        rBtn.style.borderColor = 'var(--color-primary)';
        rBtn.style.color = 'var(--color-primary)';
        pBtn.style.borderColor = 'transparent';
        pBtn.style.color = 'inherit';
    }
}

async function loadPayments() {
    try {
        const response = await fetch(CONTEXT_PATH + '/admin/payments-api');
        if (!response.ok) throw new Error('Failed to load data');
        const data = await response.json();
        allPayments = data.payments || [];
        allRefunds = data.refunds || [];
        renderPayments();
        renderRefunds();
    } catch (err) {
        console.error('Data fetch error:', err);
    }
}

function renderPayments() {
    const tbody = document.getElementById('paymentsTableBody');
    if (!tbody) return;

    if (allPayments.length === 0) {
        tbody.innerHTML = '<tr><td colspan="8" style="text-align:center;">No payments found.</td></tr>';
        return;
    }

    tbody.innerHTML = allPayments.map(p => {
        let statusBadge = p.status;
        if (p.status === 'Completed' || p.status === 'Paid') statusBadge = `<span class="badge badge-success">${p.status}</span>`;
        else if (p.status === 'Failed' || p.status === 'Cancelled') statusBadge = `<span class="badge badge-danger">${p.status}</span>`;
        else statusBadge = `<span class="badge badge-warning">${p.status}</span>`;

        return `
            <tr>
                <td>#${p.id}</td>
                <td>${p.userId}</td>
                <td>${p.bookingId || '-'}</td>
                <td>${p.currency} ${p.amount.toFixed(2)}</td>
                <td>${p.method || '-'}</td>
                <td>${p.transactionId || '-'}</td>
                <td>${statusBadge}</td>
                <td>
                    <select onchange="updatePaymentStatus(${p.id}, this.value)" class="form-control" style="width:auto; display:inline-block; padding: 4px; font-size: 0.85rem;">
                        <option value="">Update...</option>
                        <option value="Completed">Set Completed</option>
                        <option value="Failed">Set Failed</option>
                        <option value="Refunded">Set Refunded</option>
                    </select>
                </td>
            </tr>
        `;
    }).join('');
}

function renderRefunds() {
    const tbody = document.getElementById('refundsTableBody');
    if (!tbody) return;

    if (allRefunds.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" style="text-align:center;">No refunds found.</td></tr>';
        return;
    }

    tbody.innerHTML = allRefunds.map(r => {
        let statusBadge = r.status;
        if (r.status === 'Completed' || r.status === 'Approved') statusBadge = `<span class="badge badge-success">${r.status}</span>`;
        else if (r.status === 'Rejected') statusBadge = `<span class="badge badge-danger">${r.status}</span>`;
        else statusBadge = `<span class="badge badge-warning">${r.status}</span>`;

        return `
            <tr>
                <td>#${r.id}</td>
                <td>${r.bookingId}</td>
                <td>INR ${r.amount.toFixed(2)}</td>
                <td>${r.refundMethod || '-'}</td>
                <td>${r.createdAt ? r.createdAt : '-'}</td>
                <td>${statusBadge}</td>
                <td>
                    <select onchange="updateRefundStatus(${r.id}, this.value)" class="form-control" style="width:auto; display:inline-block; padding: 4px; font-size: 0.85rem;">
                        <option value="">Update...</option>
                        <option value="Approved">Approve</option>
                        <option value="Rejected">Reject</option>
                        <option value="Completed">Mark Completed</option>
                    </select>
                </td>
            </tr>
        `;
    }).join('');
}

async function updatePaymentStatus(id, status) {
    if (!status) return;
    if (!confirm(`Are you sure you want to set payment #${id} to ${status}?`)) return;

    const body = new URLSearchParams();
    body.append('action', 'updatePaymentStatus');
    body.append('id', id);
    body.append('status', status);

    try {
        const response = await fetch(CONTEXT_PATH + '/admin/payments-api', { method: 'POST', body });
        const res = await response.json();
        if (res.status === 'success') {
            if (typeof showToast === 'function') showToast('Payment status updated.', 'success');
            loadPayments();
        } else {
            if (typeof showToast === 'function') showToast(res.message || 'Failed to update payment.', 'error');
        }
    } catch (err) {
        console.error('Update error:', err);
    }
}

async function updateRefundStatus(id, status) {
    if (!status) return;
    if (!confirm(`Are you sure you want to set refund #${id} to ${status}?`)) return;

    const body = new URLSearchParams();
    body.append('action', 'updateRefundStatus');
    body.append('id', id);
    body.append('status', status);

    try {
        const response = await fetch(CONTEXT_PATH + '/admin/payments-api', { method: 'POST', body });
        const res = await response.json();
        if (res.status === 'success') {
            if (typeof showToast === 'function') showToast('Refund status updated.', 'success');
            loadPayments();
        } else {
            if (typeof showToast === 'function') showToast(res.message || 'Failed to update refund.', 'error');
        }
    } catch (err) {
        console.error('Update error:', err);
    }
}
