-- Set the size of one page and the size of a line
SET PAGESIZE 20
SET LINESIZE 150

-- Prompt input info
ACCEPT search_city PROMPT 'Enter the city: '
ACCEPT search_rooms PROMPT 'Enter the number of rooms: '

-- Turn off terminal output
SET TERMOUT OFF
SET VERIFY OFF

-- Get the current date using a substitution variable
COLUMN TODAY NEW_VALUE report_date
SELECT TO_CHAR(SYSDATE, 'fmMonth DD, YYYY') AS TODAY
FROM DUAL;

-- Show the title of the report at the top of the page
TTITLE CENTER 'Find Properties Report ' report_date SKIP 2
 /* Places and formats a specified title at the bottom of each report page */
BTITLE CENTER "For Management Only"

-- After the SPOOL command, anything entered or displayed on standard output is written to the spool file.
SPOOL Q4result.txt

-- Set column headings and format as needed
COLUMN property_name FORMAT A20 HEADING 'Property Name'
COLUMN property_address FORMAT A35 HEADING 'Property Address'
COLUMN property_rooms FORMAT 999 HEADING 'Rooms'
COLUMN property_availability FORMAT A20 HEADING 'Availability'

-- Retrieve the necessary information for the report
SELECT p.name AS property_name,
       a.street || ', ' || a.city || ', ' || a.zipcode AS property_address,
       p.rooms AS property_rooms,
       p.availability AS property_availability
FROM property p
JOIN address a ON p.addressid = a.id
WHERE a.city = '&search_city'
  AND p.rooms = &search_rooms
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