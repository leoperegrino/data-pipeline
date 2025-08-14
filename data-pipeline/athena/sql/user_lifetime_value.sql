WITH recent_users AS (
    SELECT
        user_id,
        channel,
        DATE(FROM_ISO8601_TIMESTAMP(created_at)) AS signup_date
    FROM users
    WHERE
        DATE(FROM_ISO8601_TIMESTAMP(created_at))
        >= DATE_ADD('day', -90, CURRENT_DATE)
        AND channel IS NOT NULL
),

user_30day_revenue AS (
    SELECT
        ru.user_id,
        ru.channel,
        ru.signup_date,
        SUM(CASE
            WHEN
                DATE(
                    FROM_ISO8601_TIMESTAMP(r.date)
                ) BETWEEN ru.signup_date AND DATE_ADD(
                    'day', 30, ru.signup_date
                )
                THEN r.revenue
            ELSE 0
        END) AS ltv_30day
    FROM recent_users AS ru
    LEFT JOIN revenue_and_rewards AS r ON ru.user_id = r.user_id
    GROUP BY ru.user_id, ru.channel, ru.signup_date
)

SELECT
    channel,
    COUNT(DISTINCT user_id) AS users_acquired,
    ROUND(AVG(ltv_30day), 2) AS avg_30day_ltv,
    ROUND(SUM(ltv_30day), 2) AS total_30day_revenue,
    ROUND(APPROX_PERCENTILE(ltv_30day, 0.5), 2) AS median_30day_ltv
FROM user_30day_revenue
GROUP BY channel
ORDER BY avg_30day_ltv DESC;
