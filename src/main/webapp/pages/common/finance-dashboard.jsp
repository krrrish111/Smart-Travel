<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>
<!-- Include Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<main class="container mx-auto px-4 relative" style="padding-top: 100px; padding-bottom: 40px; min-height: 100vh;">

    <div class="text-center mb-8 slide-up">
        <h1 class="text-primary mb-1 editorial" style="font-size: 2.5rem;">AI Financial Planner</h1>
        <p class="text-muted text-sm">Smart Budget Optimizer & Cost Prediction Engine</p>
    </div>

    <c:choose>
        <c:when test="${empty budgetPlan}">
            <!-- Initial Budget Creator Form -->
            <div class="glass-panel max-w-lg mx-auto p-8 text-center rounded-3xl slide-up delay-1">
                <div class="w-16 h-16 rounded-full bg-primary/20 text-primary flex items-center justify-center mx-auto mb-6">
                    <i class="ri-wallet-3-line text-3xl"></i>
                </div>
                <h3 class="text-main font-bold mb-2 text-2xl">Create Trip Budget</h3>
                <p class="text-muted text-sm mb-6">Enter your destination and total budget. AI will optimize and predict the best distribution.</p>
                
                <form action="${pageContext.request.contextPath}/budget" method="post">
                    <input type="hidden" name="action" value="create_budget">
                    
                    <div class="form-group mb-4 text-left">
                        <label class="text-xs text-muted font-bold uppercase tracking-wider block mb-2">Destination</label>
                        <input type="text" name="destination" class="form-control" placeholder="e.g., Goa" required>
                    </div>
                    
                    <div class="form-group mb-6 text-left">
                        <label class="text-xs text-muted font-bold uppercase tracking-wider block mb-2">Total Budget (₹)</label>
                        <input type="number" name="total_budget" class="form-control text-2xl font-mono" placeholder="50000" required>
                    </div>
                    
                    <button type="submit" class="btn btn-primary w-full py-3 rounded-full font-bold text-lg"><i class="ri-magic-line mr-2"></i>Generate Smart Plan</button>
                </form>
            </div>
        </c:when>

        <c:otherwise>
            <!-- Financial Dashboard -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 slide-up delay-1">
                
                <!-- Left Column: Summary & Gauges -->
                <div class="flex flex-col gap-6">
                    <div class="glass-panel p-6 rounded-3xl text-center relative overflow-hidden">
                        <div class="absolute -right-10 -top-10 w-40 h-40 bg-primary/20 rounded-full blur-3xl"></div>
                        <h3 class="text-muted font-bold mb-1">Total Trip Budget</h3>
                        <h2 class="text-4xl font-mono font-bold text-main mb-4">₹${budgetPlan.total_budget}</h2>
                        <div class="bg-white/5 border border-white/10 rounded-xl p-3 flex justify-between items-center text-sm">
                            <span class="text-muted">Destination</span>
                            <span class="text-main font-bold">${budgetPlan.destination}</span>
                        </div>
                    </div>

                    <!-- Budget Health Score -->
                    <div class="glass-panel p-6 rounded-3xl flex flex-col items-center justify-center">
                        <h3 class="text-main font-bold mb-4 w-full text-left">Budget Health Score</h3>
                        <div class="relative w-40 h-40">
                            <!-- Simple SVG Gauge -->
                            <svg class="w-full h-full transform -rotate-90" viewBox="0 0 36 36">
                                <path class="text-white/10" stroke-width="3" stroke="currentColor" fill="none" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />
                                <path class="text-${budgetPlan.health_score > 50 ? 'green' : 'red'}-400 transition-all duration-1000 ease-out" stroke-dasharray="${budgetPlan.health_score}, 100" stroke-width="3" stroke-linecap="round" stroke="currentColor" fill="none" d="M18 2.0845 a 15.9155 15.9155 0 0 1 0 31.831 a 15.9155 15.9155 0 0 1 0 -31.831" />
                            </svg>
                            <div class="absolute inset-0 flex flex-col items-center justify-center">
                                <span class="text-3xl font-bold text-main">${budgetPlan.health_score}</span>
                                <span class="text-xs text-muted">/ 100</span>
                            </div>
                        </div>
                        <p class="text-sm mt-4 text-${budgetPlan.health_score > 50 ? 'green' : 'red'}-400 font-bold">
                            ${budgetPlan.health_score > 80 ? 'Excellent' : budgetPlan.health_score > 50 ? 'Good' : 'Critical'} Status
                        </p>
                    </div>

                    <!-- AI Savings Recommendations -->
                    <div class="glass-panel p-6 rounded-3xl bg-primary/5 border border-primary/20">
                        <h3 class="text-primary font-bold mb-4 flex items-center"><i class="ri-lightbulb-flash-line mr-2"></i>AI Recommendation</h3>
                        <p class="text-sm text-main leading-relaxed">
                            "You can save <span class="text-green-400 font-bold">₹4,500</span> by choosing a hidden beach hotel instead of a beachfront property in ${budgetPlan.destination}. Also, flight prices are expected to drop by 5% next week."
                        </p>
                    </div>
                </div>

                <!-- Middle Column: Distribution & Predictions -->
                <div class="flex flex-col gap-6 lg:col-span-2">
                    
                    <!-- Predictions -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <div class="glass-panel p-5 rounded-2xl border border-green-500/20">
                            <h4 class="text-xs text-muted uppercase tracking-wider font-bold mb-1">Best Case Cost</h4>
                            <p class="text-2xl font-mono font-bold text-green-400">₹${prediction.best_case}</p>
                        </div>
                        <div class="glass-panel p-5 rounded-2xl border border-primary/20 relative overflow-hidden">
                            <div class="absolute right-0 top-0 bg-primary text-white text-[10px] font-bold px-2 py-1 rounded-bl-lg">EXPECTED</div>
                            <h4 class="text-xs text-muted uppercase tracking-wider font-bold mb-1">Expected Cost</h4>
                            <p class="text-2xl font-mono font-bold text-main">₹${prediction.expected}</p>
                        </div>
                        <div class="glass-panel p-5 rounded-2xl border border-red-500/20">
                            <h4 class="text-xs text-muted uppercase tracking-wider font-bold mb-1">Worst Case Cost</h4>
                            <p class="text-2xl font-mono font-bold text-red-400">₹${prediction.worst_case}</p>
                        </div>
                    </div>

                    <!-- AI Distribution Chart -->
                    <div class="glass-panel p-6 rounded-3xl h-80 flex items-center justify-center relative">
                        <div class="absolute top-6 left-6">
                            <h3 class="text-main font-bold">AI Budget Distribution</h3>
                            <p class="text-xs text-muted">Optimized based on millions of travel data points.</p>
                        </div>
                        <div class="w-full h-full pt-12 pb-4">
                            <canvas id="budgetPieChart"></canvas>
                        </div>
                    </div>

                    <!-- Live Expenses Tracker -->
                    <div class="glass-panel p-6 rounded-3xl">
                        <div class="flex justify-between items-center mb-6">
                            <h3 class="text-main font-bold">Live Expense Tracker</h3>
                            <button class="btn btn-primary btn-sm rounded-full" onclick="document.getElementById('addExpenseModal').style.display='flex'">
                                <i class="ri-add-line mr-1"></i>Log Expense
                            </button>
                        </div>
                        
                        <div class="mb-6">
                            <div class="flex justify-between text-sm mb-2">
                                <span class="text-main font-bold">Spent: ₹${totalSpent}</span>
                                <span class="text-muted font-bold">Remaining: ₹${remaining}</span>
                            </div>
                            <div class="w-full bg-white/10 rounded-full h-3">
                                <div class="bg-gradient-to-r from-primary to-purple-500 h-3 rounded-full" style="width: ${(totalSpent / budgetPlan.total_budget) * 100}%"></div>
                            </div>
                        </div>

                        <div class="flex flex-col gap-3 max-h-60 overflow-y-auto custom-scrollbar pr-2">
                            <c:if test="${empty expenses}">
                                <div class="text-center p-6 text-muted border border-dashed border-white/10 rounded-xl">No expenses logged yet.</div>
                            </c:if>
                            <c:forEach var="exp" items="${expenses}">
                                <div class="flex justify-between items-center p-3 hover:bg-white/5 rounded-xl border border-white/5">
                                    <div class="flex items-center gap-3">
                                        <div class="w-10 h-10 rounded-full bg-primary/10 text-primary flex items-center justify-center">
                                            <i class="ri-receipt-line"></i>
                                        </div>
                                        <div>
                                            <h4 class="text-main font-bold text-sm">${exp.description}</h4>
                                            <p class="text-xs text-muted">${exp.category}</p>
                                        </div>
                                    </div>
                                    <div class="text-right">
                                        <h4 class="text-main font-bold font-mono">₹${exp.amount}</h4>
                                        <p class="text-xs text-muted">${exp.created_at.toString().substring(0, 10)}</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                </div>
            </div>

            <!-- Add Expense Modal -->
            <div id="addExpenseModal" class="fixed inset-0 bg-black/80 backdrop-blur-sm z-50 hidden flex-col items-center justify-center p-4">
                <div class="glass-panel p-6 rounded-3xl max-w-md w-full relative slide-up">
                    <button class="absolute top-4 right-4 text-muted hover:text-white" onclick="document.getElementById('addExpenseModal').style.display='none'"><i class="ri-close-line text-2xl"></i></button>
                    <h3 class="text-main font-bold mb-6 text-xl">Log Live Expense</h3>
                    <form action="${pageContext.request.contextPath}/budget" method="post">
                        <input type="hidden" name="action" value="add_expense">
                        <input type="hidden" name="plan_id" value="${budgetPlan.id}">
                        
                        <div class="form-group mb-4">
                            <label class="text-xs text-muted font-bold uppercase tracking-wider block mb-2">Category</label>
                            <select name="category" class="form-control" required>
                                <option value="Flights">Flights</option>
                                <option value="Hotel">Hotel</option>
                                <option value="Food">Food</option>
                                <option value="Activities">Activities</option>
                                <option value="Transportation">Transportation</option>
                                <option value="Emergency">Emergency / Misc</option>
                            </select>
                        </div>
                        
                        <div class="form-group mb-4">
                            <label class="text-xs text-muted font-bold uppercase tracking-wider block mb-2">Description</label>
                            <input type="text" name="description" class="form-control" placeholder="e.g., Seafood Dinner" required>
                        </div>
                        
                        <div class="form-group mb-6">
                            <label class="text-xs text-muted font-bold uppercase tracking-wider block mb-2">Amount (₹)</label>
                            <input type="number" step="0.01" name="amount" class="form-control text-2xl font-mono" placeholder="0.00" required>
                        </div>
                        
                        <button type="submit" class="btn btn-primary w-full py-3 rounded-full font-bold">Save Expense</button>
                    </form>
                </div>
            </div>

            <script>
                // Initialize Chart.js
                document.addEventListener("DOMContentLoaded", function() {
                    const ctx = document.getElementById('budgetPieChart');
                    if (ctx) {
                        new Chart(ctx, {
                            type: 'doughnut',
                            data: {
                                labels: ['Flights', 'Hotel', 'Food', 'Activities', 'Transport', 'Emergency'],
                                datasets: [{
                                    data: [
                                        ${budgetPlan.flights}, 
                                        ${budgetPlan.hotel}, 
                                        ${budgetPlan.food}, 
                                        ${budgetPlan.activities}, 
                                        ${budgetPlan.transportation}, 
                                        ${budgetPlan.emergency}
                                    ],
                                    backgroundColor: [
                                        '#6d28d9', // purple-700
                                        '#8b5cf6', // purple-500
                                        '#a78bfa', // purple-400
                                        '#c4b5fd', // purple-300
                                        '#ede9fe', // purple-100
                                        '#ef4444'  // red-500 (emergency)
                                    ],
                                    borderWidth: 0,
                                    hoverOffset: 4
                                }]
                            },
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                cutout: '70%',
                                plugins: {
                                    legend: {
                                        position: 'right',
                                        labels: {
                                            color: '#9ca3af',
                                            font: {
                                                family: "'Inter', sans-serif",
                                                size: 12
                                            }
                                        }
                                    }
                                }
                            }
                        });
                    }
                });
            </script>
        </c:otherwise>
    </c:choose>

</main>

<%@ include file="/components/footer.jsp" %>
