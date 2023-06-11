CREATE OR REPLACE TRIGGER update_lease_agreement_rent
BEFORE INSERT OR UPDATE OF MONTHLYRENT, STARTDATE, ENDDATE ON agreement
FOR EACH ROW
BEGIN
  IF :new.STARTDATE IS NOT NULL AND :new.ENDDATE IS NOT NULL THEN
    -- Calculate the difference in months between STARTDATE and ENDDATE
    DECLARE
      lease_months INT;
    BEGIN
      lease_months := MONTHS_BETWEEN(:new.ENDDATE, :new.STARTDATE);
      IF lease_months = 6 THEN
        -- Calculate the lease agreement rent as 10% more than the regular rent
        :new.MONTHLYRENT := :new.MONTHLYRENT * 1.1;
      ELSE
        -- Handle the case when the lease agreement is not for six months
        -- You can raise an exception or take appropriate actions here
        -- For example:
        RAISE_APPLICATION_ERROR(-20001, 'The lease agreement must be for six months.');
      END IF;
    END;
  END IF;
END;
