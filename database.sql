-- PawNest Pet Adoption Management System
-- Database Initialization Script
-- Database: pawnest_db

CREATE DATABASE IF NOT EXISTS pawnest_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE pawnest_db;

-- 1. Users Table
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('adopter', 'owner') NOT NULL DEFAULT 'adopter',
    phone VARCHAR(20) DEFAULT NULL,
    location VARCHAR(150) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_users_email (email),
    INDEX idx_users_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Pets Table
CREATE TABLE IF NOT EXISTS pets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    owner_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    animal_type ENUM('dog', 'cat', 'rabbit', 'bird', 'other') NOT NULL,
    breed VARCHAR(100) NOT NULL,
    age INT UNSIGNED NOT NULL COMMENT 'Age in years',
    gender ENUM('male', 'female') NOT NULL,
    location VARCHAR(150) NOT NULL,
    description TEXT NOT NULL,
    health_status VARCHAR(255) DEFAULT 'Healthy, vaccinated, and microchipped',
    vaccination_status VARCHAR(100) DEFAULT 'Fully Vaccinated',
    image_path VARCHAR(255) DEFAULT NULL,
    adoption_requirements TEXT DEFAULT NULL,
    status ENUM('available', 'pending', 'adopted') NOT NULL DEFAULT 'available',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_pets_owner FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_pets_status (status),
    INDEX idx_pets_animal_type (animal_type),
    INDEX idx_pets_location (location)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Adoption Requests Table
CREATE TABLE IF NOT EXISTS adoption_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pet_id INT NOT NULL,
    adopter_id INT NOT NULL,
    message TEXT NOT NULL,
    status ENUM('pending', 'approved', 'rejected') NOT NULL DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_requests_pet FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE,
    CONSTRAINT fk_requests_adopter FOREIGN KEY (adopter_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_requests_pet (pet_id),
    INDEX idx_requests_adopter (adopter_id),
    INDEX idx_requests_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Saved Pets (Favorites/Bookmarks) Table
CREATE TABLE IF NOT EXISTS saved_pets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    pet_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_saved_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_saved_pet FOREIGN KEY (pet_id) REFERENCES pets(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_pet_save (user_id, pet_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Demo Seed Data
-- Note: All demo users have the password: Password123!
-- Bcrypt Hash: $2b$10$vNm56wLc3n/gjbjORHYjAuB6HHqulZ8OVO7xrDRntPKfje.iquC7G

INSERT IGNORE INTO users (id, full_name, email, password_hash, role, phone, location) VALUES
(1, 'Sarah Jenkins (Happy Tails Shelter)', 'owner@pawnest.com', '$2b$10$vNm56wLc3n/gjbjORHYjAuB6HHqulZ8OVO7xrDRntPKfje.iquC7G', 'owner', '555-019-2831', 'New York, NY'),
(2, 'David Miller (Rescue Haven)', 'david@pawnest.com', '$2b$10$vNm56wLc3n/gjbjORHYjAuB6HHqulZ8OVO7xrDRntPKfje.iquC7G', 'owner', '555-018-9942', 'Boston, MA'),
(3, 'Alex Morgan', 'adopter@pawnest.com', '$2b$10$vNm56wLc3n/gjbjORHYjAuB6HHqulZ8OVO7xrDRntPKfje.iquC7G', 'adopter', '555-014-3829', 'New York, NY'),
(4, 'Priya Sharma', 'priya@pawnest.com', '$2b$10$vNm56wLc3n/gjbjORHYjAuB6HHqulZ8OVO7xrDRntPKfje.iquC7G', 'adopter', '555-017-7721', 'Boston, MA');

INSERT IGNORE INTO pets (id, owner_id, name, animal_type, breed, age, gender, location, description, health_status, vaccination_status, image_path, adoption_requirements, status) VALUES
(1, 1, 'Buddy', 'dog', 'Golden Retriever', 2, 'male', 'New York, NY', 
 'Buddy is a cheerful, gentle Golden Retriever who loves long outdoor walks, playing fetch, and cuddling on lazy Sunday afternoons. Great with kids and other dogs.', 
 'Excellent health, up-to-date vaccinations, microchipped, neutered', 'Fully Vaccinated', '/uploads/demo-buddy.jpg', 
 'Fenced yard preferred, active family willing to exercise daily.', 'available'),

(2, 1, 'Luna', 'cat', 'British Shorthair', 1, 'female', 'New York, NY', 
 'Luna is a quiet, plush-coated British Shorthair with striking amber eyes. She enjoys curling up on soft rugs and observing birds from sunny windowsills.', 
 'Vaccinated, spayed, dewormed', 'Fully Vaccinated', '/uploads/demo-luna.jpg', 
 'Quiet indoor home, gentle companions.', 'available'),

(3, 2, 'Max', 'dog', 'Beagle', 3, 'male', 'Boston, MA', 
 'Max is an affectionate, curious Beagle with an incredible nose for adventure. He gets along wonderfully with other pets and has mastered basic obedience commands.', 
 'Healthy, neutered, up-to-date rabies and distemper vaccines', 'Fully Vaccinated', '/uploads/demo-max.jpg', 
 'Daily walks required, leash-only outdoors due to strong tracking instincts.', 'available'),

(4, 2, 'Bella', 'rabbit', 'Holland Lop', 1, 'female', 'Boston, MA', 
 'Bella is a miniature Holland Lop bunny with sweet droopy ears. She is litter-box trained, loves munching on fresh parsley and timothy hay, and enjoys gentle petting.', 
 'Examined by exotic vet, healthy and active', 'Fully Vaccinated', '/uploads/demo-bella.jpg', 
 'Indoor enclosure or bunny-proofed room with gentle handling.', 'available'),

(5, 1, 'Sunny', 'bird', 'Cockatiel', 2, 'male', 'New York, NY', 
 'Sunny is a vocal and friendly Cockatiel who loves whistling melodic tunes and perching comfortably on your shoulder while you read or work.', 
 'Avian wellness check passed, pristine plumage', 'Fully Vaccinated', '/uploads/demo-sunny.jpg', 
 'Spacious cage, daily out-of-cage supervised time, healthy seed/pellet diet.', 'available'),

(6, 2, 'Rocky', 'dog', 'German Shepherd', 4, 'male', 'Boston, MA', 
 'Rocky is an intelligent, loyal German Shepherd. He is highly trainable, protective, and looks forward to agility training or hiking with an experienced handler.', 
 'Fully vaccinated, neutered, joint supplements recommended', 'Fully Vaccinated', '/uploads/demo-rocky.jpg', 
 'Experience with large working breeds required. Securely fenced yard.', 'pending'),

(7, 1, 'Milo', 'cat', 'Siamese', 1, 'male', 'New York, NY', 
 'Milo is a chatty, affectionate Siamese kitten who loves engaging toy puzzles and sleeping under cozy blankets. Happily matched with his forever family!', 
 'Vaccinated, neutered, microchipped', 'Fully Vaccinated', '/uploads/demo-milo.jpg', 
 'Indoor home with lots of playtime.', 'adopted'),

(8, 2, 'Daisy', 'dog', 'Labrador Retriever', 2, 'female', 'Boston, MA', 
 'Daisy is a sweet-natured yellow Lab who adores water, swimming, and playing tag in the grass. She is gentle around seniors and children alike.', 
 'Complete vet clearance, spayed, heartworm negative', 'Fully Vaccinated', '/uploads/demo-daisy.jpg', 
 'Loving family home, regular swimming or fetch sessions.', 'available');

INSERT IGNORE INTO adoption_requests (id, pet_id, adopter_id, message, status) VALUES
(1, 6, 3, 'Hello! I have owned German Shepherds for over 8 years and have a large fenced backyard. We would love to give Rocky an active, loving home.', 'pending'),
(2, 7, 4, 'Milo will have a wonderful companion cat and lots of sunlight in our spacious apartment!', 'approved');

INSERT IGNORE INTO saved_pets (id, user_id, pet_id) VALUES
(1, 3, 1),
(2, 3, 2),
(3, 4, 3);
