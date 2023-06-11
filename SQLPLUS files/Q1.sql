-- Set the size of one page and the size of a line
SET PAGESIZE 20
SET LINESIZE 200

-- Prompt the user to enter the name of the branch
ACCEPT branch_name PROMPT 'Enter the name of the branch: '

-- Turn off terminal output
SET TERMOUT OFF
SET VERIFY OFF

-- Get the current date using a substitution variable
COLUMN TODAY NEW_VALUE report_date
SELECT TO_CHAR(SYSDATE, 'fmMonth DD, YYYY') AS TODAY
FROM DUAL;

-- Show the title of the report at the top of the page
TTITLE CENTER 'Available Properties Report ' report_date SKIP 2
 /* Places and formats a specified title at the bottom of each report page */
BTITLE CENTER "For Management Only"

-- After the SPOOL command, anything entered or displayed on standard output is written to the spool file.
SPOOL Q1result.txt

-- Set column headings and format as needed
COLUMN property_id FORMAT 9999 HEADING 'Property Number'
COLUMN property_name FORMAT A20 HEADING 'Property Name'
COLUMN property_address FORMAT A35 HEADING 'Property Address'
COLUMN property_availability FORMAT A20 HEADING 'Availability'
COLUMN branch_name FORMAT A20 HEADING 'Branch Name'

-- Retrieve the necessary information for the report
SELECT p.Id AS property_id,
       p.Name AS property_name,
       a.street || ', ' || a.city || ', ' || a.zipcode AS property_address,
       p.availability AS property_availability,
       b.name AS branch_name
FROM property p
JOIN address a ON p.addressid = a.id
JOIN branch b ON p.branchid = b.id
WHERE b.name = '&branch_name'
  AND p.availability = 'Available';

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