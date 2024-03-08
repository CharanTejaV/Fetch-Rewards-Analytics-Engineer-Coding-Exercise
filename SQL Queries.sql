/* 1.What are the top 5 brands by receipts scanned for the most recent month? */

WITH RankedBrands AS 
(
    SELECT 
        b.name AS brand_name, 
        COUNT(r.receipt_id) AS receipts_count,  
        DENSE_RANK() OVER (ORDER BY COUNT(r.receipt_id) DESC) as brand_rank
    FROM Brand b
    JOIN Transaction t ON b.brand_id = t.brand_id
    JOIN Receipts r ON r.receipt_id = t.receipt_id
    WHERE YEAR(r.dateScanned) = YEAR(GETDATE()) 
        AND MONTH(r.dateScanned) = MONTH(GETDATE())
    GROUP BY b.name
)
SELECT 
    brand_name, receipts_count
FROM RankedBrands
WHERE brand_rank <= 5;

/* 2.How does the ranking of the top 5 brands by receipts scanned for the recent month compare to the ranking for the previous month? */

WITH RankedBrands AS 
(
    SELECT 
        b.name AS brand_name, 
        DATEADD(MONTH, DATEDIFF(MONTH, 0, r.dateScanned), 0) AS scan_month,
          COUNT(r.receipt_id) AS receipts_count,
        DENSE_RANK() OVER (
            PARTITION BY DATEADD(MONTH, DATEDIFF(MONTH, 0, r.dateScanned), 0) 
            ORDER BY COUNT(r.receipt_id) DESC
        ) AS brand_rank
    FROM Brand b
    JOIN Transaction t ON b.brand_id = t.brand_id
    JOIN Receipts r ON r.receipt_id = t.receipt_id
    WHERE
        DATEADD(MONTH, DATEDIFF(MONTH, 0, r.dateScanned), 0) IN (
            DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0), 
            DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0)
        )
    GROUP BY b.name, DATEADD(MONTH, DATEDIFF(MONTH, 0, r.dateScanned), 0)
)
SELECT 
    brand_name, 
    MAX(CASE WHEN scan_month = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) THEN brand_rank END) AS current_month_rank,
    MAX(CASE WHEN scan_month = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0) THEN brand_rank END) AS previous_month_rank
FROM RankedBrands
WHERE brand_rank <= 5
GROUP BY brand_name;

/* 3.When considering average spend from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater? */

SELECT
    CASE
        WHEN rewardsReceiptStatus = 'FINISHED' THEN 'Accepted'
        WHEN rewardsReceiptStatus = 'REJECTED' THEN 'Rejected'
    END AS status,
    AVG(totalSpent) AS average_spend
FROM Receipts
WHERE rewardsReceiptStatus IN ('FINISHED', 'REJECTED')
GROUP BY 
    CASE
        WHEN rewardsReceiptStatus = 'FINISHED' THEN 'Accepted'
        WHEN rewardsReceiptStatus = 'REJECTED' THEN 'Rejected'
    END
ORDER BY average_spend DESC;
/* If you want a single result indicating which status has a greater average spend, you can further modify the query: */
SELECT
    MAX(status) AS greater_status,
    MAX(average_spend) AS greater_average_spend
FROM 
(
    SELECT
    CASE
        WHEN rewardsReceiptStatus = 'FINISHED' THEN 'Accepted'
        WHEN rewardsReceiptStatus = 'REJECTED' THEN 'Rejected'
    END AS status,
    AVG(totalSpent) AS average_spend
FROM Receipts
WHERE rewardsReceiptStatus IN ('FINISHED', 'REJECTED')
GROUP BY 
    CASE
        WHEN rewardsReceiptStatus = 'FINISHED' THEN 'Accepted'
        WHEN rewardsReceiptStatus = 'REJECTED' THEN 'Rejected'
    END) AS subquery;

/* 4.When considering the total number of items purchased from receipts with 'rewardsReceiptStatus’ of ‘Accepted’ or ‘Rejected’, which is greater? */
SELECT
    CASE
        WHEN rewardsReceiptStatus = 'FINISHED' THEN 'Accepted'
        WHEN rewardsReceiptStatus = 'REJECTED' THEN 'Rejected'
    END AS status,
    SUM(purchasedItemCount) AS total_items_purchased
FROM Receipts
WHERE rewardsReceiptStatus IN ('FINISHED', 'REJECTED')
GROUP BY 
    CASE
        WHEN rewardsReceiptStatus = 'FINISHED' THEN 'Accepted'
        WHEN rewardsReceiptStatus = 'REJECTED' THEN 'Rejected'
    END
ORDER BY total_items_purchased DESC;
/* If you want a single result indicating which status has a greater total number of items purchased, you can further modify the query:*/
SELECT
    MAX(status) AS greater_status,
    MAX(total_items_purchased) AS greater_total_items_purchased
FROM 
(
    SELECT
    CASE
        WHEN rewardsReceiptStatus = 'FINISHED' THEN 'Accepted'
        WHEN rewardsReceiptStatus = 'REJECTED' THEN 'Rejected'
    END AS status,
    SUM(purchasedItemCount) AS total_items_purchased
FROM Receipts
WHERE rewardsReceiptStatus IN ('FINISHED', 'REJECTED')
GROUP BY 
    CASE
        WHEN rewardsReceiptStatus = 'FINISHED' THEN 'Accepted'
        WHEN rewardsReceiptStatus = 'REJECTED' THEN 'Rejected'
    END) AS subquery;

/* 5.Which brand has the most spend among users who were created within the past 6 months? */
SELECT TOP 1
    b.name AS BrandName,
    SUM(r.totalSpent) AS total_spend
FROM Users u
JOIN Transaction t ON u.user_id = t.user_id
JOIN Receipts r ON t.receipt_id = r.receipt_id
JOIN Brand b ON t.brand_id = b.brand_id
WHERE u.createdDate >= DATEADD(MONTH, -6, GETDATE())
GROUP BY b.name
ORDER BY TotalBrandSpend DESC;

/* 6.Which brand has the most transactions among users who were created within the past 6 months? */
SELECT TOP 1 
    b.name AS BrandName, 
    COUNT(t.receipt_id) AS NumberOfTransactions
FROM Users u
JOIN Transaction t ON u.user_id = t.user_id
JOIN Brand b ON t.brand_id = b.brand_id
WHERE u.createdDate >= DATEADD(MONTH, -6, GETDATE())
GROUP BY b.name
ORDER BY NumberOfTransactions DESC;