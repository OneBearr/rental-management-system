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
-- TTITLE CENTER 'Supervision Report ' report_date SKIP 2
 /* Places and formats a specified title at the bottom of each report page */
-- BTITLE CENTER "For Management Only"

-- After the SPOOL command, anything entered or displayed on standard output is written to the spool file.
SPOOL Q2result.txt

-- Set column headings and format as needed
COLUMN manager_name FORMAT A20 HEADING 'Manager Name'
COLUMN supervisor_name FORMAT A20 HEADING 'Supervisor Name'
COLUMN property_name FORMAT A20 HEADING 'Property Name'
COLUMN property_address FORMAT A35 HEADING 'Property Address'

-- Retrieve the necessary information for the report
SELECT name AS manager_name
FROM sfemployee
WHERE job = 'Manager';

SELECT s.name AS supervisor_name, m.name AS manager_name
FROM sfemployee s
JOIN sfemployee m ON s.managerid = m.id
WHERE s.job = 'Supervisor';

SELECT s.name AS supervisor_name, p.name AS property_name, a.street || ', ' || a.city || ', ' || a.zipcode AS property_address
FROM sfemployee s
JOIN property p ON s.id = p.supervisorid
JOIN address a ON p.addressid = a.id
WHERE s.job = 'Supervisor';

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