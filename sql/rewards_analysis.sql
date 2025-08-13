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
