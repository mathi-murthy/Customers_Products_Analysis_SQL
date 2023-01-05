SELECT 'Customers' AS table_name,
        13 AS number_of_attributes,
	    COUNT(*) AS number_of_rows
   FROM customers
  
  UNION ALL
 
 SELECT 'Products' AS table_name,
        9 AS number_of_attributes,
	    COUNT(*) AS number_of_rows
   FROM products
  
  UNION ALL

 SELECT 'ProductLines' AS table_name,
        4 AS number_of_attributes,
	    COUNT(*) AS number_of_rows
   FROM productlines
  
  UNION ALL 
   
 SELECT 'Orders' AS table_name,
        7 AS number_of_attributes,
	    COUNT(*) AS number_of_rows
   FROM orders
  
  UNION ALL
 
 SELECT 'OrderDetails' AS table_name,
        5 AS number_of_attributes,
	    COUNT(*) AS number_of_rows
   FROM orderdetails
  
  UNION ALL
 
 SELECT 'Payments' AS table_name,
        4 AS number_of_attributes,
	    COUNT(*) AS number_of_rows
   FROM payments
  
  UNION ALL
 
 SELECT 'Employees' AS table_name,
        8 AS number_of_attributes,
	    COUNT(*) AS number_of_rows
   FROM employees
  
  UNION ALL
 
 SELECT 'Offices' AS table_name,
        9 AS number_of_attributes,
	    COUNT(*) AS number_of_rows
   FROM offices;
   
   
   
   
 SELECT productCode,
        ROUND(SUM(quantityOrdered) * 1.0 / 
        (SELECT quantityInStock
		 FROM products pr
		 WHERE od.productCode = pr.productCode), 2) AS low_stock
   FROM orderdetails od
  GROUP BY productCode
  ORDER BY low_stock
  LIMIT 10;
  


	 
  SELECT productCode, 
         SUM(quantityOrdered * priceEach) AS prod_perf
    FROM orderdetails
   GROUP BY productCode
   ORDER BY prod_perf DESC
   LIMIT 10;
   
   

  WITH prfrm AS (
    SELECT productCode,
           SUM(quantityOrdered) * 1.0 AS qntOrdr,	
           SUM(quantityOrdered * priceEach) AS prod_perf
      FROM orderdetails
     GROUP BY productCode
  ),
  lstk AS (
    SELECT pr.productCode, 
	       pr.productName, 
		   pr.productLine,
           ROUND(SUM(prfrm.qntOrdr * 1.0) / pr.quantityInstock, 2) AS low_stock
      FROM products pr
	  JOIN prfrm
	    ON pr.productCode = prfrm.productCode
     GROUP BY pr.productCode
	 ORDER BY low_stock
	 LIMIT 10
  )
    SELECT lstk.productName, 
	       lstk.productLine
	  FROM lstk
	  JOIN prfrm
	    ON lstk.productCode = prfrm.productCode
	 ORDER BY prfrm.prod_perf DESC;
     
     
     
WITH profit_gen_table AS (
	SELECT os.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) AS prof_gen  
      FROM products pr
	  JOIN orderdetails od
	    ON pr.productCode = od.productCode
	  JOIN orders os
	    ON od.orderNumber = os.orderNumber
     GROUP BY os.customerNumber
  )
	SELECT contactLastName, contactFirstName, city, country, pg.prof_gen
	  FROM customers cust
	  JOIN profit_gen_table pg
	    ON pg.customerNumber = cust.customerNumber
	 ORDER BY pg.prof_gen
	 LIMIT 5;
     
     
     
     
WITH profit_gen_table AS (
	SELECT os.customerNumber, SUM(quantityOrdered * (priceEach - buyPrice)) AS prof_gen  
      FROM products pr
	  JOIN orderdetails od
	    ON pr.productCode = od.productCode
	  JOIN orders os
	    ON od.orderNumber = os.orderNumber
     GROUP BY os.customerNumber
  )
   SELECT AVG(pg.prof_gen) AS lyf_tym_val
     FROM profit_gen_table pg;
   