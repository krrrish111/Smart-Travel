USE voyastra;

-- Update admin and test user with verified BCrypt hash for password "Admin@123"
UPDATE users SET password = '$2a$12$OhufE14IFnHVGNvDtOlTKOuEYohGZD/HUV6CUEBioKhevSiRdcbIu'
WHERE email IN ('admin@voyastra.com', 'user@voyastra.com');

SELECT id, name, email, role, is_verified FROM users;
