<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Image Gallery | Voyastra</title>
    <!-- Include the common Voyager CSS or standard CSS -->
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f4f7f6; margin: 0; padding: 20px; color: #333; }
        .gallery-container { max-width: 1200px; margin: 0 auto; padding: 20px; background: white; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        h1 { margin-bottom: 20px; }
        .upload-section { margin-bottom: 30px; padding: 20px; border: 2px dashed #ccc; border-radius: 8px; text-align: center; }
        .upload-btn { background-color: #0d6efd; color: white; padding: 10px 20px; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; margin-top: 10px; }
        .upload-btn:hover { background-color: #0b5ed7; }
        .alert { padding: 15px; margin-bottom: 20px; border: 1px solid transparent; border-radius: 4px; }
        .alert-success { color: #0f5132; background-color: #d1e7dd; border-color: #badbcc; }
        .alert-danger { color: #842029; background-color: #f8d7da; border-color: #f5c2c7; }
        
        .images-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; }
        .image-card { border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .image-card img { width: 100%; height: 200px; object-fit: cover; display: block; }
        .image-info { padding: 10px; font-size: 0.9em; color: #666; background: #fff; }
    </style>
</head>
<body>

<div class="gallery-container">
    <h1>Image Gallery</h1>

    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success">${sessionScope.message}</div>
        <c:remove var="message" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger">${sessionScope.error}</div>
        <c:remove var="error" scope="session" />
    </c:if>

    <div class="upload-section">
        <h3>Upload New Image</h3>
        <form action="${pageContext.request.contextPath}/gallery" method="post" enctype="multipart/form-data" id="uploadForm">
            <!-- Strict accept attribute for validation -->
            <input type="file" name="imageFile" id="imageInput" accept="image/png, image/jpeg, .jpg, .jpeg, .png" required>
            <br>
            
            <!-- Hidden by default until an image is loaded -->
            <div id="previewContainer" style="display: none; margin-top: 15px;">
                <p style="font-size: 0.9em; color: #555; margin-bottom: 5px;">Preview:</p>
                <img id="imagePreview" src="" alt="Image Preview" style="max-width: 100%; max-height: 250px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
            </div>
            
            <button type="submit" class="upload-btn">Upload Image</button>
        </form>
    </div>

    <!-- Script to handle dynamic image preview and frontend validation mapping -->
    <script>
        document.getElementById('imageInput').addEventListener('change', function(event) {
            const file = event.target.files[0];
            const previewContainer = document.getElementById('previewContainer');
            const imagePreview = document.getElementById('imagePreview');
            
            if (file) {
                // Ensure only exact filetypes are parsed
                if (!file.type.match('image/jpeg') && !file.type.match('image/png')) {
                    VoyastraToast.show('Only JPG/JPEG and PNG image formats are allowed.', 'error');
                    event.target.value = ''; // Reset input
                    previewContainer.style.display = 'none';
                    return;
                }

                const reader = new FileReader();
                reader.onload = function(e) {
                    imagePreview.src = e.target.result;
                    previewContainer.style.display = 'block';
                }
                reader.readAsDataURL(file);
            } else {
                previewContainer.style.display = 'none';
            }
        });
    </script>

    <div class="images-grid">
        <c:choose>
            <c:when test="${not empty images}">
                <c:forEach var="img" items="${images}">
                    <div class="image-card">
                        <img src="${pageContext.request.contextPath}/${img.filePath}" alt="Uploaded Image">
                        <div class="image-info">Uploaded: <c:out value="${img.createdAt}" /></div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div style="grid-column: 1 / -1; text-align: center; color: #777;">No images uploaded yet.</div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

</body>
</html>
