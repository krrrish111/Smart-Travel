package com.voyastra.model;

public class GalleryImage {
    private String imageUrl;
    private String caption;

    public GalleryImage() {}

    public GalleryImage(String imageUrl, String caption) {
        this.imageUrl = imageUrl;
        this.caption = caption;
    }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public String getCaption() { return caption; }
    public void setCaption(String caption) { this.caption = caption; }
}
