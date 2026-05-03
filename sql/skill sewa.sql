CREATE DATABASE IF NOT EXISTS skillsewa;
USE skillsewa;

CREATE TABLE categories(
	category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users(
	user_id VARCHAR(10) PRIMARY KEY,
    full_name VARCHAR(40) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NOT NULL UNIQUE,
    session_contact_info VARCHAR(255),
    role ENUM('user', 'admin') DEFAULT 'user',
    is_suspended BOOLEAN DEFAULT FALSE,
    profile_pic VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE skills(
	skill_id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id VARCHAR(10) NOT NULL,
    category_id INT NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    price_per_10min DECIMAL(10, 2) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES users(user_id),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE bookings(
	booking_id VARCHAR(10) PRIMARY KEY,
    skill_id INT NOT NULL,
    learner_id VARCHAR(10) NOT NULL,
    duration_minutes INT NOT NULL CHECK (duration_minutes >=10 AND duration_minutes <=120),
    total_price	DECIMAL(10, 2) NOT NULL,
    message TEXT,
    status ENUM('pending', 'accepted', 'rejected', 'completed') DEFAULT 'pending',
    rejection_note TEXT,
    acceptance_note TEXT,
    is_paid BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id) ON DELETE CASCADE,
    FOREIGN KEY (learner_id) REFERENCES users(user_id) ON DELETE CASCADE
    );

CREATE TABLE payments(
	payment_id VARCHAR(10) PRIMARY KEY,
    booking_id VARCHAR(10) NOT NULL UNIQUE,
    learner_id VARCHAR(10) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    status ENUM('pending', 'completed') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
	FOREIGN KEY (learner_id) REFERENCES users(user_id) ON DELETE CASCADE
);