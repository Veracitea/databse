--Constraints
-- When the full payment to an invoice is made, the invoice status is changed from ‘issued’
--to ‘paid’.


-- When an order item is shipped, its status is changed from ‘processing’ to ‘shipped’.


-- When all the products in an order have been shipped, the order status is changed from
--‘processing’ to ‘completed’.


-- There can be at most 3 payments to an invoice, i.e., if the customer chooses to perform
--partial payments, the 3rd payment must complete the full amount.


-- If an ordered has been paid, either fully or partially, it can no longer be cancelled, i.e., its
--status cannot be changed to ‘cancelled’.

--T ATTEMPT NOT CONFIRMED TO BE RIGHT
CREATE TRIGGER cancelOrder
AFTER UPDATE status ON Orders
REFERENCING OLD TABLE AS Ord
AS
BEGIN
  IF EXIST(
    SELECT * FROM Payment NATURAL JOIN Invoice AS newT
    WHERE newT.Order_id=Ord.Order_id)
  BEGIN
    RAISEERROR('Cannot cancel, payment was made')
    ROLLBACK TRANSACTION
  END
END
