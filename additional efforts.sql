CREATE TRIGGER checkShop --check if pdt in shops truly follow their pdt type restriction
ON Product
AFTER INSERT
AS
BEGIN
	IF NOT EXISTS (SELECT *
		   FROM inserted as i
		   WHERE i.Shop_id IN (SELECT r.Shop_id
				       FROM restricted_to_sell as r
				       WHERE r.Product_Type_id=i.Product_Type_id) --shop had restriction and pdt-type matches it
		   OR i.Shop_id NOT IN  (SELECT r.Shop_id
				       FROM restricted_to_sell as r)) --that shop no restriction at all
	BEGIN
	RAISERROR (‘This shop cannot sell this product type...', 16, 10); --may delete this
	ROLLBACK TRANSACTION
	RETURN   
	END;
END;
