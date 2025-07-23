-- Student Name: Sidney Pham
-- Course: Database Systems
-- Section: W02
-- Professor: Obioku Obotette
-- Lab: Individual Lab 4

-- 1. Database Creation and Selection

CREATE DATABASE IF NOT EXISTS clinic_db_lab4;
USE clinic_db_lab4;

-- 2. Drop Tables
-- Drop tables in reverse order of dependency to avoid foreign key constraints issues
DROP TABLE IF EXISTS PatientEmployeeAssistance;
DROP TABLE IF EXISTS Beds;
DROP TABLE IF EXISTS Treatments;
DROP TABLE IF EXISTS Tests;
DROP TABLE IF EXISTS Patients;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS EmployeeRoles;
DROP TABLE IF EXISTS TestTypes;


-- 3. Create Tables
-- 7+ tables.


-- Table 1: Departments
CREATE TABLE Departments (
    Department_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Location VARCHAR(100)
);

-- Table 2: EmployeeRoles
CREATE TABLE EmployeeRoles (
    Role_ID INT PRIMARY KEY AUTO_INCREMENT,
    RoleName VARCHAR(100) NOT NULL UNIQUE
);

-- Table 3: Employees
CREATE TABLE Employees (
    Employee_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Role_ID INT NOT NULL, -- FK to EmployeeRoles
    Department_ID INT,    -- FK to Departments
    FOREIGN KEY (Role_ID) REFERENCES EmployeeRoles(Role_ID),
    FOREIGN KEY (Department_ID) REFERENCES Departments(Department_ID)
);

-- Table 4: Patients
CREATE TABLE Patients (
    Patient_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Date_of_Birth DATE,
    Gender VARCHAR(10),
    Address VARCHAR(255),
    City VARCHAR(100)
);

-- Table 5: Beds
CREATE TABLE Beds (
    Bed_ID INT PRIMARY KEY AUTO_INCREMENT,
    Room_Number VARCHAR(10) NOT NULL,
    Ward_Name VARCHAR(100) NOT NULL,
    Patient_ID INT, -- FK to Patients, NULLable if bed is empty
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID)
);

-- Table 6: Treatments
CREATE TABLE Treatments (
    Treatment_ID INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID INT NOT NULL, -- FK to Patients
    Employee_ID INT,          -- FK to Employees (who performed/prescribed)
    Description VARCHAR(255) NOT NULL,
    Treatment_Date DATE NOT NULL,
    Cost DECIMAL(10, 2),
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID),
    FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID)
);

-- Table 7: TestTypes
CREATE TABLE TestTypes (
    TestType_ID INT PRIMARY KEY AUTO_INCREMENT,
    TypeName VARCHAR(100) NOT NULL UNIQUE
);

-- Table 8: Tests (from Lab 3)
CREATE TABLE Tests (
    Test_ID INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID INT NOT NULL,      -- FK to Patients
    Employee_ID INT,              -- FK to Employees (who ordered/performed)
    Department_ID INT,            -- FK to Departments (where test was conducted)
    TestType_ID INT NOT NULL,     -- FK to TestTypes
    Test_Date DATE NOT NULL,
    Result VARCHAR(255) NOT NULL,
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID),
    FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID),
    FOREIGN KEY (Department_ID) REFERENCES Departments(Department_ID),
    FOREIGN KEY (TestType_ID) REFERENCES TestTypes(TestType_ID)
);

-- Table 9: PatientEmployeeAssistance
CREATE TABLE PatientEmployeeAssistance (
    Assistance_ID INT PRIMARY KEY AUTO_INCREMENT,
    Patient_ID INT NOT NULL, -- FK to Patients
    Employee_ID INT NOT NULL, -- FK to Employees
    AssistanceDate DATE NOT NULL,
    FOREIGN KEY (Patient_ID) REFERENCES Patients(Patient_ID),
    FOREIGN KEY (Employee_ID) REFERENCES Employees(Employee_ID)
);

-- 4. Insert Data into Tables

-- Insert Data into Departments
INSERT INTO Departments (Name, Location) VALUES
('General Medicine', 'Main Building'),
('Nursing', 'Main Building'),
('Laboratory', 'Lab Annex'),
('Rehabilitation', 'Rehab Center'),
('Radiology', 'Imaging Center'),
('Administration', 'Admin Wing');

-- Insert Data into EmployeeRoles
INSERT INTO EmployeeRoles (RoleName) VALUES
('Doctor'),
('Nurse'),
('Lab Technician'),
('Rehabilitation Therapist'),
('Administrator'),
('Surgeon');

-- Insert Data into Employees
INSERT INTO Employees (Name, Role_ID, Department_ID) VALUES
('Dr. Marcus Welby', (SELECT Role_ID FROM EmployeeRoles WHERE RoleName = 'Doctor'), (SELECT Department_ID FROM Departments WHERE Name = 'General Medicine')),
('Nurse Ratched', (SELECT Role_ID FROM EmployeeRoles WHERE RoleName = 'Nurse'), (SELECT Department_ID FROM Departments WHERE Name = 'Nursing')),
('Dr. House', (SELECT Role_ID FROM EmployeeRoles WHERE RoleName = 'Doctor'), (SELECT Department_ID FROM Departments WHERE Name = 'General Medicine')),
('Lab Tech Larry', (SELECT Role_ID FROM EmployeeRoles WHERE RoleName = 'Lab Technician'), (SELECT Department_ID FROM Departments WHERE Name = 'Laboratory')),
('Rehab Specialist Ron', (SELECT Role_ID FROM EmployeeRoles WHERE RoleName = 'Rehabilitation Therapist'), (SELECT Department_ID FROM Departments WHERE Name = 'Rehabilitation')),
('Dr. Grey', (SELECT Role_ID FROM EmployeeRoles WHERE RoleName = 'Surgeon'), (SELECT Department_ID FROM Departments WHERE Name = 'General Medicine')),
('Nurse Joy', (SELECT Role_ID FROM EmployeeRoles WHERE RoleName = 'Nurse'), (SELECT Department_ID FROM Departments WHERE Name = 'Nursing'));

-- Insert Data into Patients
INSERT INTO Patients (Name, Date_of_Birth, Gender, Address, City) VALUES
('Alice Smith', '1990-03-15', 'Female', '123 Oak St', 'Atlanta'),
('Bob Johnson', '1985-11-20', 'Male', '456 Pine Ave', 'Woodstock'),
('Charlie Brown', '1992-07-01', 'Male', '789 Elm Rd', 'Roswell'),
('Diana Prince', '1978-05-22', 'Female', '101 Maple Ln', 'Atlanta'),
('Eve Adams', '2000-01-10', 'Female', '300 Pine St', 'Marietta'),
('Frank Green', '1970-09-05', 'Male', '404 Elm Ave', 'Kennesaw'),
('Grace Hall', '1988-02-28', 'Female', '505 Willow Way', 'Woodstock'),
('Harry Potter', '1980-07-31', 'Male', 'Privet Drive', 'London');

-- Insert Data into Beds
INSERT INTO Beds (Room_Number, Ward_Name, Patient_ID) VALUES
('101A', 'General Ward', (SELECT Patient_ID FROM Patients WHERE Name = 'Alice Smith')),
('102B', 'General Ward', (SELECT Patient_ID FROM Patients WHERE Name = 'Bob Johnson')),
('205C', 'Pediatric Ward', NULL),
('301D', 'ICU', (SELECT Patient_ID FROM Patients WHERE Name = 'Diana Prince')),
('103A', 'General Ward', (SELECT Patient_ID FROM Patients WHERE Name = 'Grace Hall')),
('201A', 'Pediatric Ward', (SELECT Patient_ID FROM Patients WHERE Name = 'Charlie Brown'));

-- Insert Data into Treatments
INSERT INTO Treatments (Patient_ID, Employee_ID, Description, Treatment_Date, Cost) VALUES
((SELECT Patient_ID FROM Patients WHERE Name = 'Alice Smith'), (SELECT Employee_ID FROM Employees WHERE Name = 'Dr. Marcus Welby'), 'Physical Therapy', '2025-07-01', 150.00),
((SELECT Patient_ID FROM Patients WHERE Name = 'Bob Johnson'), (SELECT Employee_ID FROM Employees WHERE Name = 'Nurse Ratched'), 'Medication Administration', '2025-07-02', 75.50),
((SELECT Patient_ID FROM Patients WHERE Name = 'Bob Johnson'), (SELECT Employee_ID FROM Employees WHERE Name = 'Dr. House'), 'Surgery', '2025-07-05', 5000.00),
((SELECT Patient_ID FROM Patients WHERE Name = 'Charlie Brown'), (SELECT Employee_ID FROM Employees WHERE Name = 'Dr. Marcus Welby'), 'Physical Therapy', '2025-07-03', 150.00),
((SELECT Patient_ID FROM Patients WHERE Name = 'Charlie Brown'), (SELECT Employee_ID FROM Employees WHERE Name = 'Nurse Ratched'), 'Wound Care', '2025-07-03', 90.00),
((SELECT Patient_ID FROM Patients WHERE Name = 'Diana Prince'), (SELECT Employee_ID FROM Employees WHERE Name = 'Dr. House'), 'Medication Administration', '2025-07-04', 75.50),
((SELECT Patient_ID FROM Patients WHERE Name = 'Grace Hall'), (SELECT Employee_ID FROM Employees WHERE Name = 'Rehab Specialist Ron'), 'Physical Therapy', '2025-07-06', 150.00);

-- Insert Data into TestTypes
INSERT INTO TestTypes (TypeName) VALUES
('Blood Count'),
('X-Ray'),
('MRI Scan'),
('Urinalysis'),
('CT Scan'),
('Ultrasound');

-- Insert Data into Tests
INSERT INTO Tests (Patient_ID, Employee_ID, Department_ID, TestType_ID, Test_Date, Result) VALUES
((SELECT Patient_ID FROM Patients WHERE Name = 'Alice Smith'), (SELECT Employee_ID FROM Employees WHERE Name = 'Dr. Marcus Welby'), (SELECT Department_ID FROM Departments WHERE Name = 'Laboratory'), (SELECT TestType_ID FROM TestTypes WHERE TypeName = 'Blood Count'), '2025-06-28', 'Normal'),
((SELECT Patient_ID FROM Patients WHERE Name = 'Alice Smith'), (SELECT Employee_ID FROM Employees WHERE Name = 'Dr. Marcus Welby'), (SELECT Department_ID FROM Departments WHERE Name = 'Radiology'), (SELECT TestType_ID FROM TestTypes WHERE TypeName = 'X-Ray'), '2025-06-29', 'Clear'),
((SELECT Patient_ID FROM Patients WHERE Name = 'Alice Smith'), (SELECT Employee_ID FROM Employees WHERE Name = 'Dr. Marcus Welby'), (SELECT Department_ID FROM Departments WHERE Name = 'Radiology'), (SELECT TestType_ID FROM TestTypes WHERE TypeName = 'MRI Scan'), '2025-07-05', 'No anomalies'),
((SELECT Patient_ID FROM Patients WHERE Name = 'Charlie Brown'), (SELECT Employee_ID FROM Employees WHERE Name = 'Dr. Marcus Welby'), (SELECT Department_ID FROM Departments WHERE Name = 'Laboratory'), (SELECT TestType_ID FROM TestTypes WHERE TypeName = 'Blood Count'), '2025-07-06', 'Normal'),
((SELECT Patient_ID FROM Patients WHERE Name = 'Diana Prince'), (SELECT Employee_ID FROM Employees WHERE Name = 'Dr. House'), (SELECT Department_ID FROM Departments WHERE Name = 'Laboratory'), (SELECT TestType_ID FROM TestTypes WHERE TypeName = 'Blood Count'), '2025-07-01', 'Elevated WBC'),
((SELECT Patient_ID FROM Patients WHERE Name = 'Eve Adams'), (SELECT Employee_ID FROM Employees WHERE Name = 'Lab Tech Larry'), (SELECT Department_ID FROM Departments WHERE Name = 'Laboratory'), (SELECT TestType_ID FROM TestTypes WHERE TypeName = 'Urinalysis'), '2025-07-02', 'Negative'),
((SELECT Patient_ID FROM Patients WHERE Name = 'Frank Green'), (SELECT Employee_ID FROM Employees WHERE Name = 'Dr. House'), (SELECT Department_ID FROM Departments WHERE Name = 'Radiology'), (SELECT TestType_ID FROM TestTypes WHERE TypeName = 'CT Scan'), '2025-07-07', 'Fracture detected');

-- Insert Data into PatientEmployeeAssistance
INSERT INTO PatientEmployeeAssistance (Patient_ID, Employee_ID, AssistanceDate) VALUES
((SELECT Patient_ID FROM Patients WHERE Name = 'Alice Smith'), (SELECT Employee_ID FROM Employees WHERE Name = 'Dr. Marcus Welby'), '2025-07-01'),
((SELECT Patient_ID FROM Patients WHERE Name = 'Alice Smith'), (SELECT Employee_ID FROM Employees WHERE Name = 'Nurse Ratched'), '2025-07-01'),
((SELECT Patient_ID FROM Patients WHERE Name = 'Bob Johnson'), (SELECT Employee_ID FROM Employees WHERE Name = 'Nurse Ratched'), '2025-07-02'),
((SELECT Patient_ID FROM Patients WHERE Name = 'Charlie Brown'), (SELECT Employee_ID FROM Employees WHERE Name = 'Dr. Marcus Welby'), '2025-07-03'),
((SELECT Patient_ID FROM Patients WHERE Name = 'Diana Prince'), (SELECT Employee_ID FROM Employees WHERE Name = 'Dr. House'), '2025-07-04'),
((SELECT Patient_ID FROM Patients WHERE Name = 'Eve Adams'), (SELECT Employee_ID FROM Employees WHERE Name = 'Lab Tech Larry'), '2025-07-02'),
((SELECT Patient_ID FROM Patients WHERE Name = 'Grace Hall'), (SELECT Employee_ID FROM Employees WHERE Name = 'Rehab Specialist Ron'), '2025-07-06');
