WITH ProductAddToCartCounts AS (
    SELECT 
        event_day,
        product,
        COUNT(DISTINCT [user]) AS customer_count
    FROM 
        dbo.last_version_dataset
    WHERE 
        event_type = 'add_to_cart'
    GROUP BY 
        event_day, product
),
RankedProducts AS (
    SELECT 
        event_day,
        product,
        customer_count,
        RANK() OVER (PARTITION BY event_day ORDER BY customer_count DESC) AS rank
    FROM 
        ProductAddToCartCounts
)
SELECT 
    event_day,
    product,
    customer_count
FROM 
    RankedProducts
WHERE 
    rank = 1
ORDER BY 
    event_day;
