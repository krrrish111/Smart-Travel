package com.voyastra.model.community;

import java.sql.Timestamp;

public class Post {
    private int id;
    private int userId;
    private String text;
    private String imageUrl;
    private String location;
    private String category;
    private String hashtags;
    private Integer rating;
    private Timestamp createdAt;
    private boolean hidden;

    // Joined properties for UI display
    private String userName;
    private String userRole; // For rendering specific community badges
    private int likeCount;
    private int commentCount;
    private boolean hasLiked; // Whether the current session user liked this post
    private boolean hasSaved; // Whether the current session user saved this post
    private boolean followingCreator; // Whether current session user follows creator

    public Post() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getText() { return text; }
    public void setText(String text) { this.text = text; }

    public String getImageUrl() {
        return com.voyastra.util.ImageUtil.resolvePostImageUrl(imageUrl, id);
    }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getHashtags() { return hashtags; }
    public void setHashtags(String hashtags) { this.hashtags = hashtags; }

    public Integer getRating() { return rating; }
    public void setRating(Integer rating) { this.rating = rating; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }

    public String getUserRole() { return userRole; }
    public void setUserRole(String userRole) { this.userRole = userRole; }

    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }

    public int getCommentCount() { return commentCount; }
    public void setCommentCount(int commentCount) { this.commentCount = commentCount; }

    public boolean isHasLiked() { return hasLiked; }
    public void setHasLiked(boolean hasLiked) { this.hasLiked = hasLiked; }

    public boolean isHasSaved() { return hasSaved; }
    public void setHasSaved(boolean hasSaved) { this.hasSaved = hasSaved; }

    public boolean isFollowingCreator() { return followingCreator; }
    public void setFollowingCreator(boolean followingCreator) { this.followingCreator = followingCreator; }

    public boolean isHidden() { return hidden; }
    public void setHidden(boolean hidden) { this.hidden = hidden; }
}
