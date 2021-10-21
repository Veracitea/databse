--Queries:
--Q1:Given a customer by an email address, returns the product ids that have been ordered
--and paid by this customer but not yet shipped. (MJ)
SELECT Product_id
FROM Order_item oi, Invoice i, Orders o, Customer c
WHERE i.status = 'paid' AND oi.Order_id = i.Order_id
AND NOT oi.status = 'shipped'
AND oi.Order_id = o.Order_id
AND o.Customer_id = c.Customer_id
AND c.email = 'bmacartney2@reuters.com';

--Q2:Find the 3 bestselling product type ids in terms of product quantity sold. The products of
--concerned must be ordered and paid. Whether they have been shipped is irrelevant. (BJ)


--Q3:Return the descriptions of all the 2nd level product types. The product types with no parent
--will be regarded as 1st level product types and their direct child product types will be
--regarded as 2nd level. (HK TRY)


--Q4:Find 2 product ids that are ordered together the most. (T)


--Q5:Get 3 random customers and return their email addresses. (HAHAHA SIKEEEE)


--Design two queries that are not in the above list. They are evaluated based on the usefulness,
--complexity, and the interestingness.
--Q6:ASDFGHJKL;'\
--Q7:
