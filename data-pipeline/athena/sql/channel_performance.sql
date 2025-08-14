WITH channel_spend AS (
    SELECT
        channel,
        SUM(spend) AS total_spend,
        SUM(installs) AS total_installs
    FROM marketing_spend
    GROUP BY channel
),

channel_revenue AS (
    SELECT
        u.channel,
        SUM(r.revenue) AS total_revenue
    FROM users AS u
    LEFT JOIN revenue_and_rewards AS r ON u.user_id = r.user_id
    WHERE u.channel IS NOT NULL
    GROUP BY u.channel
),

channel_conversions AS (
    SELECT
        channel,
        COUNT(DISTINCT user_id) AS conversions
    FROM user_touchpoints
    WHERE conversion = TRUE
    GROUP BY channel
)

SELECT
    cs.channel,
    cs.total_spend,
    COALESCE(cc.conversions, 0) AS conversions,
    CASE
        WHEN cs.total_installs > 0
            THEN
                ROUND(
                    CAST(COALESCE(cc.conversions, 0) AS DOUBLE)
                    / CAST(cs.total_installs AS DOUBLE)
                    * 100,
                    2
                )
        ELSE 0
    END AS conversion_rate,
    CASE
        WHEN
            cs.total_spend > 0
            THEN
                ROUND(
                    (COALESCE(cr.total_revenue, 0) / cs.total_spend - 1) * 100,
                    2
                )
        ELSE 0
    END AS roi_percentage
FROM channel_spend AS cs
LEFT JOIN channel_conversions AS cc ON cs.channel = cc.channel
LEFT JOIN channel_revenue AS cr ON cs.channel = cr.channel
ORDER BY roi_percentage DESC;
