<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

                <%@ include file="/components/header.jsp" %>

                <%@ include file="/components/global_ui.jsp" %>

                    <style>
                        .logo-train { background: var(--color-accent) !important; }
                        .logo-cab-bus { background: #374151 !important; font-size: 1.1rem !important; }
                        .bg-villa { background: var(--color-accent) !important; }
                        .bg-primary { background: var(--color-primary) !important; }
                        .text-accent { color: var(--color-accent) !important; }
                        .btn-villa { background: var(--color-accent) !important; }
                    </style>

                    <main style="padding-top: 80px; padding-bottom: 60px; overflow-x: hidden;">

                        <!-- ===== MMT-STYLE BOOKING HERO ===== -->
                        <div class="booking-hero-section" style="padding: 28px 0 0;">
                            <div class="container">

                                <!-- MASTER BOOKING WIDGET -->
                                <div class="booking-widget-wrapper"
                                    style="background: var(--color-surface); backdrop-filter: blur(20px); border-radius: 12px; box-shadow: 0 4px 32px rgba(0,0,0,0.28); margin-bottom: 32px;">

                                    <!-- Tab Bar (MMT Style - horizontal, tight) -->
                                    <div class="booking-tab-bar"
                                        style="display: flex; align-items: center; overflow-x: auto; border-bottom: 2px solid var(--color-border); padding: 0 8px; background: rgba(255,255,255,0.03);">
                                        <button class="booking-tab active" data-form="form-flights" onclick="switchTab(this, 'form-flights')">
                                            <span class="tab-icon">✈️</span><span class="tab-label">Flights</span>
                                        </button>
                                        <button class="booking-tab" data-form="form-hotels" onclick="switchTab(this, 'form-hotels')">
                                            <span class="tab-icon">🏨</span><span class="tab-label">Hotels</span>
                                        </button>
                                        <button class="booking-tab" data-form="form-trains" onclick="switchTab(this, 'form-trains')">
                                            <span class="tab-icon">🚆</span><span class="tab-label">Trains</span>
                                        </button>
                                        <button class="booking-tab" data-form="form-buses" onclick="switchTab(this, 'form-buses')">
                                            <span class="tab-icon">🚌</span><span class="tab-label">Buses</span>
                                        </button>
                                        <button class="booking-tab" data-form="form-cabs" onclick="switchTab(this, 'form-cabs')">
                                            <span class="tab-icon">🚕</span><span class="tab-label">Cabs</span>
                                        </button>
                                        <button class="booking-tab" data-form="form-cars" onclick="switchTab(this, 'form-cars')">
                                            <span class="tab-icon">🚗</span><span class="tab-label">Self Drive</span>
                                        </button>
                                        <button class="booking-tab" data-form="form-cruises" onclick="switchTab(this, 'form-cruises')">
                                            <span class="tab-icon">🚢</span><span class="tab-label">Cruises</span>
                                        </button>
                                        <button class="booking-tab" data-form="form-helicopter" onclick="switchTab(this, 'form-helicopter')">
                                            <span class="tab-icon">🚁</span><span class="tab-label">Helicopter</span>
                                        </button>
                                        <button class="booking-tab" data-form="form-tours" onclick="switchTab(this, 'form-tours')">
                                            <span class="tab-icon">🎫</span><span class="tab-label">Tours</span>
                                        </button>
                                        <button class="booking-tab" data-form="form-packages" onclick="switchTab(this, 'form-packages')">
                                            <span class="tab-icon">📦</span><span class="tab-label">Packages</span>
                                        </button>
                                    </div>

                                    <!-- Search Forms Area -->
                                    <div style="padding: 20px 24px 24px;">

                                        <!-- FLIGHTS FORM -->
                                        <div id="form-flights" class="booking-form active">
                                            <form action="${pageContext.request.contextPath}/search" method="get" id="flightSearchForm" class="flex flex-col gap-4">
                                                <input type="hidden" name="type" value="flight">
                                                <input type="hidden" name="seatClass" id="seatClassHidden" value="${not empty searchSeatClassRaw ? searchSeatClassRaw : 'economy'}">
                                                <input type="hidden" name="adultCount" id="adultCountHidden" value="${not empty searchAdultCount ? searchAdultCount : '1'}">
                                                <input type="hidden" name="childCount" id="childCountHidden" value="${not empty searchChildCount ? searchChildCount : '0'}">
                                                <input type="hidden" name="infantCount" id="infantCountHidden" value="${not empty searchInfantCount ? searchInfantCount : '0'}">
                                                
                                                <!-- ROW 1: From, To, Date -->
                                                <div class="grid grid-cols-1 md:grid-cols-3 gap-4 relative">
                                                    <div style="position: relative;">
                                                        <label class="block text-sm font-medium mb-1 text-white">From City</label>
                                                        <input type="text" name="from" id="flightFrom" value="${from != null ? from : 'Delhi'}" class="input-field w-full text-black placeholder-gray-500" placeholder="Origin">
                                                        <button type="button" onclick="swapFlightCities()" style="position: absolute; right: -25px; top: 32px; z-index: 10; background: var(--color-surface); color: var(--color-primary); border-radius: 50%; width: 34px; height: 34px; display: flex; align-items: center; justify-content: center; font-weight: bold; border: 1px solid var(--color-border); cursor: pointer; box-shadow: 0 2px 8px rgba(0,0,0,0.2);">⇄</button>
                                                    </div>
                                                    <div>
                                                        <label class="block text-sm font-medium mb-1 text-white" style="padding-left: 10px;">To City</label>
                                                        <input type="text" name="to" id="flightTo" value="${to != null ? to : 'Mumbai'}" class="input-field w-full text-black placeholder-gray-500" placeholder="Destination" style="margin-left: 10px;">
                                                    </div>
                                                    <div>
                                                        <label class="block text-sm font-medium mb-1 text-white">Departure Date</label>
                                                        <input type="date" name="date" class="input-field w-full text-black" value="${date}" required>
                                                    </div>
                                                </div>

                                                <!-- ROW 2: Trip Type, Travellers, Seat Class -->
                                                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                                    <div>
                                                        <label class="block text-sm font-medium mb-1 text-white">Trip Type</label>
                                                        <select name="tripType" id="flightTripType" class="input-field w-full text-black" onchange="toggleReturnDate()">
                                                            <option value="one-way">One Way</option>
                                                            <option value="round-trip">Round Trip</option>
                                                            <option value="multi-city">Multi City</option>
                                                        </select>
                                                    </div>
                                                    
                                                    <div style="position: relative;">
                                                        <label class="block text-sm font-medium mb-1 text-white">Travellers</label>
                                                        <div class="input-field w-full text-black bg-white flex items-center justify-between cursor-pointer" onclick="toggleTravellersPanel(event)" style="min-height: 48px;">
                                                            <span id="travellersDisplay">1 Adult, 0 Children, 0 Infants</span>
                                                            <span style="color:var(--color-muted);font-size:0.75rem;">▼</span>
                                                        </div>
                                                        <!-- Travellers Dropdown Panel -->
                                                        <div id="travellersPanel" style="display:none; position:absolute; top:100%; left:0; z-index:999; background:#1e1e2e; border:1px solid rgba(255,255,255,0.12); border-radius:12px; padding:20px; min-width:300px; box-shadow:0 8px 32px rgba(0,0,0,0.5);" onclick="event.stopPropagation()">
                                                            <!-- Adults -->
                                                            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
                                                                <div>
                                                                    <div class="text-white font-bold">Adults</div>
                                                                    <div style="color:rgba(255,255,255,0.4); font-size:0.78rem;">12+ years</div>
                                                                </div>
                                                                <div style="display:flex; align-items:center; gap:12px;">
                                                                    <button type="button" onclick="changePax('adults',-1)" style="width:30px;height:30px;border-radius:50%;border:1px solid rgba(255,255,255,0.2);background:transparent;color:white;font-size:1.2rem;cursor:pointer;line-height:1;">−</button>
                                                                    <span id="adultsCount" class="text-white font-bold">1</span>
                                                                    <button type="button" onclick="changePax('adults',1)" style="width:30px;height:30px;border-radius:50%;border:1px solid rgba(255,255,255,0.2);background:transparent;color:white;font-size:1.2rem;cursor:pointer;line-height:1;">+</button>
                                                                </div>
                                                            </div>
                                                            <!-- Children -->
                                                            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
                                                                <div>
                                                                    <div class="text-white font-bold">Children</div>
                                                                    <div style="color:rgba(255,255,255,0.4); font-size:0.78rem;">2–11 years</div>
                                                                </div>
                                                                <div style="display:flex; align-items:center; gap:12px;">
                                                                    <button type="button" onclick="changePax('children',-1)" style="width:30px;height:30px;border-radius:50%;border:1px solid rgba(255,255,255,0.2);background:transparent;color:white;font-size:1.2rem;cursor:pointer;line-height:1;">−</button>
                                                                    <span id="childrenCount" class="text-white font-bold">0</span>
                                                                    <button type="button" onclick="changePax('children',1)" style="width:30px;height:30px;border-radius:50%;border:1px solid rgba(255,255,255,0.2);background:transparent;color:white;font-size:1.2rem;cursor:pointer;line-height:1;">+</button>
                                                                </div>
                                                            </div>
                                                            <!-- Infants -->
                                                            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:16px;">
                                                                <div>
                                                                    <div class="text-white font-bold">Infants</div>
                                                                    <div style="color:rgba(255,255,255,0.4); font-size:0.78rem;">Under 2 years</div>
                                                                </div>
                                                                <div style="display:flex; align-items:center; gap:12px;">
                                                                    <button type="button" onclick="changePax('infants',-1)" style="width:30px;height:30px;border-radius:50%;border:1px solid rgba(255,255,255,0.2);background:transparent;color:white;font-size:1.2rem;cursor:pointer;line-height:1;">−</button>
                                                                    <span id="infantsCount" class="text-white font-bold">0</span>
                                                                    <button type="button" onclick="changePax('infants',1)" style="width:30px;height:30px;border-radius:50%;border:1px solid rgba(255,255,255,0.2);background:transparent;color:white;font-size:1.2rem;cursor:pointer;line-height:1;">+</button>
                                                                </div>
                                                            </div>
                                                            <button type="button" onclick="applyTravellers()" style="width:100%;margin-top:16px;padding:10px;border-radius:8px;background:var(--color-primary);color:black;font-weight:bold;border:none;cursor:pointer;font-size:0.95rem;">Apply</button>
                                                        </div>
                                                    </div>
                                                    
                                                    <div>
                                                        <label class="block text-sm font-medium mb-1 text-white">Seat Class</label>
                                                        <select name="seatClassDropdown" class="input-field w-full text-black" onchange="document.getElementById('seatClassHidden').value = this.value">
                                                            <option value="economy">Economy</option>
                                                            <option value="premium">Premium Economy</option>
                                                            <option value="business">Business</option>
                                                            <option value="first">First Class</option>
                                                        </select>
                                                    </div>
                                                    
                                                    <!-- Optional Return Date Field (Shown if Round Trip) -->
                                                    <div id="returnDateContainer" style="display:none; grid-column: span 3;">
                                                        <label class="block text-sm font-medium mb-1 text-white">Return Date</label>
                                                        <input type="date" name="returnDate" class="input-field w-full md:w-1/3 text-black">
                                                    </div>
                                                </div>

                                                <!-- ROW 3: Airline, Stops, Flexible -->
                                                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                                    <div>
                                                        <label class="block text-sm font-medium mb-1 text-white">Airline Preference</label>
                                                        <select name="airlinePref" class="input-field w-full text-black">
                                                            <option value="">Any Airline</option>
                                                            <option value="Air India">Air India</option>
                                                            <option value="IndiGo">IndiGo</option>
                                                            <option value="Vistara">Vistara</option>
                                                            <option value="SpiceJet">SpiceJet</option>
                                                        </select>
                                                    </div>
                                                    <div>
                                                        <label class="block text-sm font-medium mb-1 text-white">Stops Preference</label>
                                                        <select name="stopsPref" class="input-field w-full text-black">
                                                            <option value="any">Any Stops</option>
                                                            <option value="nonstop">Non-stop</option>
                                                            <option value="1stop">1 Stop</option>
                                                        </select>
                                                    </div>
                                                    <div class="flex items-center">
                                                        <label class="flex items-center gap-2 cursor-pointer text-white text-sm font-medium mt-4">
                                                            <input type="checkbox" name="flexibleDates" value="true" class="w-4 h-4">
                                                            My dates are flexible (+/- 3 days)
                                                        </label>
                                                    </div>
                                                </div>

                                                <!-- ROW 4: Special Fare Options -->
                                                <div class="mt-2">
                                                    <label class="block text-sm font-medium mb-2 text-white">Special Fare Options</label>
                                                    <div class="flex flex-wrap gap-4 text-white text-sm mt-2">
                                                        <label class="flex items-center gap-1 cursor-pointer"><input type="radio" name="fareType" value="regular" checked> Regular</label>
                                                        <label class="flex items-center gap-1 cursor-pointer"><input type="radio" name="fareType" value="student"> Student</label>
                                                        <label class="flex items-center gap-1 cursor-pointer"><input type="radio" name="fareType" value="senior"> Senior Citizen</label>
                                                        <label class="flex items-center gap-1 cursor-pointer"><input type="radio" name="fareType" value="armed_forces"> Armed Forces</label>
                                                        <label class="flex items-center gap-1 cursor-pointer"><input type="radio" name="fareType" value="doctor_nurse"> Doctor & Nurses</label>
                                                    </div>
                                                </div>

                                                <!-- POPULAR ROUTES -->
                                                <div class="mt-4 border-t border-gray-600 border-opacity-30 pt-4 flex items-center flex-wrap gap-2">
                                                    <span class="text-sm text-gray-400 font-medium mr-2">Popular Routes:</span>
                                                    <button type="button" class="text-xs bg-white bg-opacity-10 hover:bg-opacity-20 text-white py-1.5 px-3 rounded-full transition" onclick="fillRoute('Delhi', 'Mumbai')">Delhi → Mumbai</button>
                                                    <button type="button" class="text-xs bg-white bg-opacity-10 hover:bg-opacity-20 text-white py-1.5 px-3 rounded-full transition" onclick="fillRoute('Delhi', 'Bangalore')">Delhi → Bangalore</button>
                                                    <button type="button" class="text-xs bg-white bg-opacity-10 hover:bg-opacity-20 text-white py-1.5 px-3 rounded-full transition" onclick="fillRoute('Mumbai', 'Goa')">Mumbai → Goa</button>
                                                    <button type="button" class="text-xs bg-white bg-opacity-10 hover:bg-opacity-20 text-white py-1.5 px-3 rounded-full transition" onclick="fillRoute('Delhi', 'Dubai')">Delhi → Dubai</button>
                                                </div>

                                                <!-- ROW 5: Search Button -->
                                                <div class="mt-2">
                                                    <button type="submit" class="btn-primary w-full py-3 px-6 rounded-lg text-lg font-bold">Search Flights</button>
                                                </div>
                                            </form>
                                            
                                            <script>
                                                function swapFlightCities() {
                                                    const from = document.getElementById('flightFrom');
                                                    const to = document.getElementById('flightTo');
                                                    const temp = from.value;
                                                    from.value = to.value;
                                                    to.value = temp;
                                                }
                                                function toggleReturnDate() {
                                                    const tripType = document.getElementById('flightTripType').value;
                                                    const returnDateContainer = document.getElementById('returnDateContainer');
                                                    if (tripType === 'round-trip') {
                                                        returnDateContainer.style.display = 'block';
                                                    } else {
                                                        returnDateContainer.style.display = 'none';
                                                    }
                                                }
                                                function fillRoute(fromCity, toCity) {
                                                    document.getElementById('flightFrom').value = fromCity;
                                                    document.getElementById('flightTo').value = toCity;
                                                }
                                            </script>
                                        </div>


                                        <!-- HOTELS FORM -->
                                        <div id="form-hotels" class="booking-form">
                                            <jsp:include page="/components/hotel-search.jsp"/>
                                        </div>

                                        <!-- CARS FORM -->
                                        <div id="form-cars" class="booking-form">
                                            <form action="${pageContext.request.contextPath}/transport/car/search" method="post">
                                                <div class="trip-type-row" style="display: flex; gap: 20px; margin-bottom: 14px; flex-wrap: wrap;">
                                                    <label class="radio-label"><input type="radio" name="carType" value="outstation" checked> Outstation</label>
                                                    <label class="radio-label"><input type="radio" name="carType" value="local"> Local</label>
                                                    <label class="radio-label"><input type="radio" name="carType" value="airport"> Airport Transfer</label>
                                                </div>
                                                <div class="search-fields-row">
                                                    <div class="search-field" style="flex: 2;">
                                                        <div class="field-label">Pickup City</div>
                                                        <input type="text" name="pickupCity" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" placeholder="Enter Pickup City">
                                                        <div class="field-sub">City, airport or address</div>
                                                    </div>
                                                    <div class="search-field">
                                                        <div class="field-label">Pickup Date</div>
                                                        <input type="date" name="pickupDate" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" style="color-scheme: dark;">
                                                    </div>
                                                    <div class="search-field">
                                                        <div class="field-label">Return Date</div>
                                                        <input type="date" name="returnDate" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" style="color-scheme: dark;">
                                                    </div>
                                                    <div class="search-field" style="border-right: none; min-width: 120px;">
                                                        <div class="field-label">Car Type</div>
                                                        <select name="vehicleType" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" style="color-scheme: dark; background: transparent;">
                                                            <option value="any" style="color:black;">Any</option>
                                                            <option value="Hatchback" style="color:black;">Hatchback</option>
                                                            <option value="Sedan" style="color:black;">Sedan</option>
                                                            <option value="SUV" style="color:black;">SUV</option>
                                                            <option value="Luxury" style="color:black;">Luxury</option>
                                                            <option value="Electric" style="color:black;">Electric</option>
                                                        </select>
                                                    </div>
                                                    <button type="submit" class="search-cta-btn">SEARCH</button>
                                                </div>
                                            </form>
                                        </div>

                                        <!-- TOURS FORM -->
                                        <div id="form-tours" class="booking-form">
                                            <form action="${pageContext.request.contextPath}/search" method="get">
                                                <input type="hidden" name="type" value="tour">
                                                <div class="trip-type-row" style="display: flex; gap: 20px; margin-bottom: 14px; flex-wrap: wrap;">
                                                    <label class="radio-label"><input type="radio" name="tourType" value="adventure" checked> Adventure</label>
                                                    <label class="radio-label"><input type="radio" name="tourType" value="cultural"> Cultural</label>
                                                    <label class="radio-label"><input type="radio" name="tourType" value="beach"> Beach</label>
                                                    <label class="radio-label"><input type="radio" name="tourType" value="wildlife"> Wildlife</label>
                                                </div>
                                                <div class="search-fields-row">
                                                    <div class="search-field" style="flex: 2;">
                                                        <div class="field-label">Destination / Activity</div>
                                                        <input type="text" name="query" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" placeholder="Goa, Manali, Safari...">
                                                        <div class="field-sub">City, landmark or experience</div>
                                                    </div>
                                                    <div class="search-field">
                                                        <div class="field-label">Travel Date</div>
                                                        <input type="date" name="date" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" style="color-scheme: dark;">
                                                    </div>
                                                    <div class="search-field" style="border-right: none; min-width: 140px;">
                                                        <div class="field-label">People</div>
                                                        <select name="people" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" style="color-scheme: dark; background: transparent;">
                                                            <option value="1" style="color:black;">1 Person</option>
                                                            <option value="2" style="color:black;">2 People</option>
                                                            <option value="4" style="color:black;">4 People</option>
                                                            <option value="6" style="color:black;">6 People</option>
                                                            <option value="10" style="color:black;">10+ People</option>
                                                        </select>
                                                    </div>
                                                    <button type="submit" class="search-cta-btn">SEARCH</button>
                                                </div>
                                            </form>
                                        </div>

                                        <!-- TRAINS FORM -->
                                        <div id="form-trains" class="booking-form">
                                            <form action="${pageContext.request.contextPath}/trains" method="get">
                                                <div class="search-fields-row">
                                                    <div class="search-field" style="flex: 2;">
                                                        <div class="field-label">From Station</div>
                                                        <input type="text" name="fromStation" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" placeholder="Delhi (NDLS)">
                                                    </div>
                                                    <div class="search-field" style="flex: 2;">
                                                        <div class="field-label">To Station</div>
                                                        <input type="text" name="toStation" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" placeholder="Mumbai (BCT)">
                                                    </div>
                                                    <div class="search-field">
                                                        <div class="field-label">Journey Date</div>
                                                        <input type="date" name="journeyDate" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" style="color-scheme: dark;">
                                                    </div>
                                                    <div class="search-field" style="border-right: none; min-width: 140px;">
                                                        <div class="field-label">Class</div>
                                                        <select name="trainClass" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" style="color-scheme: dark; background: transparent;">
                                                            <option value="any" style="color:black;">Any</option>
                                                            <option value="1AC" style="color:black;">1A (First AC)</option>
                                                            <option value="2AC" style="color:black;">2A (Second AC)</option>
                                                            <option value="3AC" style="color:black;">3A (Third AC)</option>
                                                            <option value="SL" style="color:black;">SL (Sleeper)</option>
                                                        </select>
                                                    </div>
                                                    <button type="submit" class="search-cta-btn">SEARCH</button>
                                                </div>
                                            </form>
                                        </div>

                                        <!-- BUSES FORM -->
                                        <div id="form-buses" class="booking-form">
                                            <form action="${pageContext.request.contextPath}/transport/bus/search" method="post">
                                                <div class="search-fields-row">
                                                    <div class="search-field" style="flex: 2;">
                                                        <div class="field-label">From City</div>
                                                        <input type="text" name="from" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" placeholder="Delhi">
                                                    </div>
                                                    <div class="search-field" style="flex: 2;">
                                                        <div class="field-label">To City</div>
                                                        <input type="text" name="to" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" placeholder="Manali">
                                                    </div>
                                                    <div class="search-field">
                                                        <div class="field-label">Travel Date</div>
                                                        <input type="date" name="date" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" style="color-scheme: dark;">
                                                    </div>
                                                    <div class="search-field" style="border-right: none; min-width: 140px;">
                                                        <div class="field-label">Bus Type</div>
                                                        <select name="type" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" style="color-scheme: dark; background: transparent;">
                                                            <option value="any" style="color:black;">Any</option>
                                                            <option value="ac" style="color:black;">AC Sleeper</option>
                                                            <option value="nonac" style="color:black;">Non-AC</option>
                                                            <option value="seater" style="color:black;">Seater</option>
                                                        </select>
                                                    </div>
                                                    <button type="submit" class="search-cta-btn">SEARCH</button>
                                                </div>
                                            </form>
                                        </div>

                                        <!-- CABS FORM -->
                                        <div id="form-cabs" class="booking-form">
                                            <form action="${pageContext.request.contextPath}/transport/cab/search" method="post">
                                                <input type="hidden" name="tripType" value="outstation">
                                                <div class="search-fields-row">
                                                    <div class="search-field" style="flex: 2;">
                                                        <div class="field-label">Pickup Location</div>
                                                        <input type="text" name="pickup" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" placeholder="City or Airport">
                                                    </div>
                                                    <div class="search-field" style="flex: 2;">
                                                        <div class="field-label">Drop Location</div>
                                                        <input type="text" name="drop" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" placeholder="Destination">
                                                    </div>
                                                    <div class="search-field">
                                                        <div class="field-label">Pickup Date</div>
                                                        <input type="date" name="date" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" style="color-scheme: dark;">
                                                    </div>
                                                    <div class="search-field" style="border-right: none; min-width: 140px;">
                                                        <div class="field-label">Cab Type</div>
                                                        <select name="vehicleType" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" style="color-scheme: dark; background: transparent;">
                                                            <option value="any" style="color:black;">Any</option>
                                                            <option value="hatchback" style="color:black;">Hatchback</option>
                                                            <option value="sedan" style="color:black;">Sedan</option>
                                                            <option value="suv" style="color:black;">SUV</option>
                                                        </select>
                                                    </div>
                                                    <button type="submit" class="search-cta-btn">SEARCH</button>
                                                </div>
                                            </form>
                                        </div>

                                        <!-- CRUISES FORM -->
                                        <div id="form-cruises" class="booking-form">
                                            <form action="${pageContext.request.contextPath}/transport/cruise/search" method="post">
                                                <input type="hidden" name="paxCount" value="1">
                                                <div class="search-fields-row">
                                                    <div class="search-field" style="flex: 2;">
                                                        <div class="field-label">Departure Port</div>
                                                        <input type="text" name="departurePort" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" placeholder="Mumbai / Kochi">
                                                    </div>
                                                    <div class="search-field" style="flex: 2;">
                                                        <div class="field-label">Destination</div>
                                                        <input type="text" name="destination" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" placeholder="Lakshadweep, Goa...">
                                                    </div>
                                                    <div class="search-field">
                                                        <div class="field-label">Date</div>
                                                        <input type="date" name="cruiseDate" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" style="color-scheme: dark;">
                                                    </div>
                                                    <div class="search-field" style="border-right: none; min-width: 140px;">
                                                        <div class="field-label">Cabin</div>
                                                        <select name="cabinType" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" style="color-scheme: dark; background: transparent;">
                                                            <option value="interior" style="color:black;">Interior</option>
                                                            <option value="oceanview" style="color:black;">Ocean View</option>
                                                            <option value="balcony" style="color:black;">Balcony</option>
                                                            <option value="suite" style="color:black;">Suite</option>
                                                        </select>
                                                    </div>
                                                    <button type="submit" class="search-cta-btn">SEARCH</button>
                                                </div>
                                            </form>
                                        </div>

                                        <!-- HELICOPTER FORM -->
                                        <div id="form-helicopter" class="booking-form">
                                            <form action="${pageContext.request.contextPath}/transport/helicopter/search" method="post">
                                                <input type="hidden" name="flightType" value="shared">
                                                <div class="search-fields-row">
                                                    <div class="search-field" style="flex: 2;">
                                                        <div class="field-label">Origin</div>
                                                        <input type="text" name="origin" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" placeholder="Phata / Mumbai">
                                                    </div>
                                                    <div class="search-field" style="flex: 2;">
                                                        <div class="field-label">Destination</div>
                                                        <input type="text" name="destination" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" placeholder="Kedarnath / Pune">
                                                    </div>
                                                    <div class="search-field">
                                                        <div class="field-label">Date</div>
                                                        <input type="date" name="travelDate" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" style="color-scheme: dark;">
                                                    </div>
                                                    <div class="search-field" style="border-right: none; min-width: 140px;">
                                                        <div class="field-label">Passengers</div>
                                                        <select name="paxCount" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" style="color-scheme: dark; background: transparent;">
                                                            <option value="1" style="color:black;">1 Person</option>
                                                            <option value="2" style="color:black;">2 People</option>
                                                            <option value="3" style="color:black;">3 People</option>
                                                            <option value="4" style="color:black;">4 People</option>
                                                        </select>
                                                    </div>
                                                    <button type="submit" class="search-cta-btn">SEARCH</button>
                                                </div>
                                            </form>
                                        </div>

                                        <!-- PACKAGES FORM -->
                                        <div id="form-packages" class="booking-form">
                                            <form action="${pageContext.request.contextPath}/search" method="get">
                                                <input type="hidden" name="type" value="package">
                                                <div class="search-fields-row">
                                                    <div class="search-field" style="flex: 3;">
                                                        <div class="field-label">Destination City / Country</div>
                                                        <input type="text" name="city" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" placeholder="Bali, Maldives, Kerala...">
                                                    </div>
                                                    <div class="search-field">
                                                        <div class="field-label">Travel Date</div>
                                                        <input type="date" name="date" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" style="color-scheme: dark;">
                                                    </div>
                                                    <div class="search-field" style="border-right: none; min-width: 140px;">
                                                        <div class="field-label">Type</div>
                                                        <select name="tourType" class="bg-transparent text-white border-none outline-none font-bold text-lg w-full" style="color-scheme: dark; background: transparent;">
                                                            <option value="honeymoon" style="color:black;">Honeymoon</option>
                                                            <option value="family" style="color:black;">Family</option>
                                                            <option value="adventure" style="color:black;">Adventure</option>
                                                            <option value="luxury" style="color:black;">Luxury</option>
                                                        </select>
                                                    </div>
                                                    <button type="submit" class="search-cta-btn">SEARCH</button>
                                                </div>
                                            </form>
                                        </div>

                                    </div><!-- /Search Forms Area -->
                                </div><!-- /booking-widget-wrapper -->
                            </div><!-- /container -->
                        </div><!-- /booking-hero-section -->


                        <!-- ===== RESULTS SECTION ===== -->
                        <c:if test="${not empty searchType}">
                        <div class="container" style="padding-bottom: 60px;">

                            <!-- Search Summary Banner -->
                            <div style="margin-bottom: 24px; padding: 14px 20px; background: rgba(255,255,255,0.03); border-radius: 12px; border: 1px solid var(--color-border); display: flex; flex-wrap: wrap; gap: 12px; align-items: center;">
                                <span style="color: var(--color-primary); font-weight: 700; font-size: 0.9rem;">
                                    <c:choose>
                                        <c:when test="${searchType == 'flight'}">✈️ Flights: <c:out value="${searchOrigin}"/> → <c:out value="${searchDestination}"/></c:when>
                                        <c:when test="${searchType == 'hotel'}">🏨 Hotels in <c:out value="${searchLocation}"/></c:when>
                                        <c:when test="${searchType == 'car'}">🚗 Self Drive: <c:out value="${searchOrigin}"/> → <c:out value="${searchDestination}"/></c:when>
                                        <c:when test="${searchType == 'tour'}">🎫 Tours: <c:out value="${searchQuery}"/></c:when>
                                        <c:when test="${searchType == 'train'}">🚆 Trains: <c:out value="${searchOrigin}"/> → <c:out value="${searchDestination}"/></c:when>
                                        <c:when test="${searchType == 'bus'}">🚌 Buses: <c:out value="${searchOrigin}"/> → <c:out value="${searchDestination}"/></c:when>
                                        <c:when test="${searchType == 'cab'}">🚕 Cabs: <c:out value="${searchOrigin}"/> → <c:out value="${searchDestination}"/></c:when>
                                        <c:when test="${searchType == 'cruise'}">🚢 Cruises: <c:out value="${searchOrigin}"/> → <c:out value="${searchDestination}"/></c:when>
                                        <c:when test="${searchType == 'helicopter'}">🚁 Helicopter: <c:out value="${searchOrigin}"/> → <c:out value="${searchDestination}"/></c:when>
                                        <c:when test="${searchType == 'package'}">📦 Packages in <c:out value="${searchLocation}"/></c:when>
                                    </c:choose>
                                </span>
                                <c:if test="${not empty date}"><span style="color: var(--color-muted); font-size: 0.85rem;">📅 <c:out value="${date}"/></span></c:if>
                                <c:if test="${not empty searchSeatClass}"><span style="color: var(--color-muted); font-size: 0.85rem;">💺 <c:out value="${searchSeatClass}"/></span></c:if>
                                <c:if test="${not empty searchPassengers}"><span style="color: var(--color-muted); font-size: 0.85rem;">👥 <c:out value="${searchPassengers}"/> Traveller(s)</span></c:if>
                            </div>

                            <div style="display: flex; flex-direction: column; gap: 40px;">

                            <!-- ===== 1. FLIGHTS ===== -->
                            <c:if test="${searchType == 'flight' or not empty flights}">
                            <div class="results-section section-flights">
                                <div class="results-header">
                                    <h2 class="results-title">
                                        <c:choose>
                                            <c:when test="${not empty searchOrigin and not empty searchDestination}">
                                                ✈️ Flights: <c:out value="${searchOrigin}"/> ➔ <c:out value="${searchDestination}"/>
                                            </c:when>
                                            <c:otherwise>✈️ Available Flights</c:otherwise>
                                        </c:choose>
                                    </h2>
                                    <span style="color: var(--color-muted); font-size: 0.85rem;">${fn:length(flights)} result(s)</span>
                                </div>

                                <!-- Filter Bar -->
                                <div class="search-filters-bar flex flex-wrap justify-between items-center mb-6"
                                     style="background: rgba(255,255,255,0.02); padding: 12px 20px; border-radius: 12px; border: 1px solid var(--color-border); gap: 10px;">
                                    <div class="filters flex flex-wrap gap-4 items-center">
                                        <span class="text-white opacity-50 text-sm">Filters:</span>

                                        <!-- Airline Filter -->
                                        <select id="airlineFilter" onchange="applyFilters()"
                                                style="background: transparent; color: white; border: 1px solid rgba(255,255,255,0.1); border-radius: 6px; padding: 5px 10px; font-size: 0.9rem;">
                                            <option value="" style="color:black;" ${empty filterAirline ? 'selected' : ''}>All Airlines</option>
                                            <option value="Air India" style="color:black;" ${'Air India' == filterAirline ? 'selected' : ''}>Air India</option>
                                            <option value="IndiGo"    style="color:black;" ${'IndiGo'    == filterAirline ? 'selected' : ''}>IndiGo</option>
                                            <option value="Vistara"   style="color:black;" ${'Vistara'   == filterAirline ? 'selected' : ''}>Vistara</option>
                                            <option value="SpiceJet"  style="color:black;" ${'SpiceJet'  == filterAirline ? 'selected' : ''}>SpiceJet</option>
                                            <option value="GoFirst"   style="color:black;" ${'GoFirst'   == filterAirline ? 'selected' : ''}>GoFirst</option>
                                        </select>

                                        <!-- Price Range Filter -->
                                        <select id="priceFilter" onchange="applyFilters()"
                                                style="background: transparent; color: white; border: 1px solid rgba(255,255,255,0.1); border-radius: 6px; padding: 5px 10px; font-size: 0.9rem;">
                                            <option value=""      style="color:black;" ${empty filterMaxPrice        ? 'selected' : ''}>Any Price</option>
                                            <option value="5000"  style="color:black;" ${'5000'  == filterMaxPrice   ? 'selected' : ''}>Under ₹5,000</option>
                                            <option value="7000"  style="color:black;" ${'7000'  == filterMaxPrice   ? 'selected' : ''}>Under ₹7,000</option>
                                            <option value="10000" style="color:black;" ${'10000' == filterMaxPrice   ? 'selected' : ''}>Under ₹10,000</option>
                                            <option value="15000" style="color:black;" ${'15000' == filterMaxPrice   ? 'selected' : ''}>Under ₹15,000</option>
                                        </select>

                                        <!-- Stops Filter -->
                                        <select id="stopsFilter" onchange="applyFilters()"
                                                style="background: transparent; color: white; border: 1px solid rgba(255,255,255,0.1); border-radius: 6px; padding: 5px 10px; font-size: 0.9rem;">
                                            <option value="any"     style="color:black;" ${'any'     == filterStops || empty filterStops ? 'selected' : ''}>Any Stops</option>
                                            <option value="nonstop" style="color:black;" ${'nonstop' == filterStops ? 'selected' : ''}>Non-stop Only</option>
                                            <option value="1stop"   style="color:black;" ${'1stop'   == filterStops ? 'selected' : ''}>1 Stop</option>
                                        </select>
                                    </div>

                                    <div class="sorting flex gap-2 items-center">
                                        <span class="text-white opacity-50 text-sm">Sort:</span>
                                        <select id="sortSelect" onchange="applyFilters()"
                                                style="background: transparent; color: var(--color-primary); border: none; font-weight: bold; outline: none; cursor: pointer; font-size: 0.9rem;">
                                            <option value="cheapest" style="color:black;" ${'cheapest' == sortBy || empty sortBy ? 'selected' : ''}>Cheapest First</option>
                                            <option value="fastest"  style="color:black;" ${'fastest'  == sortBy ? 'selected' : ''}>Fastest First</option>
                                            <option value="best"     style="color:black;" ${'best'     == sortBy ? 'selected' : ''}>Best Match</option>
                                        </select>
                                    </div>
                                </div>


                                <!-- Flight Cards Grid -->
                                <div class="flight-results" style="display: flex; flex-direction: column; gap: 16px;" id="flightsContainer">
                                    <div style="font-size: 0.8rem; color: var(--color-primary); margin-bottom: 8px;">Debug: ${fn:length(flights)} flights loaded.</div>
                                    <c:choose>
                                        <c:when test="${not empty flights}">
                                            <c:forEach items="${flights}" var="t">
                                                <div class="flight-card"
                                                     style="display: flex; flex-direction: row; justify-content: space-between; align-items: center; padding: 24px; flex-wrap: wrap; gap: 20px; background: rgba(255,255,255,0.02); border: 1px solid var(--color-border); border-radius: 12px;"
                                                     data-airline="<c:out value='${t.companyName}'/>"
                                                     data-price="${t.price}"
                                                     data-duration="${t.duration}">

                                                    <!-- Left: Airline, Route, Time, Duration -->
                                                    <div style="display: flex; align-items: center; gap: 40px; flex-wrap: wrap;">
                                                        <!-- Airline Info -->
                                                        <div style="display: flex; align-items: center; gap: 16px; min-width: 150px;">
                                                            <div class="airline-logo"
                                                                 style="background: var(--color-primary); color: black; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; border-radius: 50%; width: 48px; height: 48px; font-weight: bold;">
                                                                <c:out value="${t.companyLogo}"/>
                                                            </div>
                                                            <div>
                                                                <div class="airline-name" style="font-weight: 800; font-size: 1.15rem; color: var(--color-main);"><c:out value="${t.companyName}"/></div>
                                                                <div class="flight-num" style="font-size: 0.85rem; color: var(--color-muted);"><c:out value="${t.transportNumber}"/></div>
                                                            </div>
                                                        </div>

                                                        <!-- Route & Time & Duration -->
                                                        <div style="display: flex; align-items: center; gap: 24px;">
                                                            <div style="text-align: right;">
                                                                <div style="font-size: 1.3rem; font-weight: 800; color: var(--color-main);"><c:out value="${t.departureTime}"/></div>
                                                                <div style="font-size: 0.85rem; color: var(--color-muted); font-weight: 600;"><c:out value="${t.originCode}"/></div>
                                                            </div>
                                                            
                                                            <div style="text-align: center; color: var(--color-muted); font-size: 0.8rem; display: flex; flex-direction: column; align-items: center; justify-content: center; gap: 4px; padding: 0 15px;">
                                                                <div class="duration-text" style="font-weight: 600;"><c:out value="${t.duration}"/></div>
                                                                <div style="color: var(--color-primary); font-weight: 600; font-size: 0.75rem;">
                                                                    <c:choose>
                                                                        <c:when test="${t.stops == 0}">Non-stop</c:when>
                                                                        <c:when test="${t.stops == 1}">1 Stop</c:when>
                                                                        <c:otherwise>${t.stops} Stops</c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                            </div>

                                                            <div style="text-align: left;">
                                                                <div style="font-size: 1.3rem; font-weight: 800; color: var(--color-main);"><c:out value="${t.arrivalTime}"/></div>
                                                                <div style="font-size: 0.85rem; color: var(--color-muted); font-weight: 600;"><c:out value="${t.destinationCode}"/></div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <!-- Right: Price & Button -->
                                                    <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 12px; min-width: 160px; text-align: right;">
                                                        <div>
                                                            <div class="result-price" style="font-size: 1.6rem; font-weight: 800; color: var(--color-primary); line-height: 1;">₹<fmt:formatNumber value="${t.price}" groupingUsed="true"/></div>
                                                            <div style="font-size: 0.75rem; color: var(--color-muted); margin-top: 4px;">
                                                                <c:out value="${not empty searchSeatClass ? searchSeatClass : 'Economy'}"/> • per adult
                                                            </div>
                                                        </div>
                                                        <c:set var="bookUrl" value="${pageContext.request.contextPath}/flight-details?type=flight&amp;id=${t.transportNumber}&amp;price=${t.price}&amp;name=${t.companyName}&amp;class=${not empty searchSeatClass ? searchSeatClass : 'economy'}&amp;from=${t.originCode}&amp;to=${t.destinationCode}&amp;date=${not empty date ? date : fn:substring(t.departureTime, 0, 10)}&amp;passengers=${not empty searchPassengers ? searchPassengers : 1}&amp;logo=${t.companyLogo}&amp;deptTime=${t.departureTime}&amp;arrTime=${t.arrivalTime}&amp;duration=${t.duration}&amp;stops=${t.stops}" />
                                                        <button class="btn-select" style="padding: 10px 24px; font-weight: 800; width: 100%; border-radius: 8px;"
                                                                onclick="location.href='${bookUrl}'">
                                                            Select →
                                                        </button>
                                                    </div>

                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="vx-empty-state"
                                                 style="padding: 48px; text-align: center; background: rgba(255,255,255,0.02); border-radius: 12px; border: 1px dashed var(--color-border);">
                                                <div style="font-size: 3rem; margin-bottom: 12px;">✈️</div>
                                                <h3 style="color: var(--color-main); margin-bottom: 8px;">No flights found</h3>
                                                <p style="color: var(--color-muted); font-size: 0.9rem;">Try different dates, airports, or a broader search.</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            </c:if>

                            <!-- ===== 2. HOTELS ===== -->
                            <div class="results-section section-stays" style="margin-top: 40px;">
                                <div class="results-header" style="margin-bottom: 16px;">
                                    <h2 class="results-title">
                                        <c:choose>
                                            <c:when test="${not empty searchLocation}">🏨 Stays in <c:out value="${searchLocation}"/></c:when>
                                            <c:when test="${not empty searchDestination}">🏨 Stays near <c:out value="${searchDestination}"/></c:when>
                                            <c:otherwise>🏨 Recommended Stays</c:otherwise>
                                        </c:choose>
                                    </h2>
                                    <span style="color: var(--color-muted); font-size: 0.85rem;">Showing top 4</span>
                                </div>
                                
                                <div class="hotel-results" style="display: flex; flex-direction: column; gap: 16px;">
                                    <c:choose>
                                        <c:when test="${not empty hotels}">
                                            <c:forEach items="${hotels}" var="s" end="3">
                                                <div class="hotel-card"
                                                     style="display: flex; flex-direction: row; gap: 24px; align-items: center; padding: 16px; background: rgba(255,255,255,0.02); border: 1px solid var(--color-border); border-radius: 12px; flex-wrap: wrap;">
                                                    
                                                    <!-- Hotel Image -->
                                                    <div style="width: 180px; height: 120px; flex-shrink: 0; border-radius: 8px; overflow: hidden; position: relative;">
                                                        <img src="${s.imageUrl}" alt="${s.name}"
                                                             style="width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s;"
                                                             onmouseover="this.style.transform='scale(1.05)'"
                                                             onmouseout="this.style.transform='scale(1)'">
                                                        <c:if test="${not empty s.badge}">
                                                            <span style="position: absolute; top: 8px; left: 8px; background: var(--color-primary); color: black; font-size: 0.65rem; font-weight: 700; padding: 4px 10px; border-radius: 20px;">
                                                                <c:out value="${s.badge}"/>
                                                            </span>
                                                        </c:if>
                                                    </div>
                                                    
                                                    <!-- Hotel Info -->
                                                    <div style="flex: 1; min-width: 200px;">
                                                        <h4 style="font-size: 1.2rem; font-weight: 800; color: var(--color-main); margin-bottom: 4px;">
                                                            <c:out value="${s.name}"/>
                                                        </h4>
                                                        <p style="font-size: 0.85rem; color: var(--color-muted); margin-bottom: 8px;">📍 <c:out value="${s.location}"/></p>
                                                        <c:if test="${not empty s.amenities}">
                                                            <p style="font-size: 0.75rem; color: var(--color-muted);">
                                                                <c:out value="${s.amenities}"/>
                                                            </p>
                                                        </c:if>
                                                    </div>
                                                    
                                                    <!-- Price & Button -->
                                                    <div style="text-align: right; min-width: 140px;">
                                                        <div style="font-size: 1.6rem; font-weight: 800; color: var(--color-primary); line-height: 1;">
                                                            ₹<fmt:formatNumber value="${s.discountedPrice}" groupingUsed="true"/>
                                                        </div>
                                                        <div style="font-size: 0.75rem; color: var(--color-muted); margin-top: 4px; margin-bottom: 12px;">per night</div>
                                                        
                                                        <button class="btn-select" style="padding: 10px 24px; font-weight: 800; width: 100%; border-radius: 8px;"
                                                                onclick="location.href='${pageContext.request.contextPath}/hotel-details?id=${s.id}'">
                                                            Book →
                                                        </button>
                                                    </div>
                                                    
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="vx-empty-state"
                                                 style="padding: 48px; text-align: center; background: rgba(255,255,255,0.02); border-radius: 12px; border: 1px dashed var(--color-border);">
                                                <div style="font-size: 3rem; margin-bottom: 12px;">🏨</div>
                                                <h3 style="color: var(--color-main); margin-bottom: 8px;">No hotels found</h3>
                                                <p style="color: var(--color-muted); font-size: 0.9rem;">Try a different city or dates.</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <!-- ===== 3. TRANSPORT / CARS / TRAINS / BUSES / CRUISES / HELICOPTER ===== -->
                            <c:if test="${searchType == 'car' or searchType == 'train' or searchType == 'bus' or searchType == 'cab' or searchType == 'cruise' or searchType == 'helicopter' or searchType == 'flight'}">
                            <div class="results-section section-transport" style="margin-top: 40px;">
                                <div class="results-header" style="margin-bottom: 16px;">
                                    <h2 class="results-title">
                                        <c:choose>
                                            <c:when test="${searchType == 'car'}">🚖 Local Transport & Transfers</c:when>
                                            <c:when test="${searchType == 'train'}">🚆 Trains</c:when>
                                            <c:when test="${searchType == 'bus'}">🚌 Buses</c:when>
                                            <c:when test="${searchType == 'cab'}">🚕 Cabs</c:when>
                                            <c:when test="${searchType == 'cruise'}">🚢 Cruises</c:when>
                                            <c:when test="${searchType == 'helicopter'}">🚁 Helicopter Transfers</c:when>
                                            <c:otherwise>🚖 Transport Options</c:otherwise>
                                        </c:choose>
                                    </h2>
                                    <span style="color: var(--color-muted); font-size: 0.85rem;">${fn:length(transportServices)} option(s)</span>
                                </div>
                                <div class="results-grid results-grid-3">
                                    <c:choose>
                                        <c:when test="${not empty transportServices}">
                                            <c:forEach items="${transportServices}" var="ts">
                                                <div class="result-card" style="display: flex; flex-direction: column; justify-content: space-between;">
                                                    <div>
                                                        <div class="result-card-header">
                                                            <div class="airline-info">
                                                                <div class="airline-logo"
                                                                     style="background: var(--surface-glass); border: 1px solid var(--color-border); font-size: 1.5rem; display: flex; align-items: center; justify-content: center; border-radius: 50%;">
                                                                    <c:out value="${ts.companyLogo}"/>
                                                                </div>
                                                                <div>
                                                                    <div class="airline-name"><c:out value="${ts.companyName}"/></div>
                                                                    <div class="flight-num"><c:out value="${ts.transportNumber}"/></div>
                                                                </div>
                                                            </div>
                                                            <c:if test="${not empty ts.badge}">
                                                                <span class="result-badge"><c:out value="${ts.badge}"/></span>
                                                            </c:if>
                                                        </div>
                                                        <!-- Route + Time -->
                                                        <div style="padding: 10px 0; border-top: 1px solid rgba(255,255,255,0.06); border-bottom: 1px solid rgba(255,255,255,0.06); margin: 8px 0;">
                                                            <div style="font-size: 0.85rem; color: var(--color-main); font-weight: 600; margin-bottom: 4px;">
                                                                <c:out value="${ts.departureTime}"/>
                                                                <c:if test="${not empty ts.duration}"> · <c:out value="${ts.duration}"/></c:if>
                                                            </div>
                                                            <c:if test="${not empty ts.originCode and ts.originCode != 'Your Location'}">
                                                                <div style="font-size: 0.75rem; color: var(--color-muted);">
                                                                    <c:out value="${ts.originCode}"/>
                                                                    <c:if test="${not empty ts.destinationCode}"> → <c:out value="${ts.destinationCode}"/></c:if>
                                                                </div>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                    <div class="result-card-footer" style="margin-top: 12px;">
                                                        <div>
                                                            <div class="result-price" style="font-size: 1.3rem;">₹<fmt:formatNumber value="${ts.price}" groupingUsed="true"/></div>
                                                            <div style="font-size: 0.7rem; color: var(--color-muted);">one way</div>
                                                        </div>
                                                        <button class="btn-select"
                                                                onclick="location.href='${pageContext.request.contextPath}/book?type=${ts.type}&id=${ts.transportNumber}&price=${ts.price}&name=${ts.companyName}'">
                                                            Select →
                                                        </button>
                                                    </div>
                                                </div>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <div style="grid-column: span 3; padding: 48px; text-align: center; background: rgba(255,255,255,0.02); border-radius: 12px; border: 1px dashed var(--color-border);">
                                                <div style="font-size: 3rem; margin-bottom: 12px;">🚖</div>
                                                <h3 style="color: var(--color-main); margin-bottom: 8px;">No transport options found</h3>
                                                <p style="color: var(--color-muted); font-size: 0.9rem;">No local transport available for this route.</p>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                            </c:if>

                            </div><!-- /flex col gap -->
                        </div><!-- /container -->
                        </c:if>

                        <!-- Right Side Map Sidebar (only on flight search) -->
                        <c:if test="${searchType == 'flight' and not empty searchType}">
                        <div style="display:none;"><!-- Map placeholder kept for future use --></div>
                        </c:if>

                    </main>


                    <script>
                        // Booking Mini Map Setup
                        function initMiniMap() {
                            if (typeof google === 'undefined') return;

                            // Custom darkish map styling
                            const customMapStyle = [
                                { elementType: "geometry", stylers: [{ color: "#242f3e" }] },
                                { elementType: "labels.text.stroke", stylers: [{ color: "#242f3e" }] },
                                { elementType: "labels.text.fill", stylers: [{ color: "#746855" }] },
                                { featureType: "water", elementType: "geometry", stylers: [{ color: "#17263c" }] },
                                { featureType: "road", elementType: "geometry", stylers: [{ color: "#38414e" }] }
                            ];

                            const map = new google.maps.Map(document.getElementById("bookingMiniMap"), {
                                zoom: 4,
                                center: { lat: 20.5937, lng: 78.9629 }, // India Map Center
                                disableDefaultUI: true,
                                styles: document.documentElement.getAttribute('data-theme') === 'dark' ? customMapStyle : []
                            });

                            const dirServ = new google.maps.DirectionsService();
                            const dirRen = new google.maps.DirectionsRenderer({
                                map: map,
                                suppressMarkers: false,
                                polylineOptions: { strokeColor: '#d4a574', strokeWeight: 4 }
                            });

                            dirServ.route({
                                origin: "New Delhi, India",
                                destination: "Mumbai, India",
                                travelMode: google.maps.TravelMode.DRIVING
                            }, (resp, stat) => {
                                if (stat === "OK") {
                                    dirRen.setDirections(resp);
                                    document.getElementById('miniMapDist').innerText = resp.routes[0].legs[0].distance.text;
                                }
                            });
                        }
                        // Request the centralized script to load Google Maps and call initMiniMap when ready
                        window.addEventListener('DOMContentLoaded', () => {
                            if (typeof loadGoogleMaps === 'function') {
                                loadGoogleMaps('initMiniMap');
                            }
                        });
                    </script>

                    <style>
                        /* ===========================
   BOOKING PAGE — DESIGN SYSTEM
   =========================== */

                        /* --- TAB BAR --- */
                        .booking-tab-bar {
                            display: flex;
                            gap: 0;
                            overflow-x: auto;
                            scrollbar-width: none;
                        }

                        .booking-tab-bar::-webkit-scrollbar {
                            display: none;
                        }

                        .booking-tab {
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            gap: 4px;
                            padding: 12px 20px 10px;
                            background: none;
                            border: none;
                            border-bottom: 3px solid transparent;
                            cursor: pointer;
                            white-space: nowrap;
                            transition: all 0.2s ease;
                            color: var(--color-muted);
                            font-size: 0.8rem;
                            font-weight: 600;
                            letter-spacing: 0.01em;
                        }

                        .booking-tab .tab-icon {
                            font-size: 1.4rem;
                            line-height: 1;
                        }

                        .booking-tab:hover {
                            color: var(--color-primary);
                            border-bottom-color: var(--color-primary);
                            background: rgba(255, 255, 255, 0.04);
                        }

                        .booking-tab.active {
                            color: var(--color-primary);
                            border-bottom-color: var(--color-primary);
                        }

                        /* --- FORMS --- */
                        .booking-form {
                            display: none;
                        }

                        .booking-form.active {
                            display: block;
                        }

                        .trip-type-row label {
                            font-size: 0.85rem;
                            color: var(--color-muted);
                            cursor: pointer;
                        }

                        .trip-type-row input {
                            accent-color: var(--color-primary);
                            margin-right: 5px;
                        }

                        /* --- SEARCH FIELDS ROW (MMT horizontal layout) --- */
                        .search-fields-row {
                            display: flex;
                            align-items: stretch;
                            gap: 0;
                            background: var(--color-surface);
                            border: 1.5px solid var(--color-border);
                            border-radius: 8px;
                            overflow: hidden;
                        }

                        .search-field {
                            display: flex;
                            flex-direction: column;
                            justify-content: center;
                            flex: 1;
                            padding: 12px 16px;
                            cursor: pointer;
                            border-right: 1.5px solid var(--color-border);
                            transition: background 0.15s ease;
                            min-width: 140px;
                        }

                        .search-field:hover {
                            background: rgba(255, 255, 255, 0.05);
                        }

                        .field-label {
                            font-size: 0.68rem;
                            font-weight: 700;
                            text-transform: uppercase;
                            letter-spacing: 0.06em;
                            color: var(--color-muted);
                            margin-bottom: 2px;
                        }

                        .field-value {
                            font-size: 1.35rem;
                            font-weight: 800;
                            color: var(--color-main);
                            line-height: 1.2;
                            white-space: nowrap;
                            overflow: hidden;
                            text-overflow: ellipsis;
                        }

                        .field-sub {
                            font-size: 0.73rem;
                            color: var(--color-muted);
                            margin-top: 1px;
                            white-space: nowrap;
                            overflow: hidden;
                            text-overflow: ellipsis;
                        }

                        /* Swap Button */
                        .swap-btn {
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            width: 36px;
                            min-width: 36px;
                            font-size: 1.1rem;
                            cursor: pointer;
                            color: var(--color-primary);
                            border-right: 1.5px solid var(--color-border);
                            transition: all 0.2s ease;
                            background: rgba(255, 255, 255, 0.03);
                        }

                        .swap-btn:hover {
                            background: var(--color-primary);
                            color: #fff;
                        }

                        /* Search CTA Button */
                        .search-cta-btn {
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            padding: 14px 28px;
                            background: var(--color-primary);
                            color: #fff;
                            border: none;
                            font-weight: 800;
                            font-size: 0.9rem;
                            letter-spacing: 0.08em;
                            cursor: pointer;
                            transition: all 0.2s ease;
                            min-width: 120px;
                            white-space: nowrap;
                        }

                        .search-cta-btn:hover {
                            background: var(--color-accent);
                            filter: brightness(1.05);
                        }

                        /* ===========================
   RESULTS SECTION
   =========================== */
                        .results-section {
                            margin-bottom: 36px;
                        }

                        .results-header {
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                            margin-bottom: 16px;
                            padding-bottom: 10px;
                            border-bottom: 1.5px solid var(--color-border);
                        }

                        .results-title {
                            font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;
                            font-size: 1.5rem;
                            font-weight: 700;
                            color: var(--color-main);
                            margin: 0;
                        }

                        .results-view-all {
                            font-size: 0.85rem;
                            font-weight: 600;
                            color: var(--color-primary);
                            text-decoration: none;
                            transition: opacity 0.2s;
                        }

                        .results-view-all:hover {
                            opacity: 0.75;
                        }

                        .results-grid {
                            display: grid;
                            gap: 16px;
                        }

                        .results-grid-2 {
                            grid-template-columns: repeat(2, 1fr);
                        }

                        .results-grid-3 {
                            grid-template-columns: repeat(3, 1fr);
                        }

                        .results-grid-4 {
                            grid-template-columns: repeat(4, 1fr);
                        }

                        /* --- VERTICAL STACKED LAYOUT FIX --- */
                        .results-container {
                            display: flex;
                            flex-direction: column;
                            gap: 24px;
                            width: 100%;
                        }

                        .results-section {
                            width: 100%;
                        }
                        /* --- RESULT CARD --- */
                        .result-card {
                            background: var(--color-surface);
                            border: 1px solid var(--color-border);
                            border-radius: 10px;
                            padding: 16px;
                            transition: box-shadow 0.2s ease, transform 0.2s ease;
                            backdrop-filter: blur(12px);
                        }

                        .result-card:hover {
                            box-shadow: 0 6px 24px rgba(0, 0, 0, 0.2);
                            transform: translateY(-2px);
                        }

                        .result-card-header {
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                            margin-bottom: 12px;
                            padding-bottom: 10px;
                            border-bottom: 1px solid var(--color-border);
                        }

                        .airline-info {
                            display: flex;
                            align-items: center;
                            gap: 10px;
                        }

                        .airline-logo {
                            width: 36px;
                            height: 36px;
                            border-radius: 50%;
                            background: var(--color-primary);
                            color: #fff;
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            font-weight: 800;
                            font-size: 0.7rem;
                            flex-shrink: 0;
                        }

                        .airline-name {
                            font-weight: 700;
                            font-size: 0.9rem;
                            color: var(--color-main);
                        }

                        .flight-num {
                            font-size: 0.72rem;
                            color: var(--color-muted);
                            margin-top: 1px;
                        }

                        .result-badge {
                            font-size: 0.65rem;
                            font-weight: 700;
                            padding: 3px 8px;
                            border-radius: 20px;
                            color: #fff;
                            background: var(--color-primary);
                            white-space: nowrap;
                        }

                        .result-badge.fastest {
                            background: #059669;
                        }

                        .flight-times {
                            display: flex;
                            align-items: center;
                            gap: 8px;
                            margin-bottom: 12px;
                            padding: 8px 0;
                        }

                        .time-block {
                            text-align: center;
                        }

                        .time {
                            font-size: 1.2rem;
                            font-weight: 800;
                            color: var(--color-main);
                        }

                        .airport {
                            font-size: 0.7rem;
                            font-weight: 600;
                            color: var(--color-muted);
                            letter-spacing: 0.04em;
                        }

                        .flight-duration {
                            flex: 1;
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            gap: 3px;
                        }

                        .duration-line {
                            width: 100%;
                            height: 1px;
                            background: var(--color-border);
                            position: relative;
                        }

                        .duration-line::before,
                        .duration-line::after {
                            content: '';
                            position: absolute;
                            top: -3px;
                            width: 7px;
                            height: 7px;
                            border-radius: 50%;
                            background: var(--color-border);
                        }

                        .duration-line::before {
                            left: 0;
                        }

                        .duration-line::after {
                            right: 0;
                        }

                        .duration-text {
                            font-size: 0.7rem;
                            color: var(--color-muted);
                            font-weight: 600;
                        }

                        .result-card-footer {
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                            padding-top: 10px;
                            border-top: 1px solid var(--color-border);
                        }

                        .result-price {
                            font-size: 1.4rem;
                            font-weight: 900;
                            color: var(--color-primary);
                        }

                        .btn-select {
                            padding: 7px 18px;
                            border-radius: 20px;
                            border: 1.5px solid var(--color-primary);
                            background: transparent;
                            color: var(--color-primary);
                            font-weight: 700;
                            font-size: 0.8rem;
                            cursor: pointer;
                            transition: all 0.2s ease;
                        }

                        .btn-select:hover {
                            background: var(--color-primary);
                            color: #fff;
                        }

                        /* --- STAY CARDS --- */
                        .stay-card {
                            min-height: 180px;
                        }

                        .stay-card-img {
                            width: 200px;
                            min-width: 200px;
                            height: 100%;
                            object-fit: cover;
                            border-radius: 0;
                        }

                        .stay-card-body {
                            flex: 1;
                            padding: 16px;
                            display: flex;
                            flex-direction: column;
                            justify-content: space-between;
                        }

                        .stay-name {
                            font-size: 1rem;
                            font-weight: 700;
                            color: var(--color-main);
                            margin: 0;
                        }

                        .stay-location {
                            font-size: 0.78rem;
                            color: var(--color-muted);
                            margin: 4px 0 8px;
                        }

                        .stay-amenities {
                            list-style: none;
                            padding: 0;
                            margin: 0 0 10px;
                        }

                        .stay-amenities li {
                            font-size: 0.75rem;
                            color: var(--color-muted);
                            padding-left: 12px;
                            position: relative;
                            margin-bottom: 2px;
                        }

                        .stay-amenities li::before {
                            content: '✓';
                            position: absolute;
                            left: 0;
                            color: var(--color-primary);
                            font-weight: 800;
                        }

                        .stay-footer {
                            display: flex;
                            align-items: flex-end;
                            justify-content: space-between;
                            padding-top: 10px;
                            border-top: 1px solid var(--color-border);
                        }

                        .original-price {
                            font-size: 0.75rem;
                            text-decoration: line-through;
                            color: var(--color-muted);
                        }

                        .discounted-price {
                            font-size: 1.4rem;
                            font-weight: 900;
                            color: var(--color-primary);
                        }

                        .btn-book {
                            padding: 9px 20px;
                            border-radius: 20px;
                            border: none;
                            background: var(--color-primary);
                            color: #fff;
                            font-weight: 700;
                            font-size: 0.82rem;
                            cursor: pointer;
                            transition: all 0.2s ease;
                        }

                        .btn-book:hover {
                            filter: brightness(1.1);
                            transform: scale(1.03);
                        }

                        /* --- ACTIVITY CARDS --- */
                        .activity-card {
                            background: var(--color-surface);
                            border: 1px solid var(--color-border);
                            border-radius: 10px;
                            overflow: hidden;
                            transition: box-shadow 0.2s ease, transform 0.2s ease;
                            cursor: pointer;
                        }

                        .activity-card:hover {
                            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.18);
                            transform: translateY(-3px);
                        }

                        .activity-img-wrap {
                            width: 100%;
                            aspect-ratio: 16/9;
                            overflow: hidden;
                        }

                        .activity-img-wrap img {
                            width: 100%;
                            height: 100%;
                            object-fit: cover;
                            transition: transform 0.4s ease;
                        }

                        .activity-card:hover .activity-img-wrap img {
                            transform: scale(1.06);
                        }

                        .activity-info {
                            padding: 12px;
                        }

                        .activity-name {
                            font-size: 0.88rem;
                            font-weight: 700;
                            color: var(--color-main);
                            margin: 0 0 4px;
                        }

                        .activity-rating {
                            font-size: 0.75rem;
                            font-weight: 600;
                            color: var(--color-accent);
                            margin-bottom: 4px;
                        }

                        .activity-price {
                            font-size: 0.95rem;
                            font-weight: 800;
                            color: var(--color-primary);
                        }

                        .activity-price span {
                            font-size: 0.72rem;
                            font-weight: 400;
                            color: var(--color-muted);
                        }

                        /* ===========================
   RESPONSIVE
   =========================== */
                        @media (max-width: 1024px) {
                            .results-grid-4 {
                                grid-template-columns: repeat(2, 1fr);
                            }
                        }

                        @media (max-width: 768px) {
                            .search-fields-row {
                                flex-direction: column;
                                border-radius: 8px;
                            }

                            .search-field {
                                border-right: none;
                                border-bottom: 1.5px solid var(--color-border);
                            }

                            .search-field:last-child {
                                border-bottom: none;
                            }

                            .swap-btn {
                                display: none;
                            }

                            .search-cta-btn {
                                width: 100%;
                                padding: 16px;
                                border-radius: 0;
                            }

                            .results-grid-2,
                            .results-grid-3 {
                                grid-template-columns: 1fr;
                            }

                            .results-grid-4 {
                                grid-template-columns: repeat(2, 1fr);
                            }

                            .stay-card {
                                flex-direction: column !important;
                            }

                            .stay-card-img {
                                width: 100% !important;
                                min-width: unset !important;
                                height: 180px !important;
                            }

                            .booking-tab {
                                padding: 10px 14px 8px;
                            }

                            .booking-tab .tab-label {
                                font-size: 0.7rem;
                            }
                        }

                        @media (max-width: 480px) {
                            .results-grid-4 {
                                grid-template-columns: 1fr;
                            }

                            .field-value {
                                font-size: 1.15rem;
                            }
                        }
                    </style>

                    <script>
                        // Theme persistence
                        if (localStorage.getItem('theme') === 'theme-light') {
                            document.body.classList.add('theme-light');
                        }

                        // Tab switcher
                        function switchTab(clickedTab, targetFormId) {
                            // Update active tab
                            document.querySelectorAll('.booking-tab').forEach(t => t.classList.remove('active'));
                            clickedTab.classList.add('active');

                            // Hide all forms
                            document.querySelectorAll('.booking-form').forEach(f => f.classList.remove('active'));

                            // Show target form
                            const form = document.getElementById(targetFormId);
                            if (form) form.classList.add('active');
                        }

                        // ===== FILTER & SORT WIRING =====
                        function applyFilters() {
                            // Collect current search params from URL
                            const params = new URLSearchParams(window.location.search);

                            // Overwrite filter/sort params from dropdowns
                            const airline  = document.getElementById('airlineFilter');
                            const price    = document.getElementById('priceFilter');
                            const stops    = document.getElementById('stopsFilter');
                            const sort     = document.getElementById('sortSelect');

                            if (airline) params.set('filterAirline',  airline.value);
                            if (price)   params.set('filterMaxPrice', price.value);
                            if (stops)   params.set('filterStops',    stops.value);
                            if (sort)    params.set('sort',           sort.value);

                            // Navigate to same servlet with updated filters
                            window.location.href = window.location.pathname + '?' + params.toString();
                        }

                        // Swap from/to fields (Flights)
                        function swapFields() {
                            const fromInput = document.querySelector('#form-flights input[name="from"]');
                            const toInput   = document.querySelector('#form-flights input[name="to"]');
                            if (fromInput && toInput) {
                                const tmp      = fromInput.value;
                                fromInput.value = toInput.value;
                                toInput.value   = tmp;
                            }
                        }


                        // ===== TRAVELLERS PANEL LOGIC =====

                        // Class value → display label mapping
                        const CLASS_LABELS = {
                            'economy':  'Economy',
                            'premium':  'Premium Economy',
                            'business': 'Business',
                            'first':    'First Class'
                        };

                        // Initialize state from hidden fields (restores values after search/page reload)
                        let adults        = parseInt(document.getElementById('adultCountHidden').value)  || 1;
                        let children      = parseInt(document.getElementById('childCountHidden').value)   || 0;
                        let infants       = parseInt(document.getElementById('infantCountHidden').value)  || 0;
                        let selectedClass = document.getElementById('seatClassHidden').value || 'economy';
                        let selectedClassLabel = CLASS_LABELS[selectedClass] || 'Economy';

                        // Sync counter display elements with state
                        function syncCounterDisplays() {
                            document.getElementById('adultsCount').textContent   = adults;
                            document.getElementById('childrenCount').textContent = children;
                            document.getElementById('infantsCount').textContent  = infants;
                        }

                        // Restore the active class button highlight
                        function restoreClassButton() {
                            document.querySelectorAll('.class-btn').forEach(btn => {
                                btn.style.border     = '1px solid rgba(255,255,255,0.15)';
                                btn.style.background = 'transparent';
                                btn.style.color      = 'rgba(255,255,255,0.7)';
                            });
                            const active = document.getElementById('class-' + selectedClass);
                            if (active) {
                                active.style.border     = '1px solid var(--color-primary)';
                                active.style.background = 'rgba(212,165,116,0.15)';
                                active.style.color      = 'var(--color-primary)';
                            }
                        }

                        // Rebuild the travellers display text from current state
                        function refreshTravellersDisplay() {
                            let parts = [];
                            parts.push(adults + ' Adult' + (adults > 1 ? 's' : ''));
                            if (children > 0) parts.push(children + ' Child' + (children > 1 ? 'ren' : ''));
                            if (infants  > 0) parts.push(infants  + ' Infant' + (infants  > 1 ? 's'   : ''));
                            document.getElementById('travellersDisplay').textContent = parts.join(', ');
                            document.getElementById('classDisplay').textContent      = selectedClassLabel;
                        }

                        // Run on page load to restore state
                        document.addEventListener('DOMContentLoaded', function() {
                            syncCounterDisplays();
                            restoreClassButton();
                            refreshTravellersDisplay();
                        });

                        function toggleTravellersPanel(e) {
                            e.stopPropagation();
                            const panel = document.getElementById('travellersPanel');
                            const isOpen = panel.style.display === 'block';
                            panel.style.display = isOpen ? 'none' : 'block';
                            // Sync counter visuals every time panel opens
                            if (!isOpen) {
                                syncCounterDisplays();
                                restoreClassButton();
                            }
                        }

                        // Close panel when clicking outside
                        document.addEventListener('click', function() {
                            const panel = document.getElementById('travellersPanel');
                            if (panel) panel.style.display = 'none';
                        });

                        // Sync hidden fields with current state
                        function syncHiddenFields() {
                            document.getElementById('adultCountHidden').value  = adults;
                            document.getElementById('childCountHidden').value  = children;
                            document.getElementById('infantCountHidden').value = infants;
                            document.getElementById('seatClassHidden').value   = selectedClass;
                        }

                        function changePax(type, delta) {
                            if (type === 'adults') {
                                adults = Math.max(1, adults + delta);
                                document.getElementById('adultsCount').textContent = adults;
                            } else if (type === 'children') {
                                children = Math.max(0, children + delta);
                                document.getElementById('childrenCount').textContent = children;
                            } else if (type === 'infants') {
                                infants = Math.max(0, infants + delta);
                                document.getElementById('infantsCount').textContent = infants;
                            }
                            // Update display and hidden fields immediately (no Apply needed)
                            refreshTravellersDisplay();
                            syncHiddenFields();
                        }

                        function selectClass(value, label) {
                            selectedClass      = value;
                            selectedClassLabel = label;
                            restoreClassButton();
                            // Update display and hidden fields immediately
                            refreshTravellersDisplay();
                            syncHiddenFields();
                        }

                        // Apply just closes the panel (display is already live)
                        function applyTravellers() {
                            document.getElementById('travellersPanel').style.display = 'none';
                        }
                    </script>

                    <!-- Loading State Overlay -->
                    <div id="loadingOverlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(10, 10, 10, 0.85); backdrop-filter: blur(8px); z-index: 9999; flex-direction: column; justify-content: center; align-items: center;">
                        <div class="animate-spin rounded-full h-16 w-16 border-t-4 border-b-4 border-primary mb-4"></div>
                        <h2 class="text-white text-2xl font-bold tracking-widest uppercase">Searching...</h2>
                        <p class="text-white opacity-60 mt-2">Finding the best deals for you</p>
                    </div>

                    <script>
                        // Loading State Logic
                        document.querySelectorAll('form').forEach(form => {
                            form.addEventListener('submit', function() {
                                document.getElementById('loadingOverlay').style.display = 'flex';
                            });
                        });

                        // Filtering & Sorting Logic
                        function applyFilters() {
                            const airline = document.getElementById('airlineFilter').value;
                            const priceLimit = document.getElementById('priceFilter').value;
                            const stops = document.getElementById('stopsFilter').value;
                            const sortBy = document.getElementById('sortSelect').value;
                            
                            const url = new URL(window.location.href);
                            
                            if (airline) url.searchParams.set('filterAirline', airline);
                            else url.searchParams.delete('filterAirline');
                            
                            if (priceLimit) url.searchParams.set('filterMaxPrice', priceLimit);
                            else url.searchParams.delete('filterMaxPrice');
                            
                            if (stops) url.searchParams.set('filterStops', stops);
                            else url.searchParams.delete('filterStops');
                            
                            if (sortBy) url.searchParams.set('sort', sortBy);
                            else url.searchParams.delete('sort');
                            
                            document.getElementById('loadingOverlay').style.display = 'flex';
                            window.location.href = url.toString();
                        }
                    </script>

                <%@ include file="/components/footer.jsp" %>
