package com.voyastra.model;

public class SiteContent {
    private int id;
    private String sectionType;
    private String title;
    private String subtitle;
    private String bodyText;
    private String imageUrl;
    private String buttonText;
    private String buttonLink;
    private String promoCode;
    private boolean active;
    private int displayOrder;

    public SiteContent() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getSectionType() { return sectionType; }
    public void setSectionType(String sectionType) { this.sectionType = sectionType; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getSubtitle() { return subtitle; }
    public void setSubtitle(String subtitle) { this.subtitle = subtitle; }

    public String getBodyText() { return bodyText; }
    public void setBodyText(String bodyText) { this.bodyText = bodyText; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getButtonText() { return buttonText; }
    public void setButtonText(String buttonText) { this.buttonText = buttonText; }

    public String getButtonLink() { return buttonLink; }
    public void setButtonLink(String buttonLink) { this.buttonLink = buttonLink; }

    public String getPromoCode() { return promoCode; }
    public void setPromoCode(String promoCode) { this.promoCode = promoCode; }

    public boolean isActive() { return active; }
    public void setActive(boolean active) { this.active = active; }

    public int getDisplayOrder() { return displayOrder; }
    public void setDisplayOrder(int displayOrder) { this.displayOrder = displayOrder; }
}
