package com.voyastra.model.booking;

public class HotelPhoto {
    private int id;
    private int hotelId;
    private String url;
    private String caption;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getHotelId() { return hotelId; }
    public void setHotelId(int hotelId) { this.hotelId = hotelId; }
    public String getUrl() { return url; }
    public void setUrl(String url) { this.url = url; }
    public String getCaption() { return caption; }
    public void setCaption(String caption) { this.caption = caption; }
}
