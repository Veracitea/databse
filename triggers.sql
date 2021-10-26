--Constraints
-- When the full payment to an invoice is made, the invoice status is changed from ‘issued’
--to ‘paid’.
-- There can be at most 3 payments to an invoice, i.e., if the customer chooses to perform
--partial payments, the 3rd payment must complete the full amount.

--correct
CREATE TRIGGER paymentMade
ON Payment
AFTER INSERT
AS
BEGIN
	IF EXISTS(SELECT *
		  FROM inserted AS i, Invoice AS inv
		  WHERE i.invoice_number = inv.invoice_number
		  AND i.amount > inv.due)
	BEGIN
	RAISERROR ('You paid extra...', 16, 1); --may delete this
	ROLLBACK TRANSACTION
	RETURN   
	END;
	
	IF (SELECT COUNT(*)
	    FROM Payment p, inserted i
	    WHERE i.invoice_number = p.invoice_number) = 3
	    BEGIN
	    IF EXISTS(SELECT *
		      FROM inserted i, Invoice inv
		      WHERE i.invoice_number = inv.invoice_number
		      AND i.amount < inv.due)
		      BEGIN
		      RAISERROR ('You did not pay enough for your last payment', 16, 1);
		      ROLLBACK TRANSACTION
		      RETURN
		      END;
	     END;
	 IF EXISTS(SELECT *
		   FROM inserted i, Invoice inv
		   WHERE i.invoice_number = inv.invoice_number
		   AND i.amount = inv.due)
	BEGIN
	UPDATE Invoice
	SET Invoice.status = 'paid'
	FROM inserted i
	WHERE i.invoice_number = Invoice.invoice_number
    RETURN
	END;
    IF EXISTS(SELECT *
		   FROM inserted i, Invoice inv
		   WHERE i.invoice_number = inv.invoice_number
		   AND i.amount < inv.due)
    BEGIN
    UPDATE Invoice
	SET Invoice.due = Invoice.due - i.amount
    FROM inserted i, Invoice
    WHERE i.invoice_number = Invoice.invoice_number
    RETURN
	END;
END;

--check 
INSERT INTO Payment(Payment_id,date,amount,CreditCard_number,Invoice_number) VALUES ('PAY_358','3/1/2021 4:30',17,'3545065312808460','IN49325700');
-- change payment amount to test, not enough, overshot, partial paymeny, full payment
SELECT *
FROM Invoice
WHERE invoice_number = 'IN49325700'
	



--count the number of payments made
SELECT COUNT(*)
FROM Payment p
GROUP BY p.Invoice_id;


-- When an order item is shipped, its status is changed from ‘processing’ to ‘shipped’. (probably refer to when ship arrives)

CREATE TRIGGER OrderItemShipped
ON Shipment
AFTER UPDATE
AS
BEGIN
	IF EXISTS (SELECT *
		   FROM inserted as i, deleted as d
		   WHERE i.status = 'reached'
		   AND d.status = 'departed')
	BEGIN
	UPDATE Order_item
  	SET status = 'shipped'
  	FROM inserted AS i
  	WHERE Order_item.Shipment_id = i.Shipment_id
	END;
END;

-- When all the products in an order have been shipped, the order status is changed from
--‘processing’ to ‘completed’.

--correct
CREATE TRIGGER OrderFulfilled
ON Order_item
AFTER UPDATE
AS
BEGIN
	IF EXISTS(SELECT *
		  FROM Order_item AS oi, inserted AS i
		  WHERE oi.Order_id = i.Order_id
		  AND oi.status <> 'shipped')
	BEGIN
	RETURN
	END;
	BEGIN
	UPDATE Orders
	SET status = 'completed'
	FROM inserted i
	WHERE Orders.Order_id = i.Order_id
	END;
END;


--test code
--UPDATE Order_item
--SET status = 'shipped'
--FROM Order_item as oi
--WHERE oi.Order_id = 'OI89697'

		  





-- If an ordered has been paid, either fully or partially, it can no longer be cancelled, i.e., its
--status cannot be changed to ‘cancelled’.
--correct...code?:D
CREATE TRIGGER cancelOrder
ON Orders 
AFTER UPDATE 
AS
BEGIN
	IF EXISTS (SELECT 1 
    	FROM Payment AS p, Invoice AS inv , inserted AS i, deleted AS d
    	WHERE i.status = 'cancelled'
    	AND (d.status <>'cancelled')
    	AND inv.Order_id=i.Order_id AND p.Invoice_number=inv.Invoice_number
          )  
	BEGIN  
	RAISERROR ('You have already made payment for this order...', 16, 1); --may delete this
	ROLLBACK TRANSACTION
	RETURN   
	END
    BEGIN
  	UPDATE Order_item
  	SET status = 'cancelled'
  	FROM inserted AS i
  	WHERE Order_item.Order_id = i.Order_id;
  	END;
END; 
--code to try update
--UPDATE Orders
--SET status = 'cancelled'
--WHERE Order_id = 'OI76526';

--code to find order id of ppl with orders unpaid
--select order_id from Orders
--where order_id not in 
--(SELECT distinct order_id FROM Payment as p Inner join Invoice as i on i.Invoice_number=p.Invoice_number)

