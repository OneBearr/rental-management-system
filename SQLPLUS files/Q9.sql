-- Set the size of one page and the size of a line
SET PAGESIZE 20
SET LINESIZE 200

-- Turn off terminal output
SET TERMOUT OFF

-- Get the current date using a substitution variable
COLUMN TODAY NEW_VALUE report_date
SELECT TO_CHAR(SYSDATE, 'fmMonth DD, YYYY') AS TODAY
FROM DUAL;

-- Show the title of the report at the top of the page
TTITLE CENTER 'Average Rent Report ' report_date SKIP 2
 /* Places and formats a specified title at the bottom of each report page */
BTITLE CENTER "For Management Only"

-- After the SPOOL command, anything entered or displayed on standard output is written to the spool file.
SPOOL Q9result.txt

-- Set column headings and format as needed
COLUMN rental_company_title HEADING 'Rental Company Title'
COLUMN current_date HEADING 'Current Date'
COLUMN num_properties_available HEADING 'Number of Properties Available'
COLUMN num_properties_leased HEADING 'Number of Properties Leased'
COLUMN avg_rent HEADING 'Average Rent'

-- Retrieve the necessary information for the report
SELECT 'StrawberryFields Rental Management Inc' AS rental_company_title,
       TO_CHAR(SYSDATE, 'fmMonth DD, YYYY') AS current_date,
       COUNT(CASE WHEN Availability = 'Available' THEN 1 END) AS num_properties_available,
       COUNT(CASE WHEN Availability = 'Leased' THEN 1 END) AS num_properties_leased,
       AVG(MonthlyRent) AS avg_rent
FROM Property;

-- Spool off to stop writing to the spool file
SPOOL OFF

-- Turn off formatting commands
CLEAR COLUMNS
CLEAR BREAK
TTITLE OFF
BTITLE OFF
SET VERIFY OFF
SET FEEDBACK OFF
SET RECSEP OFF
SET ECHO OFF