--3.soru

WITH FirstSessions AS (
    SELECT 
        [user],
        MIN(session) AS first_session,
        MIN(event_day) AS first_session_date
    FROM 
        last_version_dataset
    GROUP BY 
        [user]
),

OrdersWithinTwoDays AS (  
    SELECT 
        data.[user]
    FROM 
        last_version_dataset data
    JOIN 
        FirstSessions fs ON data.[user] = fs.[user]
    WHERE 
        data.event_type = 'order' AND 
        event_day BETWEEN fs.first_session_date AND DATEADD(DAY, 2, fs.first_session_date)
    GROUP BY 
        data.[user]

)


SELECT 
    COUNT(DISTINCT [user]) AS number_customer_placed_order_within_two_days_time_after_first_session
FROM 
    OrdersWithinTwoDays;


