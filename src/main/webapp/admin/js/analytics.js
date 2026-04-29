/* =========================================================
   PLATFORM ANALYTICS ENGINE (Chart.js)
========================================================= */

function initAnalyticsCharts() {
    // Set global Chart.js defaults
    Chart.defaults.color = '#888';
    Chart.defaults.font.family = "'Inter', 'Poppins', sans-serif";
    Chart.defaults.plugins.tooltip.backgroundColor = 'rgba(15, 23, 42, 0.9)';
    Chart.defaults.plugins.tooltip.padding = 12;

    initRevenueChart();
    initDestinationPieChart();
    initUserGrowthChart();
    loadTopPlans();
    loadAnalytics(); // Load numeric stats
}

function initRevenueChart() {
    const ctx = document.getElementById('revenueChart').getContext('2d');
    const gradient = ctx.createLinearGradient(0, 0, 0, 400);
    gradient.addColorStop(0, 'rgba(79, 70, 229, 0.2)');
    gradient.addColorStop(1, 'rgba(79, 70, 229, 0)');

    new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            datasets: [{
                label: 'Revenue ($)',
                data: [1200, 1900, 1500, 2500, 2200, 3000, 2800],
                borderColor: '#4f46e5',
                borderWidth: 3,
                fill: true,
                backgroundColor: gradient,
                tension: 0.4,
                pointBackgroundColor: '#4f46e5',
                pointRadius: 4
            }, {
                label: 'Bookings',
                data: [15, 25, 20, 35, 30, 45, 40],
                borderColor: '#10b981',
                borderWidth: 2,
                fill: false,
                tension: 0.4,
                pointBackgroundColor: '#10b981',
                pointRadius: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { position: 'top', align: 'end' }
            },
            scales: {
                y: { grid: { color: 'rgba(255,255,255,0.05)' }, beginAtZero: true },
                x: { grid: { display: false } }
            }
        }
    });
}

function initDestinationPieChart() {
    const ctx = document.getElementById('destinationPieChart').getContext('2d');
    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: ['Europe', 'Asia', 'Americas', 'Africa', 'Oceania'],
            datasets: [{
                data: [35, 25, 20, 12, 8],
                backgroundColor: [
                    '#4f46e5', '#06b6d4', '#fbbf24', '#10b981', '#ef4444'
                ],
                borderWidth: 0,
                hoverOffset: 10
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            cutout: '70%',
            plugins: {
                legend: { position: 'bottom' }
            }
        }
    });
}

function initUserGrowthChart() {
    const ctx = document.getElementById('userGrowthChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
            datasets: [{
                label: 'New Users',
                data: [150, 220, 180, 260],
                backgroundColor: 'rgba(59, 130, 246, 0.6)',
                borderRadius: 6
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: { grid: { color: 'rgba(255,255,255,0.05)' } },
                x: { grid: { display: false } }
            }
        }
    });
}

function loadTopPlans() {
    const container = document.getElementById('topPlansList');
    if (!container) return;
    
    // Mock data for demo
    const topPlans = [
        { name: 'Swiss Alps Luxury', revenue: 12400, bookings: 12, growth: '+15%' },
        { name: 'Bali Beach Paradise', revenue: 8900, bookings: 18, growth: '+22%' },
        { name: 'Santorini Escape', revenue: 7600, bookings: 9, growth: '+5%' }
    ];

    container.innerHTML = topPlans.map(p => `
        <div style="display:flex; justify-content:space-between; align-items:center; padding:12px; background:rgba(255,255,255,0.02); border-radius:12px; border:1px solid var(--color-border);">
            <div>
                <div style="font-weight:600; font-size:0.9rem;">${p.name}</div>
                <div style="font-size:0.75rem; color:var(--text-muted);">${p.bookings} bookings this week</div>
            </div>
            <div style="text-align:right;">
                <div style="font-weight:700; color:var(--color-primary);">$${p.revenue.toLocaleString()}</div>
                <div style="font-size:0.75rem; color:#10b981;">${p.growth}</div>
            </div>
        </div>
    `).join('');
}

function refreshAnalytics() {
    if (typeof showToast === 'function') showToast('Refreshing analytics data...', 'success');
    loadAnalytics();
}

// Keep the old loadAnalytics for basic stats compatibility
function loadAnalytics() {
    fetch(CONTEXT_PATH + '/admin/stats')
        .then(res => res.json())
        .then(data => {
            if(document.getElementById('statUsers')) document.getElementById('statUsers').innerText = data.users.toLocaleString();
            if(document.getElementById('statBookings')) document.getElementById('statBookings').innerText = data.bookings.toLocaleString();
            // ...
        }).catch(err => console.warn('Real-time stats not available yet. Using mocks.'));
}
