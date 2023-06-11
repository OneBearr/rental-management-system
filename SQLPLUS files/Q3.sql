-- Set the size of one page and the size of a line
SET PAGESIZE 20
SET LINESIZE 150

-- Prompt input info
ACCEPT branch_name PROMPT 'Enter the name of the branch: '
ACCEPT owner_name PROMPT 'Enter the owner name: '
ACCEPT owner_phone PROMPT 'Enter the owner phone number: '

-- Turn off terminal output
SET TERMOUT OFF
SET VERIFY OFF

-- Get the current date using a substitution variable
COLUMN TODAY NEW_VALUE report_date
SELECT TO_CHAR(SYSDATE, 'fmMonth DD, YYYY') AS TODAY
FROM DUAL;

-- Show the title of the report at the top of the page
TTITLE CENTER 'Owner Properties Report ' report_date SKIP 2
 /* Places and formats a specified title at the bottom of each report page */
BTITLE CENTER "For Management Only"

-- After the SPOOL command, anything entered or displayed on standard output is written to the spool file.
SPOOL Q3result.txt

-- Set column headings and format as needed
COLUMN owner_name FORMAT A20 HEADING 'Owner Name'
COLUMN owner_phone FORMAT A20 HEADING 'Owner Phone'
COLUMN property_name FORMAT A20 HEADING 'Property Name'
COLUMN property_address FORMAT A35 HEADING 'Property Address'
COLUMN branch_name FORMAT A20 HEADING 'Branch Name'

-- Retrieve the necessary information for the report
SELECT o.name AS owner_name,
       o.phone AS owner_phone,
       p.name AS property_name,
       a.street || ', ' || a.city || ', ' || a.zipcode AS property_address,
       b.name AS branch_name
FROM property p
JOIN owner o ON p.ownerid = o.id
JOIN branch b ON p.branchid = b.id
JOIN address a ON p.addressid = a.id
WHERE o.name = '&owner_name'
  AND o.phone = '&owner_phone'
  AND b.name = '&branch_name';

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