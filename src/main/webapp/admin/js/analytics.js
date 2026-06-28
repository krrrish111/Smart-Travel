/* =========================================================
   PLATFORM ANALYTICS ENGINE (Chart.js)
========================================================= */

let revenueChartInstance = null;
let destinationPieChartInstance = null;
let userGrowthChartInstance = null;

function initAnalyticsCharts() {
    // Set global Chart.js defaults
    Chart.defaults.color = '#888';
    Chart.defaults.font.family = "'Inter', 'Poppins', sans-serif";
    Chart.defaults.plugins.tooltip.backgroundColor = 'rgba(15, 23, 42, 0.9)';
    Chart.defaults.plugins.tooltip.padding = 12;

    loadAnalytics(); // Load numeric stats and initialize charts with real data
}

function initRevenueChart(revenueData, bookingsData) {
    const ctx = document.getElementById('revenueChart');
    if (!ctx) return;
    
    if (revenueChartInstance) {
        revenueChartInstance.destroy();
    }

    const gradient = ctx.getContext('2d').createLinearGradient(0, 0, 0, 400);
    gradient.addColorStop(0, 'rgba(79, 70, 229, 0.2)');
    gradient.addColorStop(1, 'rgba(79, 70, 229, 0)');

    revenueChartInstance = new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            datasets: [{
                label: 'Revenue ($)',
                data: revenueData || [0,0,0,0,0,0,0,0,0,0,0,0],
                borderColor: '#4f46e5',
                borderWidth: 3,
                fill: true,
                backgroundColor: gradient,
                tension: 0.4,
                pointBackgroundColor: '#4f46e5',
                pointRadius: 4
            }, {
                label: 'Bookings',
                data: bookingsData || [0,0,0,0,0,0,0,0,0,0,0,0],
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

function initDestinationPieChart(labels, data) {
    const ctx = document.getElementById('destinationPieChart');
    if (!ctx) return;

    if (destinationPieChartInstance) {
        destinationPieChartInstance.destroy();
    }

    destinationPieChartInstance = new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: labels || ['No Data'],
            datasets: [{
                data: data || [1],
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
    const ctx = document.getElementById('userGrowthChart');
    if (!ctx) return;
    
    if (userGrowthChartInstance) {
        userGrowthChartInstance.destroy();
    }

    userGrowthChartInstance = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Week 1', 'Week 2', 'Week 3', 'Week 4'],
            datasets: [{
                label: 'New Users',
                data: [150, 220, 180, 260], // Mock for now, expand DAO to fetch later if needed
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

function loadTopPlans(plansData) {
    const container = document.getElementById('topPlansList');
    if (!container) return;
    
    if (!plansData || plansData.length === 0) {
        container.innerHTML = '<div style="padding:12px; text-align:center; color:var(--text-muted);">No bookings yet</div>';
        return;
    }

    container.innerHTML = plansData.map(p => `
        <div style="display:flex; justify-content:space-between; align-items:center; padding:12px; background:rgba(255,255,255,0.02); border-radius:12px; border:1px solid var(--color-border); margin-bottom: 8px;">
            <div>
                <div style="font-weight:600; font-size:0.9rem;">${p.name}</div>
                <div style="font-size:0.75rem; color:var(--text-muted);">${p.bookings} total bookings</div>
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

function loadAnalytics() {
    fetch(CONTEXT_PATH + '/admin/stats')
        .then(res => res.json())
        .then(data => {
            // Update Stat Cards
            const updateElement = (id, value, prefix = '') => {
                if (document.getElementById(id)) {
                    document.getElementById(id).innerText = prefix + (value || 0).toLocaleString();
                }
            };
            
            updateElement('statUsers', data.users);
            updateElement('statPremiumUsers', data.premiumUsers);
            updateElement('statBookings', data.bookings);
            updateElement('statTodaysBookings', data.todaysBookings);
            updateElement('statCompletedBookings', data.completedBookings);
            updateElement('statPendingBookings', data.pendingBookings);
            updateElement('statCancelledBookings', data.cancelledBookings);
            updateElement('statRevenue', data.revenue, '$');
            updateElement('statThisMonthRevenue', data.thisMonthRevenue, '$');
            updateElement('statPlans', data.plans);
            updateElement('statDests', data.destinations);
            updateElement('statReviews', data.reviews);
            updateElement('statActivities', data.activities);

            // Update Charts
            initRevenueChart(data.revenuePerMonth, data.bookingsPerMonth);
            
            if (data.destinationPieChart && data.destinationPieChart.length > 0) {
                initDestinationPieChart(data.destinationPieChart[0].labels, data.destinationPieChart[0].data);
            } else {
                initDestinationPieChart();
            }

            initUserGrowthChart();
            loadTopPlans(data.topPlans);

        }).catch(err => {
            console.error('Failed to load analytics', err);
            // Fallback for charts if error
            initRevenueChart();
            initDestinationPieChart();
            initUserGrowthChart();
            loadTopPlans();
        });
}
