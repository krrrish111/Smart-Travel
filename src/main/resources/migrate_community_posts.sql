-- Migration to add 'rating' to community posts table
ALTER TABLE posts ADD COLUMN rating INT DEFAULT NULL;
