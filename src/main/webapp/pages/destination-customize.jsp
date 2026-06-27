<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<style>
.customize-hero {
    position: relative;
    width: 100%;
    min-height: 40vh;
    display: flex;
    align-items: center;
    justify-content: center;
    background-size: cover;
    background-position: center;
    background-image: url('${not empty destination.imageUrl ? destination.imageUrl : "https://images.unsplash.com/photo-1542332213-31f87348057f"}');
    padding-top: 80px;
}
.customize-hero-overlay {
    position: absolute;
    inset: 0;
    background: linear-gradient(to bottom, rgba(0,0,0,0.5) 0%, rgba(15,11,8,0.9) 100%);
    z-index: 1;
}
.customize-hero-content {
    position: relative;
    z-index: 2;
    text-align: center;
    max-width: 800px;
}
</style>

<main>
    <section class="customize-hero">
        <div class="customize-hero-overlay"></div>
        <div class="customize-hero-content">
            <h1 class="text-4xl font-bold text-white mb-2 editorial">Customize Your ${destination.title} Trip</h1>
            <p class="text-lg text-gray-300">Tailor your experience exactly the way you want it.</p>
        </div>
    </section>

    <div class="container my-12 grid grid-cols-1 md:grid-cols-3 gap-8">
        
        <div class="md:col-span-2">
            <div class="glass-panel p-8 rounded-2xl border border-gray-100 dark:border-gray-800">
                <form id="customizeForm" action="${pageContext.request.contextPath}/destination/booking" method="POST">
                    <input type="hidden" name="destination_id" value="${destination.id}">
                    <input type="hidden" id="base_price" value="${destination.discountPrice != null && destination.discountPrice > 0 ? destination.discountPrice : destination.priceInr}">
                    <input type="hidden" id="final_price" name="final_price" value="">

                    <h3 class="text-xl font-bold text-main mb-6">Trip Details</h3>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                        <div>
                            <label class="block text-sm font-medium text-muted mb-2">Travel Date</label>
                            <input type="date" name="travel_date" class="w-full bg-surface border border-border rounded-lg p-3 text-main" required>
                        </div>
                        <div>
                            <label class="block text-sm font-medium text-muted mb-2">Travellers</label>
                            <select name="travellers" id="travellers" class="w-full bg-surface border border-border rounded-lg p-3 text-main" onchange="updatePricing()">
                                <option value="1">1 Traveller</option>
                                <option value="2" selected>2 Travellers</option>
                                <option value="3">3 Travellers</option>
                                <option value="4">4 Travellers</option>
                                <option value="5">5 Travellers</option>
                            </select>
                        </div>
                    </div>

                    <hr class="border-border my-6">

                    <h3 class="text-xl font-bold text-main mb-4">Accommodation Preference</h3>
                    <div class="flex flex-col gap-3 mb-6">
                        <label class="flex items-center gap-3 p-3 border border-border rounded-lg cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800">
                            <input type="radio" name="hotel_category" value="standard" checked onchange="updatePricing()">
                            <span class="text-main font-medium">Standard (3-Star)</span>
                            <span class="ml-auto text-muted">Included</span>
                        </label>
                        <label class="flex items-center gap-3 p-3 border border-border rounded-lg cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800">
                            <input type="radio" name="hotel_category" value="premium" onchange="updatePricing()">
                            <span class="text-main font-medium">Premium (4-Star)</span>
                            <span class="ml-auto text-primary">+ ₹5,000 / person</span>
                        </label>
                        <label class="flex items-center gap-3 p-3 border border-border rounded-lg cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800">
                            <input type="radio" name="hotel_category" value="luxury" onchange="updatePricing()">
                            <span class="text-main font-medium">Luxury (5-Star)</span>
                            <span class="ml-auto text-primary">+ ₹12,000 / person</span>
                        </label>
                    </div>

                    <hr class="border-border my-6">

                    <h3 class="text-xl font-bold text-main mb-4">Activities & Add-ons</h3>
                    <div class="flex flex-col gap-3 mb-8">
                        <label class="flex items-center gap-3 p-3 border border-border rounded-lg cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800">
                            <input type="checkbox" name="activities" value="sightseeing" checked disabled>
                            <span class="text-main font-medium">Basic Sightseeing</span>
                            <span class="ml-auto text-muted">Included</span>
                        </label>
                        <label class="flex items-center gap-3 p-3 border border-border rounded-lg cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800">
                            <input type="checkbox" name="activities" value="spa" class="addon-checkbox" data-price="3500" onchange="updatePricing()">
                            <span class="text-main font-medium">Couples Spa Session</span>
                            <span class="ml-auto text-primary">+ ₹3,500</span>
                        </label>
                        <label class="flex items-center gap-3 p-3 border border-border rounded-lg cursor-pointer hover:bg-gray-50 dark:hover:bg-gray-800">
                            <input type="checkbox" name="activities" value="adventure" class="addon-checkbox" data-price="5000" onchange="updatePricing()">
                            <span class="text-main font-medium">Adventure Sports Package</span>
                            <span class="ml-auto text-primary">+ ₹5,000</span>
                        </label>
                    </div>

                    <button type="button" onclick="VoyastraAuth.requireAuthAndSubmit('customizeForm')" class="btn btn-primary w-full text-lg py-4">Proceed to Review</button>
                </form>
            </div>
        </div>

        <div class="md:col-span-1">
            <div class="glass-panel p-6 rounded-2xl border border-gray-100 dark:border-gray-800 sticky top-24">
                <h3 class="text-xl font-bold text-main mb-4">Price Summary</h3>
                <div class="flex flex-col gap-4 text-sm">
                    <div class="flex justify-between">
                        <span class="text-muted">Base Price (<span id="summary_travellers">2</span> Travellers)</span>
                        <span class="text-main font-bold" id="summary_base_price">₹0</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-muted">Hotel Upgrade</span>
                        <span class="text-main font-bold" id="summary_hotel_price">₹0</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-muted">Add-ons</span>
                        <span class="text-main font-bold" id="summary_addon_price">₹0</span>
                    </div>
                    <hr class="border-border my-2">
                    <div class="flex justify-between items-center">
                        <span class="text-lg font-bold text-main">Total Package</span>
                        <span class="text-2xl font-bold text-primary" id="summary_total_price">₹0</span>
                    </div>
                </div>
            </div>
        </div>

    </div>
</main>

<script>
    function formatCurrency(amount) {
        return '₹' + parseInt(amount).toLocaleString('en-IN');
    }

    function updatePricing() {
        const basePricePerPerson = parseFloat(document.getElementById('base_price').value);
        const travellers = parseInt(document.getElementById('travellers').value);
        
        // Hotel pricing
        let hotelUpgradePerPerson = 0;
        const hotelCategory = document.querySelector('input[name="hotel_category"]:checked').value;
        if (hotelCategory === 'premium') hotelUpgradePerPerson = 5000;
        else if (hotelCategory === 'luxury') hotelUpgradePerPerson = 12000;

        // Addons pricing
        let addonsTotal = 0;
        document.querySelectorAll('.addon-checkbox:checked').forEach(cb => {
            addonsTotal += parseFloat(cb.getAttribute('data-price'));
        });

        const totalBase = basePricePerPerson * travellers;
        const totalHotel = hotelUpgradePerPerson * travellers;
        const finalTotal = totalBase + totalHotel + addonsTotal;

        // Update UI
        document.getElementById('summary_travellers').textContent = travellers;
        document.getElementById('summary_base_price').textContent = formatCurrency(totalBase);
        document.getElementById('summary_hotel_price').textContent = formatCurrency(totalHotel);
        document.getElementById('summary_addon_price').textContent = formatCurrency(addonsTotal);
        document.getElementById('summary_total_price').textContent = formatCurrency(finalTotal);

        document.getElementById('final_price').value = finalTotal;
    }

    // Initialize
    document.addEventListener('DOMContentLoaded', updatePricing);
</script>

<%@ include file="/components/footer.jsp" %>
