CREATE OR REPLACE PROCEDURE update_lease_rent (
  p_property_id IN property.id%TYPE,
  p_previous_rent OUT property.monthlyrent%TYPE,
  p_new_rent OUT property.monthlyrent%TYPE
)
AS
BEGIN
  -- Retrieve the previous rent for the property from the property table
  SELECT monthlyrent
  INTO p_previous_rent
  FROM property
  WHERE id = p_property_id;

  -- Calculate the new rent as 10% more than the previous rent
  p_new_rent := p_previous_rent * 1.1;

  -- Update the property table with the new rent
  UPDATE property
  SET monthlyrent = p_new_rent
  WHERE id = p_property_id;

  -- Update the agreement table with the new rent for the latest lease agreement
  UPDATE agreement
  SET monthlyrent = p_new_rent
  WHERE propertyid = p_property_id
  AND id = (
    SELECT MAX(id)
    FROM agreement
    WHERE propertyid = p_property_id
  );
END;

CREATE OR REPLACE TRIGGER update_lease_rent_trigger
BEFORE INSERT ON agreement
FOR EACH ROW
DECLARE
  previous_rent property.monthlyrent%TYPE;
  new_rent property.monthlyrent%TYPE;
BEGIN
  -- Call the stored procedure to calculate and update the new rent
  update_lease_rent(:new.propertyid, previous_rent, new_rent);
  :new.monthlyrent := new_rent;
END;
