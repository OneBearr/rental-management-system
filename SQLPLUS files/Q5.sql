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
TTITLE CENTER 'Available Report by Branch ' report_date SKIP 2
 /* Places and formats a specified title at the bottom of each report page */
BTITLE CENTER "For Management Only"

-- After the SPOOL command, anything entered or displayed on standard output is written to the spool file.
SPOOL Q5result.txt

-- Set column headings and format as needed
COLUMN branch_name FORMAT A20 HEADING 'Branch Name'
COLUMN property_count FORMAT 999 HEADING '# of properties available'

-- Retrieve the necessary information for the report
SELECT b.name AS branch_name,
        COUNT(p.id) AS property_count
FROM branch b
LEFT JOIN property p ON b.id = p.branchid
WHERE p.availability = 'Available'
GROUP BY b.name;

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