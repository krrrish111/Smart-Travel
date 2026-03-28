document.addEventListener('DOMContentLoaded', () => {

    // Navbar Scroll Effect
    const navbar = document.querySelector('.navbar');
    if (navbar) {
        window.addEventListener('scroll', () => {
            if (window.scrollY > 20) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });
    }

    // Budget Slider Live Update
    const budgetSlider = document.getElementById('budgetSlider');
    const budgetDisplay = document.getElementById('budgetDisplay');
    
    if (budgetSlider && budgetDisplay) {
        const updateSliderFormat = () => {
            const val = budgetSlider.value;
            budgetDisplay.textContent = '₹' + parseInt(val).toLocaleString('en-IN');
            const percent = (val - budgetSlider.min) / (budgetSlider.max - budgetSlider.min) * 100;
            budgetSlider.style.background = `linear-gradient(to right, var(--primary) ${percent}%, rgba(0,0,0,0.1) ${percent}%)`;
        };
        
        budgetSlider.addEventListener('input', updateSliderFormat);
        // init
        updateSliderFormat();
    }

    // Clickable Chips Toggle
    const chips = document.querySelectorAll('.chip');
    chips.forEach(chip => {
        chip.addEventListener('click', (e) => {
            e.preventDefault();
            chip.classList.toggle('active');
        });
    });

    // Timeline Expand/Collapse
    const timelineCards = document.querySelectorAll('.timeline-card');
    timelineCards.forEach(card => {
        const header = card.querySelector('.timeline-header');
        if (header) {
            header.addEventListener('click', () => {
                const body = card.querySelector('.timeline-body');
                const icon = card.querySelector('.expand-icon');
                if (body && icon) {
                    body.classList.toggle('hidden');
                    icon.style.transform = body.classList.contains('hidden') ? 'rotate(0deg)' : 'rotate(180deg)';
                }
            });
        }
    });

    // Tab Navigation
    const tabBtns = document.querySelectorAll('.tab-btn');
    const tabPanes = document.querySelectorAll('.tab-pane');
    
    tabBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            const target = btn.getAttribute('data-target');
            
            tabBtns.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            
            tabPanes.forEach(pane => {
                if (pane.id === target) {
                    pane.classList.remove('hidden');
                    pane.classList.add('slide-up');
                } else {
                    pane.classList.add('hidden');
                    pane.classList.remove('slide-up');
                }
            });
        });
    });

});
