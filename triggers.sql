Constraints
 When the full payment to an invoice is made, the invoice status is changed from ‘issued’
to ‘paid’.


 When an order item is shipped, its status is changed from ‘processing’ to ‘shipped’.


 When all the products in an order have been shipped, the order status is changed from
‘processing’ to ‘completed’.


 There can be at most 3 payments to an invoice, i.e., if the customer chooses to perform
partial payments, the 3rd payment must complete the full amount.


 If an ordered has been paid, either fully or partially, it can no longer be cancelled, i.e., its
status cannot be changed to ‘cancelled’.
CREATE TRIGGER autoAddMutualFriend ON Friends
AFTER INSERT
AS
BEGIN
INSERT INTO Friends
SELECT friendID, ownerID
FROM INSERTED
END
