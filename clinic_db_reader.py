"""
Clinic Database Reader
Student: Sidney Pham
Course: Database Systems
Section: W02
Professor: Obioku Obotette
Lab: Individual Lab 4

This program connects to the clinic_db_lab4 MySQL database and retrieves
data from two predefined tables: Patients and Treatments.
It demonstrates object-oriented programming principles and proper database
connection handling.
"""

import mysql.connector
from mysql.connector import Error
from datetime import datetime
import sys
from typing import List, Dict, Any, Optional


class DatabaseConnection:
    """
    A class to handle MySQL database connections with proper error handling
    and resource management.
    """
    
    def __init__(self, host: str, database: str, user: str, password: str, 
                 port: int = 3306, charset: str = 'utf8mb4',
                 autocommit: bool = True, connection_timeout: int = 10):
        """
        Initialize database connection parameters.
        

        """
        self.connection_config = {
            'host': host,
            'database': database,
            'user': user,
            'password': password,
            'port': port,
            'charset': charset,
            'autocommit': autocommit,
            'connection_timeout': connection_timeout,
            'sql_mode': 'STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO',
            'use_unicode': True,
            'buffered': True
        }
        self.connection: Optional[mysql.connector.MySQLConnection] = None
        self.cursor: Optional[mysql.connector.cursor.MySQLCursor] = None
    
    def connect(self) -> bool:
        """
        Establish connection to the MySQL database.
        
        Returns:
            bool: True if connection successful, False otherwise
        """
        try:
            print("Establishing database connection...")
            print(f"Connecting to: {self.connection_config['host']}:{self.connection_config['port']}")
            print(f"Database: {self.connection_config['database']}")
            
            self.connection = mysql.connector.connect(**self.connection_config)
            
            if self.connection.is_connected():
                self.cursor = self.connection.cursor(dictionary=True)
                db_info = self.connection.get_server_info()
                print(f"Successfully connected to MySQL Server version: {db_info}")
                print(f"Connection ID: {self.connection.connection_id}")
                return True
            else:
                print("Failed to establish database connection")
                return False
                
        except Error as e:
            print(f"Error connecting to MySQL database: {e}")
            return False
    
    def disconnect(self) -> None:
        """Close database connection and cursor."""
        try:
            if self.cursor:
                self.cursor.close()
                print("Database cursor closed")
            
            if self.connection and self.connection.is_connected():
                self.connection.close()
                print("Database connection closed")
                
        except Error as e:
            print(f"Error closing database connection: {e}")
    
    def execute_query(self, query: str) -> List[Dict[str, Any]]:
        """
        Execute a SELECT query and return results.
        
        Args:
            query: SQL SELECT query string
            
        Returns:
            List of dictionaries containing query results
        """
        try:
            if not self.cursor:
                raise Exception("Database cursor not available")
            
            print(f"Executing query: {query}")
            self.cursor.execute(query)
            results = self.cursor.fetchall()
            print(f"Query returned {len(results)} rows")
            return results
            
        except Error as e:
            print(f"Error executing query: {e}")
            return []


class TableFormatter:
    """
    A utility class for formatting database query results into readable tables.
    """
    
    @staticmethod
    def format_table(data: List[Dict[str, Any]], title: str) -> str:
        """
        Format query results into a readable table format.
        
        Args:
            data: List of dictionaries containing table data
            title: Table title for display
            
        Returns:
            Formatted string representation of the table
        """
        if not data:
            return f"\n{title}\n{'=' * len(title)}\nNo data found.\n"
        
        # Get column names from first row
        columns = list(data[0].keys())
        
        # Calculate column widths
        col_widths = {}
        for col in columns:
            col_widths[col] = max(
                len(str(col)),
                max(len(str(row.get(col, ''))) for row in data)
            )
        
        # Build formatted table
        output = []
        output.append(f"\n{title}")
        output.append("=" * len(title))
        
        # Header row
        header = " | ".join(str(col).ljust(col_widths[col]) for col in columns)
        output.append(header)
        output.append("-" * len(header))
        
        # Data rows
        for row in data:
            formatted_row = " | ".join(
                str(row.get(col, '')).ljust(col_widths[col]) for col in columns
            )
            output.append(formatted_row)
        
        output.append(f"\nTotal records: {len(data)}")
        output.append("")
        
        return "\n".join(output)


class ClinicDatabaseReader:
    """
    Main application class for reading and displaying clinic database tables.
    """
    
    def __init__(self):
        """Initialize the clinic database reader."""
        self.db_connection = None
        self.formatter = TableFormatter()
    
    def setup_connection(self) -> bool:
        """
        Set up database connection with complex connection string.
        
        Returns:
            bool: True if connection successful, False otherwise
        """
        # Complex connection configuration
        # Note: Update these credentials to match your MySQL setup
        connection_params = {
            'host': 'localhost',  # or your MySQL server IP
            'database': 'clinic_db_lab4',
            'user': 'root',  # Update with your MySQL username
            'password': 'Her0brin3781!',
            'port': 3307,
            'charset': 'utf8mb4',
            'autocommit': True,
            'connection_timeout': 15
        }
        
        self.db_connection = DatabaseConnection(**connection_params)
        return self.db_connection.connect()
    
    def read_patients_table(self) -> List[Dict[str, Any]]:
        """
        Read and return all data from the Patients table.
        
        Returns:
            List of patient records
        """
        query = """
        SELECT 
            Patient_ID,
            Name,
            Date_of_Birth,
            Gender,
            Address,
            City
        FROM Patients
        ORDER BY Patient_ID
        """
        return self.db_connection.execute_query(query)
    
    def read_treatments_table(self) -> List[Dict[str, Any]]:
        """
        Read and return all data from the Treatments table with employee names.
        
        Returns:
            List of treatment records with employee information
        """
        query = """
        SELECT 
            t.Treatment_ID,
            p.Name AS Patient_Name,
            e.Name AS Employee_Name,
            t.Description,
            t.Treatment_Date,
            t.Cost
        FROM Treatments t
        JOIN Patients p ON t.Patient_ID = p.Patient_ID
        LEFT JOIN Employees e ON t.Employee_ID = e.Employee_ID
        ORDER BY t.Treatment_Date DESC, t.Treatment_ID
        """
        return self.db_connection.execute_query(query)
    
    def display_table_schemas(self) -> None:
        """Display the schema information for the tables being read."""
        print("\nDATABASE TABLE SCHEMAS")
        print("=" * 50)
        
        print("\nPATIENTS TABLE SCHEMA:")
        print("-" * 25)
        print("Patient_ID (INT, PRIMARY KEY, AUTO_INCREMENT)")
        print("Name (VARCHAR(100), NOT NULL)")
        print("Date_of_Birth (DATE)")
        print("Gender (VARCHAR(10))")
        print("Address (VARCHAR(255))")
        print("City (VARCHAR(100))")
        
        print("\nTREATMENTS TABLE SCHEMA:")
        print("-" * 27)
        print("Treatment_ID (INT, PRIMARY KEY, AUTO_INCREMENT)")
        print("Patient_ID (INT, NOT NULL, FK to Patients)")
        print("Employee_ID (INT, FK to Employees)")
        print("Description (VARCHAR(255), NOT NULL)")
        print("Treatment_Date (DATE, NOT NULL)")
        print("Cost (DECIMAL(10, 2))")
        print()
    
    def run(self) -> None:
        """Main execution method for the database reader application."""
        print("CLINIC DATABASE READER")
        print("=" * 50)
        print(f"Execution Time: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
        print("Student: Sidney Pham")
        print("Course: Database Systems - Section W02")
        print("Professor: Obioku Obotette")
        print("Lab: Individual Lab 4")
        
        try:
            # Display table schemas
            self.display_table_schemas()
            
            # Establish database connection
            if not self.setup_connection():
                print("Failed to connect to database. Exiting...")
                return
            
            print("\nREADING DATABASE TABLES")
            print("=" * 50)
            
            # Read and display Patients table
            print("\nRetrieving Patients table data...")
            patients_data = self.read_patients_table()
            patients_output = self.formatter.format_table(
                patients_data, 
                "PATIENTS TABLE CONTENTS"
            )
            print(patients_output)
            
            # Read and display Treatments table
            print("Retrieving Treatments table data...")
            treatments_data = self.read_treatments_table()
            treatments_output = self.formatter.format_table(
                treatments_data, 
                "TREATMENTS TABLE CONTENTS (with Employee Names)"
            )
            print(treatments_output)
            
            # Summary
            print("EXECUTION SUMMARY")
            print("=" * 50)
            print(f"Patients records retrieved: {len(patients_data)}")
            print(f"Treatment records retrieved: {len(treatments_data)}")
            print("Database read operation completed successfully!")
            
        except Exception as e:
            print(f"An error occurred during execution: {e}")
            
        finally:
            # Clean up database connection
            if self.db_connection:
                self.db_connection.disconnect()


def main():
    """Main entry point for the application."""
    try:
        app = ClinicDatabaseReader()
        app.run()
    except KeyboardInterrupt:
        print("\nProgram interrupted by user.")
    except Exception as e:
        print(f"Unexpected error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
