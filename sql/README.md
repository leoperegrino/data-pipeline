# SQL Analytics

## channel performance

```sql
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
```


```csv
channel,total_spend,conversions,conversion_rate,roi_percentage
tiktok,10600.0,3,0.3,'-96.95
facebook,16090.0,3,0.17,'-97.43
twitter,9900.0,3,0.44,'-98.66
google,21650.0,3,0.15,'-98.72
youtube,20800.0,3,0.18,'-98.91
```


## rewards analysis

```sql
WITH user_rewards_summary AS (
    SELECT
        user_id,
        SUM(reward_to_user) AS total_rewards,
        SUM(revenue) AS total_revenue,
        COUNT(*) AS transaction_count
    FROM revenue_and_rewards
    GROUP BY user_id
),

rewards_percentiles AS (
    SELECT
        user_id,
        total_rewards,
        total_revenue,
        transaction_count,
        PERCENT_RANK() OVER (
            ORDER BY total_rewards
        ) AS rewards_percentile
    FROM user_rewards_summary
),

top_rewards_users AS (
    SELECT
        rp.user_id,
        rp.total_rewards,
        rp.total_revenue,
        rp.transaction_count,
        u.channel AS acquisition_channel,
        u.created_at AS signup_date
    FROM rewards_percentiles AS rp
    INNER JOIN users AS u ON rp.user_id = u.user_id
    WHERE rp.rewards_percentile >= 0.9
)

SELECT
    user_id,
    acquisition_channel,
    signup_date,
    total_rewards,
    total_revenue,
    transaction_count,
    ROUND(total_revenue / NULLIF(total_rewards, 0), 2)
        AS revenue_per_reward_unit,
    CASE
        WHEN total_revenue > 0
            THEN ROUND((total_rewards / total_revenue) * 100, 2)
        ELSE 0
    END AS reward_rate_percentage
FROM top_rewards_users
ORDER BY total_rewards DESC;
```

```csv
user_id,acquisition_channel,signup_date,total_rewards,total_revenue,transaction_count,revenue_per_reward_unit,reward_rate_percentage
USR_001,facebook,2024-01-01 08:18:45,0.0049,244.9,10,49979.59,0.0
```

## User lifetime value

```sql
WITH recent_users AS (
    SELECT
        user_id,
        channel,
        DATE(from_iso8601_timestamp(created_at)) AS signup_date
    FROM users
    WHERE
        DATE(from_iso8601_timestamp(created_at)) >= DATE_ADD('day', -90, CURRENT_DATE)
        AND channel IS NOT NULL
),

user_30day_revenue AS (
    SELECT
        ru.user_id,
        ru.channel,
        ru.signup_date,
        SUM(CASE
            WHEN
                DATE(from_iso8601_timestamp(r.date)) BETWEEN ru.signup_date AND DATE_ADD(
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
```

```csv
channel,users_acquired,avg_30day_ltv,total_30day_revenue,median_30day_ltv,
```

