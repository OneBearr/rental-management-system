-- Set the size of one page and the size of a line
SET PAGESIZE 20
SET LINESIZE 150

-- Turn off terminal output
SET TERMOUT OFF

-- Get the current date using a substitution variable
COLUMN TODAY NEW_VALUE report_date
SELECT TO_CHAR(SYSDATE, 'fmMonth DD, YYYY') AS TODAY
FROM DUAL;

-- Show the title of the report at the top of the page
TTITLE CENTER 'Monthly Profit Report ' report_date SKIP 2
 /* Places and formats a specified title at the bottom of each report page */
BTITLE CENTER "For Management Only"

-- After the SPOOL command, anything entered or displayed on standard output is written to the spool file.
SPOOL Q11result.txt

-- Set column headings and format as needed
COLUMN rental_company_title HEADING 'Rental Company Title'
COLUMN current_date HEADING 'Current Date'
COLUMN total_earnings HEADING 'Monthly Earning'

-- Run the query to retrieve properties with leases expiring in the next two months
SELECT 'StrawberryFields Rental Management Inc' AS rental_company_title,
       TO_CHAR(SYSDATE, 'fmMonth DD, YYYY') AS current_date,
       SUM(0.1 * monthlyrent) AS total_earnings
FROM property
WHERE availability = 'Leased';

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