SELECT 
    [user],
    COUNT(DISTINCT session) as session_count,
    COUNT(DISTINCT product) as product_count,
    COUNT(*) as total_events,
    DATEDIFF(MINUTE, MIN(event_day), MAX(event_day)) as time_span_minutes
FROM 
    dbo.last_version_dataset
GROUP BY 
    [user]
HAVING 
    COUNT(DISTINCT session) > 1  AND
    COUNT(DISTINCT product) > 10 AND
    DATEDIFF(MINUTE, MIN(event_day), MAX(event_day)) < 60
ORDER BY 
    COUNT(*) DESC
