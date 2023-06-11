-- Set the size of one page and the size of a line
SET PAGESIZE 50
SET LINESIZE 200

-- Prompt input info
ACCEPT property_id PROMPT 'Enter the property ID: '
ACCEPT renter_name PROMPT 'Enter the renter name: '
ACCEPT renter_home PROMPT 'Enter the renter home number: '
ACCEPT renter_work PROMPT 'Enter the renter work number: '
ACCEPT start_date PROMPT 'Enter the start date (YYYY-MM-DD): '
ACCEPT end_date PROMPT 'Enter the end date (YYYY-MM-DD): '
ACCEPT deposit PROMPT 'Enter the deposit: '

-- Turn off terminal output
SET TERMOUT OFF
SET VERIFY OFF

-- Get the current date using a substitution variable
COLUMN TODAY NEW_VALUE report_date
SELECT TO_CHAR(SYSDATE, 'fmMonth DD, YYYY') AS TODAY
FROM DUAL;

-- Show the title of the report at the top of the page
TTITLE CENTER 'Create Agreement Report ' report_date SKIP 2
 /* Places and formats a specified title at the bottom of each report page */
BTITLE CENTER "For Management Only"

-- After the SPOOL command, anything entered or displayed on standard output is written to the spool file.
SPOOL Q6result.txt

-- Insert the agreement into the table
INSERT INTO agreement (id, propertyid, rentername, renterhome#, renterwork#, startdate, enddate, deposit, monthlyrent)
VALUES ((SELECT MAX(id) + 1 FROM agreement), &property_id, '&renter_name', '&renter_home', '&renter_work',
    TO_DATE('&start_date', 'YYYY-MM-DD'), TO_DATE('&end_date', 'YYYY-MM-DD'), &deposit,
    (SELECT monthlyrent FROM property WHERE id = &property_id));

-- Display the newly created agreement
-- SELECT * FROM agreement WHERE id = (SELECT MAX(id) FROM agreement);
SELECT * FROM agreement;

---- Spool off to stop writing to the spool file
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