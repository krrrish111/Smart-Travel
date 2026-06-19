import codecs
import re

with codecs.open('src/main/webapp/pages/planner.jsp', 'r', 'utf-8') as f:
    text = f.read()

# Fix 1: Make sure window.generatePlan is exposed
if 'window.generatePlan = generatePlan;' not in text:
    text = text.replace('async function generatePlan(event) {', 'window.generatePlan = generatePlan;\n                      async function generatePlan(event) {')

# Fix 2: Unsplash key check
if 'const UNSPLASH_KEY' in text:
    text = text.replace("const UNSPLASH_KEY     = _config?.dataset?.unsplashKey  || '';", "let UNSPLASH_KEY = _config?.dataset?.unsplashKey || '';\n                if (!UNSPLASH_KEY) console.error('[Voyastra] Unsplash API key not set');")

# Fix 3: Rewrite addCustomDay completely without template literals
add_custom_day_regex = re.compile(r'window\.addCustomDay = \(\) => \{.*?// Initialize Sortable on new day', re.DOTALL)
replacement_add_custom = '''window.addCustomDay = () => {
                        const dayList = document.getElementById('aiDayCards');
                        if (!dayList) return;
                        const nextDayNum = dayList.children.length + 1;

                        const card = document.createElement('div');
                        card.className = 'glass-panel p-6 reveal-item relative overflow-hidden';
                        card.style.borderRadius = '20px';

                        card.innerHTML = 
                            '<div class="absolute -right-10 -top-10 text-white/5 pointer-events-none">' +
                            '<span class="font-bold editorial" style="font-size: 10rem;">' + nextDayNum + '</span>' +
                            '</div>' +
                            '<div class="relative z-10">' +
                            '<div class="flex justify-between items-start mb-4 cursor-grab drag-handle">' +
                            '<div>' +
                            '<h4 class="text-primary font-bold editorial mb-2" style="font-size: 1.4rem;" contenteditable="true">Day ' + nextDayNum + ': Custom Day</h4>' +
                            '<div class="flex gap-2 mb-3">' +
                            '<span class="px-2 py-1 rounded text-xs font-bold border text-green-400 bg-green-400/10 border-green-400/20"><i class="ri-pulse-line mr-1"></i> Custom</span>' +
                            '</div>' +
                            '</div>' +
                            '<i class="ri-draggable text-muted text-lg mt-2"></i>' +
                            '</div>' +
                            '<div class="flex flex-col gap-1 sortable-activities" data-day="' + nextDayNum + '" style="min-height: 50px;">' +
                            '<div class="p-4 text-center border-2 border-dashed border-white/10 rounded-xl text-muted text-sm">Drag activities here</div>' +
                            '</div>' +
                            '<button onclick="addCustomActivity(this, ' + nextDayNum + ')" class="w-full mt-2 py-2 text-xs text-muted hover:text-main hover:bg-white/5 rounded-xl border border-dashed border-white/10 transition-all">' +
                            '<i class="ri-add-line mr-1"></i> Add Custom Activity' +
                            '</button>' +
                            '</div>';
                        dayList.appendChild(card);

                        // Initialize Sortable on new day'''

text = add_custom_day_regex.sub(replacement_add_custom, text)

# Fix 4: Rewrite addCustomActivity completely without template literals
add_custom_activity_regex = re.compile(r'window\.addCustomActivity = \(btnEl, dayNum\) => \{.*?card\.innerHTML = `.*?`;\s*sortableList\.appendChild\(card\);', re.DOTALL)
replacement_activity = '''window.addCustomActivity = (btnEl, dayNum) => {
                        const title = prompt("Enter Custom Activity Title (e.g. Dinner Reservation)");
                        if (!title) return;

                        const sortableList = btnEl.previousElementSibling;
                        if (!sortableList) return;

                        // Clear the "Drag activities here" placeholder if it exists
                        const placeholder = sortableList.querySelector('.text-center');
                        if (placeholder && placeholder.innerText.includes('Drag activities')) {
                            placeholder.remove();
                        }

                        const card = document.createElement('div');
                        card.className = "flex gap-4 p-3 hover:bg-white/5 rounded-xl transition-all group relative";
                        card.setAttribute('data-title', title);
                        card.setAttribute('data-category', 'General');
                        
                        card.innerHTML = 
                            '<div class="w-16 shrink-0 pt-1">' +
                            '<span class="text-[0.65rem] text-muted font-bold uppercase block">Custom</span>' +
                            '</div>' +
                            '<div class="flex-1">' +
                            '<div class="flex items-center gap-2 mb-1">' +
                            '<h5 class="text-sm text-main font-bold m-0">' + title + '</h5>' +
                            '<span class="px-2 py-0.5 rounded text-[0.55rem] uppercase tracking-wider font-bold text-primary bg-primary/10"><i class="ri-user-star-line mr-1"></i>Personal</span>' +
                            '</div>' +
                            '<p class="text-xs text-muted/80 leading-relaxed editable-activity" contenteditable="true">Tap to edit notes</p>' +
                            '</div>';
                        sortableList.appendChild(card);'''

text = add_custom_activity_regex.sub(replacement_activity, text)

with codecs.open('src/main/webapp/pages/planner.jsp', 'w', 'utf-8') as f:
    f.write(text)
