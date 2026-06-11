<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/components/header.jsp" %>
<%@ include file="/components/global_ui.jsp" %>

<main style="padding-top: 100px; padding-bottom: 60px; min-height: 80vh; background: var(--color-background);">
    <div class="container mx-auto px-4">
        
        <div class="booking-widget-wrapper" style="background: var(--color-surface); backdrop-filter: blur(20px); border-radius: 12px; box-shadow: 0 4px 32px rgba(0,0,0,0.28); max-width: 1000px; margin: 0 auto;">
            
            <div style="padding: 24px; border-bottom: 1px solid var(--color-border);">
                <h2 class="text-2xl font-bold text-white flex items-center gap-2">
                    <span>🚆</span> Train Search
                </h2>
                <p class="text-gray-400 text-sm mt-1">Book your next journey across India</p>
            </div>

            <div style="padding: 30px;">
                <form action="<%=request.getContextPath()%>/transport/train/booking" method="post" id="trainSearchForm" class="flex flex-col gap-6" onsubmit="return validateTrainSearch()">
                    
                    <!-- ROW 1: From, To, Date -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4 relative">
                        <div style="position: relative;">
                            <label class="block text-sm font-medium mb-1 text-white">From Station</label>
                            <input type="text" name="fromStation" id="fromStation" class="input-field w-full text-black placeholder-gray-500" placeholder="e.g. NDLS (New Delhi)" required>
                            <button type="button" onclick="swapStations()" style="position: absolute; right: -25px; top: 32px; z-index: 10; background: var(--color-surface); color: var(--color-primary); border-radius: 50%; width: 34px; height: 34px; display: flex; align-items: center; justify-content: center; font-weight: bold; border: 1px solid var(--color-border); cursor: pointer; box-shadow: 0 2px 8px rgba(0,0,0,0.2);">⇄</button>
                        </div>
                        <div>
                            <label class="block text-sm font-medium mb-1 text-white" style="padding-left: 10px;">To Station</label>
                            <input type="text" name="toStation" id="toStation" class="input-field w-full text-black placeholder-gray-500" placeholder="e.g. BCT (Mumbai Central)" style="margin-left: 10px;" required>
                        </div>
                        <div>
                            <label class="block text-sm font-medium mb-1 text-white">Journey Date</label>
                            <input type="date" name="journeyDate" id="journeyDate" class="input-field w-full text-black" required>
                        </div>
                    </div>

                    <!-- ROW 2: Class, Quota -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-sm font-medium mb-1 text-white">Class</label>
                            <select name="trainClass" id="trainClass" class="input-field w-full text-black">
                                <option value="All">All Classes</option>
                                <option value="General">General (GEN)</option>
                                <option value="Sleeper">Sleeper (SL)</option>
                                <option value="3A">AC 3 Tier (3A)</option>
                                <option value="2A">AC 2 Tier (2A)</option>
                                <option value="1A">AC First Class (1A)</option>
                                <option value="CC">AC Chair Car (CC)</option>
                                <option value="EC">Exec Chair Car (EC)</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-medium mb-1 text-white">Quota</label>
                            <select name="quota" id="quota" class="input-field w-full text-black">
                                <option value="General">General</option>
                                <option value="Tatkal">Tatkal</option>
                                <option value="Premium Tatkal">Premium Tatkal</option>
                                <option value="Ladies">Ladies</option>
                                <option value="Senior Citizen">Senior Citizen</option>
                            </select>
                        </div>
                    </div>

                    <!-- Error Message Display -->
                    <div id="formError" class="hidden" style="color: #ff4d4d; font-size: 0.9rem; padding: 10px; background: rgba(255, 77, 77, 0.1); border-radius: 6px; border: 1px solid rgba(255, 77, 77, 0.3);">
                        <!-- Error text goes here -->
                    </div>

                    <!-- POPULAR ROUTES -->
                    <div class="mt-4 border-t border-gray-600 border-opacity-30 pt-4 flex items-center flex-wrap gap-2">
                        <span class="text-sm text-gray-400 font-medium mr-2">Popular Routes:</span>
                        <button type="button" class="text-xs bg-white bg-opacity-10 hover:bg-opacity-20 text-white py-1.5 px-3 rounded-full transition" onclick="fillRoute('NDLS', 'BCT')">Delhi → Mumbai</button>
                        <button type="button" class="text-xs bg-white bg-opacity-10 hover:bg-opacity-20 text-white py-1.5 px-3 rounded-full transition" onclick="fillRoute('NDLS', 'HWH')">Delhi → Howrah</button>
                        <button type="button" class="text-xs bg-white bg-opacity-10 hover:bg-opacity-20 text-white py-1.5 px-3 rounded-full transition" onclick="fillRoute('MAS', 'SBC')">Chennai → Bangalore</button>
                    </div>

                    <!-- Submit Button -->
                    <div class="mt-2 text-center">
                        <button type="submit" class="btn-primary w-full py-4 px-6 rounded-lg text-lg font-bold uppercase tracking-wider" style="background: var(--color-primary); color: #000; box-shadow: 0 4px 15px rgba(255, 215, 0, 0.4);">
                            Search Trains
                        </button>
                    </div>
                </form>
            </div>

        </div>
    </div>
</main>

<script>
    // Validation Logic
    function validateTrainSearch() {
        const fromStation = document.getElementById('fromStation').value.trim();
        const toStation = document.getElementById('toStation').value.trim();
        const journeyDate = document.getElementById('journeyDate').value;
        const errorDiv = document.getElementById('formError');
        
        errorDiv.classList.add('hidden');
        errorDiv.innerText = '';

        if (fromStation === '' || toStation === '') {
            errorDiv.innerText = 'Both From and To stations are required.';
            errorDiv.classList.remove('hidden');
            return false;
        }

        if (fromStation.toLowerCase() === toStation.toLowerCase()) {
            errorDiv.innerText = 'From and To stations cannot be the same.';
            errorDiv.classList.remove('hidden');
            return false;
        }

        if (!journeyDate) {
            errorDiv.innerText = 'Please select a valid journey date.';
            errorDiv.classList.remove('hidden');
            return false;
        }

        const selectedDate = new Date(journeyDate);
        const today = new Date();
        today.setHours(0,0,0,0);

        if (selectedDate < today) {
            errorDiv.innerText = 'Journey date cannot be in the past.';
            errorDiv.classList.remove('hidden');
            return false;
        }

        return true;
    }

    function swapStations() {
        const from = document.getElementById('fromStation');
        const to = document.getElementById('toStation');
        const temp = from.value;
        from.value = to.value;
        to.value = temp;
    }

    function fillRoute(fromStn, toStn) {
        document.getElementById('fromStation').value = fromStn;
        document.getElementById('toStation').value = toStn;
    }

    // Set minimum date to today
    window.onload = function() {
        const dateInput = document.getElementById('journeyDate');
        const today = new Date().toISOString().split('T')[0];
        dateInput.setAttribute('min', today);
    }
</script>

<%@ include file="/components/footer.jsp" %>
