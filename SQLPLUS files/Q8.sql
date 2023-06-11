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
TTITLE CENTER 'Renter Report ' report_date SKIP 2
 /* Places and formats a specified title at the bottom of each report page */
BTITLE CENTER "For Management Only"

-- After the SPOOL command, anything entered or displayed on standard output is written to the spool file.
SPOOL Q8result.txt

-- Set column headings and format as needed
COLUMN renter_name FORMAT A12 HEADING 'Renter Name'
COLUMN rental_count HEADING 'Rental Count'

-- Retrieve the necessary information for the report
SELECT a.rentername AS renter_name,
       COUNT(*) AS rental_count
FROM agreement a
GROUP BY a.rentername
HAVING COUNT(*) > 1;

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