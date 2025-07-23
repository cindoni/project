# Clinic Database Reader

**Student:** Sidney Pham  
**Course:** Database Systems - Section W02  
**Professor:** Obioku Obotette  
**Lab:** Individual Lab 4

## Overview

This Python program demonstrates object-oriented programming principles by connecting to a MySQL database (`clinic_db_lab4`) and retrieving data from two predefined tables: **Patients** and **Treatments**. The program uses a complex connection string with proper error handling and formats the output for clear readability.

## Features

- **Object-Oriented Design**: Uses classes for database connection, table formatting, and main application logic
- **Complex Connection String**: Implements comprehensive MySQL connection parameters including charset, timeouts, and SQL modes
- **Proper Error Handling**: Includes try-catch blocks and resource cleanup
- **Formatted Output**: Tables are displayed with proper alignment and headers
- **Well-Documented Code**: Extensive comments and docstrings throughout

## Database Tables

### Patients Table Schema
- `Patient_ID` (INT, PRIMARY KEY, AUTO_INCREMENT)
- `Name` (VARCHAR(100), NOT NULL)
- `Date_of_Birth` (DATE)
- `Gender` (VARCHAR(10))
- `Address` (VARCHAR(255))
- `City` (VARCHAR(100))

### Treatments Table Schema
- `Treatment_ID` (INT, PRIMARY KEY, AUTO_INCREMENT)
- `Patient_ID` (INT, NOT NULL, FK to Patients)
- `Employee_ID` (INT, FK to Employees)
- `Description` (VARCHAR(255), NOT NULL)
- `Treatment_Date` (DATE, NOT NULL)
- `Cost` (DECIMAL(10, 2))

## Prerequisites

1. **MySQL Server** installed and running
2. **Python 3.7+** installed
3. **clinic_db_lab4** database created with sample data

## Installation

1. Clone or download the project files
2. Install required dependencies:
   ```bash
   pip install -r requirements.txt
   ```

## Configuration

Before running the program, update the database connection parameters in `clinic_db_reader.py`:

```python
connection_params = {
    'host': 'localhost',        # Your MySQL server host
    'database': 'clinic_db_lab4',
    'user': 'your_username',    # Your MySQL username
    'password': 'your_password', # Your MySQL password
    'port': 3306,
    # ... other parameters
}
```

## Usage

Run the program from the command line:

```bash
python clinic_db_reader.py
```

## Program Output

The program will display:
1. **Table Schemas** - Structure of both tables
2. **Connection Information** - Database connection details
3. **Patients Table** - All patient records formatted as a table
4. **Treatments Table** - All treatment records with employee names
5. **Execution Summary** - Record counts and completion status

## Classes and Methods

### DatabaseConnection
- `__init__()` - Initialize connection parameters
- `connect()` - Establish database connection
- `disconnect()` - Close connection and cleanup
- `execute_query()` - Execute SELECT queries

### TableFormatter
- `format_table()` - Format query results into readable tables

### ClinicDatabaseReader
- `setup_connection()` - Configure database connection
- `read_patients_table()` - Retrieve patient data
- `read_treatments_table()` - Retrieve treatment data with joins
- `display_table_schemas()` - Show table structure
- `run()` - Main execution method

## Error Handling

The program includes comprehensive error handling for:
- Database connection failures
- Query execution errors
- Resource cleanup
- Keyboard interrupts

## Dependencies

- `mysql-connector-python==8.2.0` - MySQL database connector
- Built-in Python modules: `datetime`, `sys`, `typing`
