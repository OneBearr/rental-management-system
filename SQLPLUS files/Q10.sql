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
TTITLE CENTER 'Properties Expire in Two Months Report ' report_date SKIP 2
 /* Places and formats a specified title at the bottom of each report page */
BTITLE CENTER "For Management Only"

-- After the SPOOL command, anything entered or displayed on standard output is written to the spool file.
SPOOL Q10result.txt

-- Set column headings and format as needed
COLUMN property_name FORMAT A20 HEADING 'Property Name'
COLUMN property_address FORMAT A40 HEADING 'Property Address'
COLUMN lease_expiration_date HEADING 'Lease Expiration Date'

-- Run the query to retrieve properties with leases expiring in the next two months
SELECT p.Name AS property_name,
       a.street || ', ' || a.city || ', ' || a.zipcode AS property_address,
       ag.EndDate AS lease_expiration_date
FROM Property p
JOIN Address a ON p.AddressId = a.Id
JOIN Agreement ag ON p.Id = ag.propertyId
WHERE ag.EndDate BETWEEN SYSDATE AND ADD_MONTHS(SYSDATE, 2);

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