function initGooglePlacesAutocomplete(inputId) {
    const inputEl = document.getElementById(inputId);
    if (!inputEl) return;

    // Wrap input in a relative container if it's not already
    let container = inputEl.parentElement;
    if (!container.classList.contains('places-autocomplete-container')) {
        const wrapper = document.createElement('div');
        wrapper.className = 'places-autocomplete-container';
        container.insertBefore(wrapper, inputEl);
        wrapper.appendChild(inputEl);
        container = wrapper;
    }

    inputEl.setAttribute('autocomplete', 'off');

    // Create dropdown
    const dropdown = document.createElement('div');
    dropdown.className = 'places-autocomplete-dropdown';
    
    // Create loader
    const loader = document.createElement('div');
    loader.className = 'places-autocomplete-loader';
    loader.innerHTML = '<span class="places-spinner"></span> Loading suggestions...';
    dropdown.appendChild(loader);

    // Create results container
    const resultsContainer = document.createElement('div');
    dropdown.appendChild(resultsContainer);

    container.appendChild(dropdown);

    let debounceTimer;
    let currentFocus = -1;

    function closeDropdown() {
        dropdown.classList.remove('active');
        currentFocus = -1;
    }

    function highlightMatch(text, query) {
        if (!query) return text;
        const regex = new RegExp(`(${query})`, 'gi');
        return text.replace(regex, '<span class="places-autocomplete-highlight">$1</span>');
    }

    async function fetchSuggestions(query) {
        loader.classList.add('active');
        resultsContainer.innerHTML = '';
        dropdown.classList.add('active');

        try {
            const response = await fetch('/voyastra/api/places/autocomplete?q=' + encodeURIComponent(query));
            const data = await response.json();
            
            loader.classList.remove('active');

            if (data.success && data.predictions.length > 0) {
                data.predictions.forEach((prediction, index) => {
                    const item = document.createElement('div');
                    item.className = 'places-autocomplete-item';
                    
                    const icon = document.createElement('div');
                    icon.className = 'places-autocomplete-icon';
                    icon.innerHTML = '📍';
                    
                    const textNode = document.createElement('div');
                    textNode.className = 'places-autocomplete-text';
                    textNode.innerHTML = highlightMatch(prediction.description, query);
                    
                    item.appendChild(icon);
                    item.appendChild(textNode);

                    item.addEventListener('click', async function() {
                        const cityName = prediction.description.split(',')[0];
                        inputEl.value = cityName;
                        closeDropdown();
                        
                        // Fetch details
                        loader.classList.add('active');
                        try {
                            const detailsRes = await fetch('/voyastra/api/places/details?placeId=' + prediction.placeId);
                            const detailsData = await detailsRes.json();
                            loader.classList.remove('active');
                            
                            if (detailsData.success) {
                                console.log('[PLACE DETAILS] Saved To Session');
                                sessionStorage.setItem('voyastraSelectedPlace', JSON.stringify(detailsData));
                                
                                // Populate hidden fields if they exist in the form
                                const form = inputEl.closest('form');
                                if (form) {
                                    const fields = ['lat', 'lng', 'placeName', 'country', 'state', 'city'];
                                    fields.forEach(f => {
                                        let hiddenInput = form.querySelector(`input[name="${f}"]`);
                                        if (!hiddenInput) {
                                            hiddenInput = document.createElement('input');
                                            hiddenInput.type = 'hidden';
                                            hiddenInput.name = f;
                                            form.appendChild(hiddenInput);
                                        }
                                        if (f === 'placeName') {
                                            hiddenInput.value = detailsData.name || cityName;
                                        } else {
                                            hiddenInput.value = detailsData[f] || '';
                                        }
                                    });
                                    // Optionally submit the form immediately for experiences.jsp
                                    if (inputEl.id === 'expSearchInput') {
                                        form.submit();
                                    }
                                }
                            }
                        } catch (err) {
                            console.error('[PLACE DETAILS] Error:', err);
                            loader.classList.remove('active');
                        }

                        // Trigger change event if needed
                        inputEl.dispatchEvent(new Event('change'));
                    });

                    resultsContainer.appendChild(item);
                });
            } else {
                const noResults = document.createElement('div');
                noResults.style.padding = '15px';
                noResults.style.color = 'rgba(255,255,255,0.5)';
                noResults.style.fontSize = '14px';
                noResults.innerText = 'No destinations found.';
                resultsContainer.appendChild(noResults);
            }
        } catch (error) {
            loader.classList.remove('active');
            console.error('[PLACES] Error:', error);
        }
    }

    inputEl.addEventListener('input', function(e) {
        const val = this.value;
        closeDropdown();
        if (!val) return;

        clearTimeout(debounceTimer);
        debounceTimer = setTimeout(() => {
            fetchSuggestions(val);
        }, 300);
    });

    inputEl.addEventListener('keydown', function(e) {
        let items = resultsContainer.getElementsByClassName('places-autocomplete-item');
        if (e.keyCode === 40) { // DOWN
            e.preventDefault();
            currentFocus++;
            addActive(items);
        } else if (e.keyCode === 38) { // UP
            e.preventDefault();
            currentFocus--;
            addActive(items);
        } else if (e.keyCode === 13) { // ENTER
            if (currentFocus > -1) {
                if (items) items[currentFocus].click();
            }
        }
    });

    function addActive(items) {
        if (!items || items.length === 0) return;
        removeActive(items);
        if (currentFocus >= items.length) currentFocus = 0;
        if (currentFocus < 0) currentFocus = (items.length - 1);
        items[currentFocus].classList.add('selected');
        // scroll into view
        items[currentFocus].scrollIntoView({ block: 'nearest' });
    }

    function removeActive(items) {
        for (let i = 0; i < items.length; i++) {
            items[i].classList.remove('selected');
        }
    }

    document.addEventListener('click', function (e) {
        if (e.target !== inputEl && !dropdown.contains(e.target)) {
            closeDropdown();
        }
    });
}
