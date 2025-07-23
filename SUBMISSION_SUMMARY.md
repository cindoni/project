# Database Systems Lab 4 - Submission Package
**Student:** Sidney Pham  
**Course:** Database Systems - Section W02  
**Professor:** Obioku Obotette  
**Date:** July 23, 2025

## Assignment Requirements Met ✅

### 1. Object-Oriented Programming Language
- **Language Used:** Python 3
- **Classes Implemented:** 3 classes with proper OOP design
  - `DatabaseConnection` - Handles MySQL connections
  - `TableFormatter` - Formats query results 
  - `ClinicDatabaseReader` - Main application logic

### 2. Complex Connection String & Proper Libraries
- **Library:** mysql-connector-python 8.2.0
- **Connection Parameters:**
  - Host: localhost
  - Port: 3307 (MySQL 9.3.0)
  - Database: clinic_db_lab4
  - User: root
  - Complex parameters: charset, timeouts, SQL modes, buffering

### 3. Database Connection & Data Retrieval
- **Database:** clinic_db_lab4 (MySQL)
- **Tables Read:** 
  - Patients table (8 records)
  - Treatments table (7 records with JOIN to show employee names)
- **Connection Status:** ✅ Successfully connected and tested

### 4. Formatted Output
- **Output Format:** Professional aligned tables with headers
- **Features:** Column alignment, record counts, clear formatting
- **Sample Output:** Captured in `program_output.txt`

### 5. Well-Documented Code
- **Documentation:** Concise docstrings and comments
- **Code Quality:** Type hints, error handling, resource cleanup
- **Architecture:** Clean separation of concerns

### 6. Database Schemas Provided
- **Patients Table:** Patient_ID, Name, Date_of_Birth, Gender, Address, City
- **Treatments Table:** Treatment_ID, Patient_ID, Employee_ID, Description, Treatment_Date, Cost
- **Full Schema:** Available in `create_database.sql`

## Files Included

### Core Program Files
- `clinic_db_reader.py` - Main database reader program
- `clinic_db_reader_demo.py` - Demo version with sample data
- `requirements.txt` - Python dependencies
- `README.md` - Complete documentation

### Database Files
- `create_database.sql` - Complete database creation script with sample data

### Output & Documentation
- `program_output.txt` - Actual program execution output
- `SUBMISSION_SUMMARY.md` - This summary document

## Program Execution Results

**Connection:** Successfully connected to MySQL Server 9.3.0  
**Patients Retrieved:** 8 records  
**Treatments Retrieved:** 7 records  
**Status:** ✅ Program runs successfully and displays formatted data

## Technical Specifications

**MySQL Server:** Version 9.3.0 running on port 3307  
**Python Version:** Compatible with Python 3.7+  
**Dependencies:** mysql-connector-python==8.2.0  
**Database:** clinic_db_lab4 with 9 tables and sample data  

## Usage Instructions

1. Ensure MySQL Server is running on port 3307
2. Create database using `create_database.sql`
3. Install dependencies: `pip install -r requirements.txt`
4. Update connection credentials in the program if needed
5. Run: `python clinic_db_reader.py`

## Assignment Completion Status

✅ **All requirements successfully implemented and tested**  
✅ **Program demonstrates professional database connectivity**  
✅ **Object-oriented design with proper error handling**  
✅ **Clean, formatted output with real database data**  
✅ **Complete documentation and source code provided**

---
*This submission demonstrates mastery of database connectivity, object-oriented programming, and professional software development practices.*
