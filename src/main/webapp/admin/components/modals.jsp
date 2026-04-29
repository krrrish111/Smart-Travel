<!-- Add/Edit Plan Modal -->
<div class="admin-modal-overlay" id="planModal">
    <div class="admin-modal">
        <h3 id="planModalTitle" style="margin-bottom: 20px;">Add New Plan</h3>
        <form id="planForm">
            <input type="hidden" id="planId">
            <div class="form-group">
                <label class="form-label">Plan Title</label>
                <input type="text" class="form-control" id="planTitle" required placeholder="e.g. Majestic Alps Retreat">
            </div>
            <div class="grid" style="grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px;">
                <div>
                    <label class="form-label">Location</label>
                    <input type="text" class="form-control" id="planLocation" required placeholder="e.g. Switzerland">
                </div>
                <div>
                    <label class="form-label">Duration</label>
                    <input type="text" class="form-control" id="planDuration" required placeholder="e.g. 7 Days">
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Price</label>
                <input type="text" class="form-control" id="planPrice" required placeholder="e.g. $1,499">
            </div>
            <div class="form-group">
                <label class="form-label">Description / Highlight tags</label>
                <input type="text" class="form-control" id="planDesc" required placeholder="e.g. Mountains, Skiing, Luxury">
            </div>
            
            <div class="flex justify-end" style="gap: 12px; margin-top: 30px;">
                <button type="button" class="btn btn-outline" onclick="closePlanModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Plan</button>
            </div>
        </form>
    </div>
</div>

<!-- Add/Edit Destination Modal -->
<!-- Add/Edit Destination Modal -->
<div class="admin-modal-overlay" id="destModal">
    <div class="admin-modal">
        <form id="destForm" action="${pageContext.request.contextPath}/destinations" method="POST" enctype="multipart/form-data">
            <div class="admin-modal-header">
                <h3 id="destModalTitle" style="margin: 0;">Add Destination</h3>
            </div>
            
            <div class="admin-modal-body">
                <input type="hidden" id="destId" name="id">
                <input type="hidden" id="destAction" name="action" value="add">
                <div class="form-group">
                    <label class="form-label" for="destName">Destination Name</label>
                    <input type="text" class="form-control" id="destName" name="name" required placeholder="e.g. Santorini">
                </div>
                <div class="grid" style="grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px;">
                    <div>
                        <label class="form-label" for="destLocation">Location (State, Country)</label>
                        <input type="text" class="form-control" id="destLocation" name="location" required placeholder="e.g. Cyclades, Greece">
                    </div>
                    <div>
                        <label class="form-label" for="destCategory">Category</label>
                        <select class="form-control" id="destCategory" name="category" required style="padding-right:32px;">
                            <option value="Beach & Island">Beach & Island</option>
                            <option value="Mountain Retreat">Mountain Retreat</option>
                            <option value="City Escape">City Escape</option>
                            <option value="Heritage & Culture">Heritage & Culture</option>
                        </select>
                    </div>
                </div>
                
                <div class="form-group">
                    <label class="form-label">Destination Image</label>
                    <div style="border:2px dashed var(--color-border); border-radius:8px; padding:20px; text-align:center; position:relative; overflow:hidden; background:var(--surface-light); transition:border-color 0.2s;" id="destImageUploadBox">
                        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" style="color:var(--text-muted); margin-bottom:8px; display:inline-block;"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/></svg>
                        <div style="font-size:0.9rem; color:var(--text-muted); margin-bottom:8px;">Upload image or paste URL below</div>
                        <input type="text" class="form-control" id="destImage" name="image" placeholder="Paste an image URL..." style="position:relative; z-index:10; margin-bottom: 10px;" autocomplete="off" oninput="previewImg('destImage','destImagePreview')">
                        <div style="font-size:0.8rem; color:var(--text-muted); margin-bottom:5px;">— OR —</div>
                        <input type="file" id="destImageFile" name="destImageFile" accept="image/*" class="form-control" style="font-size: 0.8rem;">
                    </div>
                    <img id="destImagePreview" class="image-preview-box" src="" alt="Preview">
                </div>

                <div class="form-group" style="padding-bottom: 20px;">
                    <label class="form-label" for="destDesc">Description</label>
                    <textarea class="form-control" id="destDesc" name="desc" required placeholder="A beautiful island in Greece..." rows="4" style="resize: vertical;"></textarea>
                </div>
            </div>
            
            <div class="admin-modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeDestModal()">Cancel</button>
                <button type="submit" class="btn btn-primary" id="saveDestBtn">Save Destination</button>
            </div>
        </form>
    </div>
</div>

<!-- Add/Edit Activity Modal -->
<div class="admin-modal-overlay" id="activityModal">
    <div class="admin-modal">
        <h3 id="activityModalTitle" style="margin-bottom: 20px;">Add Activity</h3>
        <form id="activityForm">
            <input type="hidden" id="activityId" name="id">
            <input type="hidden" id="activityAction" name="action" value="add">
            
            <div class="form-group">
                <label class="form-label">Activity Name</label>
                <input type="text" class="form-control" id="activityName" name="name" required placeholder="e.g. Scuba Diving">
            </div>
            
            <div class="grid" style="grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px;">
                <div>
                    <label class="form-label">Destination</label>
                    <select class="form-control" id="activityDestId" name="destination_id" required style="padding-right:32px;">
                        <!-- Populated by JS -->
                    </select>
                </div>
                <div>
                    <label class="form-label">Price</label>
                    <input type="number" step="0.01" class="form-control" id="activityPrice" name="price" required placeholder="1200">
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Activity Image URL</label>
                <input type="text" class="form-control" id="activityImage" name="image_url" required placeholder="Paste an image URL..." oninput="previewImg('activityImage','activityImagePreview')">
                <img id="activityImagePreview" src="" alt="Preview" style="display:none; margin-top:10px; width:100%; height:120px; object-fit:cover; border-radius:8px; border:1px solid var(--color-border);">
            </div>
            
            <!-- These are usually hidden as they are updated by user reviews, but for admin edit we show them -->
            <div class="grid" id="activityExtraInfo" style="grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px; display:none;">
                <div>
                    <label class="form-label">Rating</label>
                    <input type="number" step="0.1" class="form-control" id="activityRating" name="rating" placeholder="4.5">
                </div>
                <div>
                    <label class="form-label">Reviews Count</label>
                    <input type="number" class="form-control" id="activityReviewsCount" name="reviews_count" placeholder="10">
                </div>
            </div>

            <div class="flex justify-end" style="gap: 12px; margin-top: 30px;">
                <button type="button" class="btn btn-outline" onclick="closeActivityModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Activity</button>
            </div>
        </form>
    </div>
</div>

<!-- Edit Content Modal -->
<div class="admin-modal-overlay" id="contentModal">
    <div class="admin-modal">
        <h3 style="margin-bottom: 20px;">Edit Content Card</h3>
        <form id="contentForm">
            <input type="hidden" id="contentId">
            <div class="form-group">
                <label class="form-label">Title / Name</label>
                <input type="text" class="form-control" id="contentTitle" required>
            </div>
            <div class="form-group">
                <label class="form-label">Image URL</label>
                <input type="text" class="form-control" id="contentImage" required oninput="previewImg('contentImage','contentImagePreview')">
                <img id="contentImagePreview" src="" alt="Preview" style="display:none; margin-top:10px; width:100%; height:100px; object-fit:cover; border-radius:8px; border:1px solid var(--color-border);">
            </div>
            <div class="grid" style="grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px;">
                <div>
                    <label class="form-label">Price (Optional)</label>
                    <input type="text" class="form-control" id="contentPrice">
                </div>
                <div>
                    <label class="form-label">Section</label>
                    <select class="form-control" id="contentSection" required style="padding-right:32px;">
                        <option value="Trending Places">Trending Places</option>
                        <option value="Top Travel Plans">Top Travel Plans</option>
                        <option value="Featured Cards">Featured Cards</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label class="form-label">Tags (Comma separated)</label>
                <input type="text" class="form-control" id="contentTags" required placeholder="e.g. Nature, Beach">
            </div>
            
            <div class="flex justify-end" style="gap: 12px; margin-top: 30px;">
                <button type="button" class="btn btn-outline" onclick="closeContentModal()">Cancel</button>
                <button type="submit" class="btn btn-primary">Save Content</button>
            </div>
        </form>
    </div>
</div>

<!-- Custom Confirm Modal -->
<div class="admin-modal-overlay" id="confirmModal">
    <div class="admin-modal" style="text-align: center; max-width: 400px; border-top: 4px solid #ef4444;">
        <svg width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="#ef4444" stroke-width="2" style="margin: 0 auto 16px auto;"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/><line x1="12" y1="9" x2="12" y2="13"/><line x1="12" y1="17" x2="12.01" y2="17"/></svg>
        <h3 id="confirmTitle" style="margin-bottom: 12px; font-family: 'Poppins', 'Inter', 'Roboto', 'Arial', sans-serif;">Are you sure?</h3>
        <p id="confirmMessage" class="text-muted" style="margin-bottom: 24px;">This action cannot be undone.</p>
        <div class="flex justify-center" style="gap: 12px;">
            <button class="btn btn-outline" onclick="closeConfirmModal()">Cancel</button>
            <button class="btn btn-primary" id="confirmActionBtn" style="background: #ef4444; border-color: #ef4444;">Yes, Delete</button>
        </div>
    </div>
</div>
