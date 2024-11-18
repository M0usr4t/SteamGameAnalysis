# Games Views

CREATE VIEW game_rating AS
SELECT
	game_id,
    name,
    ROUND(positive_user_score / (positive_user_score+negative_user_score),2) AS pct_pos,
    ROUND(negative_user_score / (positive_user_score + negative_user_score), 2) AS pct_neg,
    metacritic_score
FROM game_metrics
WHERE positive_user_score <> 0 OR negative_user_score <> 0;

# ccu/user rating to price analysis
CREATE VIEW ccu_rating_cost_analysis AS
WITH normalized_data AS (
	SELECT
		gm.name,
		gm.initial_price,
		gm.current_price,
		r.pct_pos,
		gm.ccu,
		MAX(gm.ccu) OVER () AS max_ccu
	FROM game_metrics gm
    JOIN game_rating r ON
    gm.game_id = r.game_id
)
SELECT
    name,
    ROUND(((ccu / max_ccu) * pct_pos * 100.00) / NULLIF(current_price, 0.01),2) AS current_value_rating,
    ROUND(((ccu / max_ccu) * pct_pos * 100.00) / NULLIF(initial_price, 0.01),2) AS initial_value_rating
FROM normalized_data
WHERE ccu > 10000 AND pct_pos > 0.8
ORDER BY current_value_rating DESC, initial_value_rating DESC;

# metacritic to user score
CREATE VIEW user_score_to_metacritic AS
WITH game_votes AS (	
    SELECT
        game_id,
        name,
        SUM(positive_user_score) + SUM(negative_user_score) AS total_votes
    FROM game_metrics
    GROUP BY game_id, name
)
SELECT
    gv.name,
    ROUND(AVG(r.pct_pos * 100.0), 2) AS user_score_pos,
    ROUND(AVG(r.pct_neg * 100.0), 2) AS user_score_neg,
    AVG(r.metacritic_score) AS metacritic_score
FROM game_votes gv
JOIN game_rating r
ON gv.game_id = r.game_id
WHERE metacritic_score IS NOT NULL
GROUP BY gv.name
ORDER BY  metacritic_score, user_score_pos DESC;

CREATE VIEW active_owners AS
SELECT
	name,
    ROUND(ccu/((owners_min + owners_max)*0.5) * 100.0,2) AS pct_active_owners
FROM game_metrics
WHERE name <> 'Farming Simulator 25'
ORDER BY pct_active_owners DESC;


    