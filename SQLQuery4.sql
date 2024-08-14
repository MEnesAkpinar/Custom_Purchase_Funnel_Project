
WITH FirstSessions  AS (

	SELECT 
		[user],
		MIN(session) AS first_session

	FROM last_version_dataset

	GROUP BY 
		[user]

),

FirstSessionEvents AS (
    SELECT 
        data.[user],
        data.event_day,
        data.session,
        data.event_type
    FROM 
        last_version_dataset data
    JOIN 
        FirstSessions fs ON data.[user] = fs.[user] AND data.session = fs.first_session
),	

FilteredUsers AS (
    SELECT 
        [user]
    FROM 
        FirstSessionEvents
    GROUP BY 
        [user]
    HAVING 
        COUNT(DISTINCT event_type) = 1 AND 
        MAX(event_type) = 'page_view'
)

SELECT 
    event_day,
    COUNT(DISTINCT [user]) AS number_of_client_only_viewed_products_in_first_session
FROM 
    FirstSessionEvents
WHERE 
    [user] IN (SELECT [user] FROM FilteredUsers)
GROUP BY 
    event_day
ORDER BY 
    event_day;