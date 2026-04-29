/* =========================================================
   CONTENT MANAGEMENT LOGIC (localStorage)
========================================================= */
const LS_CONTENT_KEY = 'voyastra_admin_content';
const initialContent = [
    { id: 1, type: 'hero', title: 'Explore the World with Voyastra', subtitle: 'Book unique experiences at over 10,000 destinations.', active: true },
    { id: 2, type: 'promotion', title: 'Summer Special: 20% Off', subtitle: 'Use code SUMMER20 for all European trips.', active: true }
];

function getContent() {
    let raw = localStorage.getItem(LS_CONTENT_KEY);
    if (!raw) {
        localStorage.setItem(LS_CONTENT_KEY, JSON.stringify(initialContent));
        return initialContent;
    }
    return JSON.parse(raw);
}

function saveContent(content) {
    localStorage.setItem(LS_CONTENT_KEY, JSON.stringify(content));
}

function loadContent() {
    const data = getContent();
    const grid = document.getElementById('contentGrid');
    if (!grid) return;

    grid.innerHTML = data.map(c => `
        <div class="stat-card" style="padding:20px; border-top: 4px solid var(--color-primary);" data-id="${c.id}">
            <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:15px;">
                <span style="font-size:0.7rem; font-weight:600; text-transform:uppercase; color:var(--text-muted);">${c.type}</span>
                <input type="checkbox" ${c.active ? 'checked' : ''} onchange="toggleContent(${c.id}, this.checked)">
            </div>
            <h4 style="margin-bottom:6px; font-weight:600;">${c.title}</h4>
            <p style="font-size:0.85rem; color:var(--text-muted); margin-bottom:15px;">${c.subtitle}</p>
            <div style="display:flex; gap:10px;">
                <button class="btn btn-outline" style="flex:1; padding:6px; font-size:0.8rem;" onclick="editContent(${c.id})">Edit</button>
            </div>
        </div>
    `).join('');
    
    if (typeof initContentDragDrop === 'function') initContentDragDrop();
}

function toggleContent(id, active) {
    const data = getContent();
    const idx = data.findIndex(c => c.id === id);
    if (idx !== -1) {
        data[idx].active = active;
        saveContent(data);
        if (typeof showToast === 'function') showToast('Content visibility updated.', 'success');
    }
}

function editContent(id) {
    // Content editing logic (placeholder or modal)
    if (typeof showToast === 'function') showToast('Content editor opened for ID: ' + id, 'success');
}

/* =========================================================
   DRAG AND DROP FOR CONTENT MANAGEMENT
========================================================= */
function initContentDragDrop() {
    const grid = document.getElementById('contentGrid');
    if (!grid) return;
    
    const cards = grid.querySelectorAll('.stat-card');
    let draggedCard = null;

    cards.forEach(card => {
        card.setAttribute('draggable', true);
        card.classList.add('draggable-card');

        card.addEventListener('dragstart', function(e) {
            draggedCard = card;
            setTimeout(() => card.classList.add('dragging'), 0);
            e.dataTransfer.effectAllowed = 'move';
        });

        card.addEventListener('dragend', function() {
            if (!draggedCard) return;
            draggedCard.classList.remove('dragging');
            draggedCard = null;
            document.querySelectorAll('.drag-over').forEach(el => el.classList.remove('drag-over'));
            
            // Auto update order based on DOM position
            const newOrderIds = Array.from(grid.querySelectorAll('.stat-card')).map(c => parseInt(c.getAttribute('data-id')));
            const allContent = getContent();
            const reorderedContent = newOrderIds.map(id => allContent.find(c => c.id === id)).filter(Boolean);
            if (reorderedContent.length === allContent.length) {
                saveContent(reorderedContent);
                if (typeof logActivity === 'function') logActivity('Admin reordered content cards');
                if (typeof showToast === 'function') showToast('Content order saved automatically', 'success');
            }
        });

        card.addEventListener('dragover', function(e) {
            e.preventDefault();
            e.dataTransfer.dropEffect = 'move';
            if (card !== draggedCard) card.classList.add('drag-over');
        });

        card.addEventListener('dragleave', function() {
            card.classList.remove('drag-over');
        });

        card.addEventListener('drop', function(e) {
            e.preventDefault();
            if (card !== draggedCard && draggedCard) {
                const dragIndex = Array.from(grid.children).indexOf(draggedCard);
                const dropIndex = Array.from(grid.children).indexOf(card);
                if (dragIndex < dropIndex) {
                    card.after(draggedCard);
                } else {
                    card.before(draggedCard);
                }
            }
            card.classList.remove('drag-over');
        });
    });
}
