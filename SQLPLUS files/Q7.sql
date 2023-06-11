-- Set the size of one page and the size of a line
SET PAGESIZE 20
SET LINESIZE 200

-- Prompt input info
ACCEPT renter_home_phone PROMPT 'Enter renter home phone number: '

-- Turn off terminal output
SET TERMOUT OFF
SET VERIFY OFF

-- Get the current date using a substitution variable
COLUMN TODAY NEW_VALUE report_date
SELECT TO_CHAR(SYSDATE, 'fmMonth DD, YYYY') AS TODAY
FROM DUAL;

-- Show the title of the report at the top of the page
TTITLE CENTER 'Renter Agreement Report ' report_date SKIP 2
 /* Places and formats a specified title at the bottom of each report page */
BTITLE CENTER "For Management Only"

-- After the SPOOL command, anything entered or displayed on standard output is written to the spool file.
SPOOL Q7result.txt

-- Set column headings and format as needed
COLUMN agreement_id FORMAT 999 HEADING 'Agreement Id'
COLUMN property_name FORMAT A20 HEADING 'Property Name'
COLUMN property_address FORMAT A35 HEADING 'Property Address'
COLUMN renter_name FORMAT A12 HEADING 'Renter Name'
COLUMN renter_home# FORMAT A15 HEADING 'Renter Home #'
COLUMN renter_work# FORMAT A15 HEADING 'Renter Work #'
COLUMN start_date HEADING 'Start Date'
COLUMN end_date HEADING 'End Date'
COLUMN deposit HEADING 'Deposit'
COLUMN monthly_rent HEADING 'Monthly Rent'


-- Retrieve the necessary information for the report
SELECT a.id AS agreement_id,
       p.name AS property_name,
       ad.street || ', ' || ad.city || ', ' || ad.zipcode AS property_address,
       a.rentername AS renter_name,
       a.renterhome# AS renter_home#,
       a.renterwork# AS renter_work#,
       a.startdate AS start_date,
       a.enddate AS end_date,
       a.deposit,
       a.monthlyrent AS monthly_rent
FROM agreement a
JOIN property p ON a.propertyid = p.id
JOIN address ad ON p.addressid = ad.id
WHERE a.renterhome# = '&renter_home_phone';

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