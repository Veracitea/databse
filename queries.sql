--Queries:
--Q1:Given a customer by an email address, returns the product ids that have been ordered
--and paid by this customer but not yet shipped. (MJ) - dones
--assumptions: 'paid' = fully paid
SELECT Product_id
FROM Order_item oi, Invoice i, Orders o, Customer c
WHERE i.status = 'paid' AND oi.Order_id = i.Order_id
AND NOT oi.status = 'shipped'
AND oi.Order_id = o.Order_id
AND o.Customer_id = c.Customer_id
AND c.email = 'rwillemanju@newsvine.com';
--bmacartney2@reuters.com (for alternate case)

--CORRECT AND CHECKED:
SELECT Product_id
FROM Order_item oi, Invoice i, Orders o, Customer c
WHERE i.status = 'paid' AND oi.Order_id = i.Order_id
AND NOT oi.status = 'shipped'
AND oi.Order_id = o.Order_id
AND o.Customer_id = c.Customer_id
AND c.email = 'vstallondm@bizjournals.com'

--Q2:Find the 3 bestselling product type ids in terms of product quantity sold. The products of
--concerned must be ordered and paid. Whether they have been shipped is irrelevant. (BJ)
--Find number of products sold per product id -dones
--assumptions: count as sold, only when invoice is paid
--assumptions: paid = fully paid

SELECT TOP 3 p.Product_Type_id , SUM(oi.quantity) AS Counter
FROM Product p, Order_item oi, Invoice i 
WHERE p.Product_id = oi.Product_id AND oi.Order_id = i.Order_id AND i.status = 'paid' 
GROUP BY p.Product_Type_id
ORDER BY Counter DESC;
--THE ABOVE IS CORRECT AND CHECKED

--Q3:Return the descriptions of all the 2nd level product types. The product types with no parent
--will be regarded as 1st level product types and their direct child product types will be
--regarded as 2nd level. (HK TRY)
--assumption: a product_type cannot have multiple parents
SELECT DISTINCT(description)
FROM Product_Type 
WHERE parent_product_type_id IN (SELECT product_type_id
								FROM Product_Type p
								Where p.parent_product_type_id IS NULL);
--THE ABOVE IS CORRECT AND CHECKED

--Q4:Find 2 product ids that are ordered together the most. (T)
--do query b4 inserting
INSERT INTO Order_item(Order_id,seq_id,unit_price,quantity,status,Shipment_id,Product_id) VALUES ('OI10651',2,13,3,'processing',NULL,'PRODUCT_1');
--doquery after inserting
SELECT TOP 1 c.original_p , c.bought_with, count(*) AS times_together
FROM(
    SELECT a.product_id as original_p , b.product_id AS bought_with
	FROM order_item AS a 
	INNER JOIN order_item AS b
	ON a.order_id = b.order_id AND a.product_id != b.product_id) AS c 
group by c.original_p , c.bought_with
ORDER BY times_together DESC 

--appended version checked and correct (can change top 1 to top 5 to show the appended object)
SELECT TOP 1 c.original_p , c.bought_with, count(*) AS times_together
FROM(
    SELECT a.product_id as original_p , b.product_id AS bought_with
	FROM order_item AS a 
	INNER JOIN order_item AS b
	ON a.order_id = b.order_id AND a.seq_id<b.seq_id) AS c 
group by c.original_p , c.bought_with
ORDER BY times_together DESC

--Q5:Get 3 random customers and return their email addresses. (HAHAHA SIKEEEE)

SELECT TOP 3 email FROM Customer  
ORDER BY NEWID();
--checked and correct
--run multiple times to show randomness in video. Each try will give different emails.
--explanation for our video: NewId() generates a random GUID or unique identifier which can be used to return randomized rows 
--from a query since each time NewID() function is called, a new random uniqueidentifier is generated, where each random value 
--is different in the select list than the random values in Order By clause. Thus randomizing the extraction of customer rows.



--Design two queries that are not in the above list. They are evaluated based on the usefulness,
--complexity, and the interestingness.
--Q6: Find users who has the same emails for different customers 
SELECT email
FROM Customer
GROUP BY email
HAVING COUNT(Customer_id) > 10;
--above not complete, below tested and checked
--changed code:

SELECT customer_id, email
FROM Customer
WHERE email IN (
	SELECT email
	FROM Customer
	GROUP BY email
	HAVING COUNT(Customer_id) > 10
);




--Q7: Find out the top sales for each product type for a recommendation system, showing product name and shop.
--Only products with primary relation to each product type are considered.

-- Get products purchased per user 
WITH per_user AS (
  	SELECT 
	  order_id,
	  Product_id,
	  SUM(quantity) AS per_user_total
	FROM Order_item
	GROUP BY order_id , product_id
),

-- SUM of each product purchased regardless of users
all_users AS (
  	SELECT 
	  product_id,
	  SUM(per_user_total) AS total_products 
  	FROM per_user
  	GROUP BY product_id
),

-- Combine together with type of product
with_type AS (
	SELECT 
  		all_users.product_id,
  		Product.product_type_id,
  		all_users.total_products
	FROM all_users
  	LEFT JOIN Product
  	ON Product.Product_id = all_users.product_id
),

-- Get the product with highest orders within each product type using a window function
max_per_id AS (
  	SELECT 
  		product_id , 
  		product_type_id,
  		total_products,
  		ROW_NUMBER() OVER (PARTITION BY product_type_id ORDER BY total_products DESC) ROW_NUM
  	FROM with_type
)

-- Find the product_id, product_type_id and total_products sold for the product with the top sales within each product type.
SELECT M.product_id, M.product_type_id, M.total_products, P.Shop_id
FROM max_per_id M, Product P
WHERE M.product_id = P.product_id 
AND ROW_NUM = 1
ORDER BY total_products desc;