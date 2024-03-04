USE sakila;

-- Write a query to find what is the total business done by each store.
SELECT s.store_id, SUM(p.amount) AS total_sales
FROM store s
JOIN staff st ON s.manager_staff_id = st.staff_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;
    
-- Converting it to a stored procedure;
DELIMITER //

CREATE PROCEDURE GetTotalSalesByStore()
BEGIN
    SELECT s.store_id, SUM(p.amount) AS total_sales
    FROM store s
    JOIN staff st ON s.manager_staff_id = st.staff_id
    JOIN payment p ON st.staff_id = p.staff_id
    GROUP BY s.store_id;
END //

DELIMITER ;

-- Calling it to test:
CALL GetTotalSalesByStore();

-- Making it so it takes the store_id as a paramater:
DELIMITER //

CREATE PROCEDURE GetTotalSalesForStore(IN storeId INT)
BEGIN
    SELECT s.store_id, SUM(p.amount) AS total_sales
    FROM store s
    JOIN staff st ON s.manager_staff_id = st.staff_id
    JOIN payment p ON st.staff_id = p.staff_id
    WHERE s.store_id = storeId
    GROUP BY s.store_id;
END //

DELIMITER ;

-- Calling it to test:
CALL GetTotalSalesForStore(1);
CALL GetTotalSalesForStore(2);

-- Modifying it further more:
DELIMITER //

CREATE PROCEDURE GetTotalSalesForStore(IN storeId INT)
BEGIN
    DECLARE total_sales_value FLOAT;

    SELECT SUM(p.amount) INTO total_sales_value
    FROM store s
    JOIN staff st ON s.manager_staff_id = st.staff_id
    JOIN payment p ON st.staff_id = p.staff_id
    WHERE s.store_id = storeId;

    SELECT total_sales_value AS total_sales_for_store;
END //

DELIMITER ;

-- Calling it:
CALL GetTotalSalesForStore(1);
CALL GetTotalSalesForStore(2);

-- Make it sort into flags:
DELIMITER //

CREATE PROCEDURE GetTotalSalesAndFlagForStore(IN storeId INT)
BEGIN
    DECLARE total_sales_value FLOAT;
    DECLARE flag VARCHAR(10);

    SELECT SUM(p.amount) INTO total_sales_value
    FROM store s
    JOIN staff st ON s.manager_staff_id = st.staff_id
    JOIN payment p ON st.staff_id = p.staff_id
    WHERE s.store_id = storeId;

    SET flag = CASE
        WHEN total_sales_value > 30000 THEN 'green_flag'
        ELSE 'red_flag'
    END;

    SELECT total_sales_value AS total_sales_for_store, flag AS sales_flag;
END //

DELIMITER ;

-- Calling it:
CALL GetTotalSalesAndFlagForStore(1);
CALL GetTotalSalesAndFlagForStore(2);