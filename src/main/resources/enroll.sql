-- For User
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    phone_number VARCHAR(20),
    profile_picture LONGBLOB,
    role ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- For Course
CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_title VARCHAR(100),
    description TEXT,
    duration INT,
    min_students INT,
    max_students INT,
    is_open BOOLEAN,
    instructor_id INT,
    credits INT,
    cost DOUBLE,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    level ENUM('BEGINNER', 'INTERMEDIATE', 'ADVANCED') DEFAULT 'BEGINNER',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (instructor_id) REFERENCES users(user_id)
);

-- For Enrollments
CREATE TABLE Enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    status ENUM('APPROVED', 'PENDING', 'REJECTED', 'COMPLTED'),
    enrollment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(user_id),
    FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    UNIQUE (student_id, course_id)
);


-- For Progress
CREATE TABLE Progress (
    progress_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    progress_percent DOUBLE CHECK (progress_percent >= 0 AND progress_percent <= 100),
    progress_status ENUM('Not_Started', 'In_Progress', 'Completed') DEFAULT 'In_Progress',
    FOREIGN KEY (enrollment_id) REFERENCES Enrollments(enrollment_id)
);

--For Grades
CREATE TABLE Grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    grade ENUM('A', 'B', 'C', 'D', 'FAIL') NOT NULL,
    graded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remarks VARCHAR(500),
    FOREIGN KEY (enrollment_id) REFERENCES Enrollments(enrollment_id) ON DELETE CASCADE,
    UNIQUE (enrollment_id)
);