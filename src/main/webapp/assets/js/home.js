document.addEventListener('DOMContentLoaded', () => {
    const generateBtn = document.getElementById('aiGenerateBtn');
    if(generateBtn) {
        generateBtn.addEventListener('click', (e) => {
            e.preventDefault();
            const destInput = document.getElementById('aiDestInput');
            const dest = destInput ? destInput.value.trim() : '';

            if(!dest) {
                if (typeof VoyastraToast !== 'undefined') {
                    VoyastraToast.show("Please enter a destination.", "error");
                } else {
                    alert("Please enter a destination.");
                }
                if(destInput) destInput.focus();
                return;
            }

            const duration = document.querySelector('input[name="duration"]:checked')?.value || '';
            const budget = document.querySelector('input[name="budget"]:checked')?.value || '';
            const style = document.querySelector('input[name="style"]:checked')?.value || '';

            const params = new URLSearchParams();
            params.append('destination', dest);
            params.append('duration', duration);
            params.append('budget', budget);
            params.append('style', style);

            // Add visual polish loader if available
            generateBtn.classList.add('loading');
            
            if (typeof VoyastraUI !== 'undefined' && VoyastraUI.showLoader) {
                VoyastraUI.showLoader('Crafting your perfect itinerary...');
                setTimeout(() => {
                    window.location.href = window.CONTEXT_PATH + '/planner?' + params.toString();
                }, 800);
            } else {
                setTimeout(() => {
                    window.location.href = window.CONTEXT_PATH + '/planner?' + params.toString();
                }, 800); // Wait for the loading spinner to spin briefly
            }
        });
    }
});
