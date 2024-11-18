# Genre Views
CREATE VIEW genre_details AS
WITH game_totals AS (
    SELECT
        gm.game_id,
        CASE
            WHEN (gm.owners_min * gm.initial_price) < 10000000 THEN ROUND((gm.owners_min * gm.initial_price) * 0.70, 0)
            WHEN (gm.owners_min * gm.initial_price) BETWEEN 10000000 AND 50000000 THEN ROUND((gm.owners_min * gm.initial_price) * 0.75, 0)
            WHEN (gm.owners_min * gm.initial_price) > 50000000 THEN ROUND((gm.owners_min * gm.initial_price) * 0.80, 0)
        END AS revenue
    FROM game_metrics gm
    WHERE gm.initial_price > 0.00
),
games_on_all_platforms AS (
    SELECT
        pb.game_id
    FROM game_platforms_bridge pb
    GROUP BY pb.game_id
    HAVING COUNT(DISTINCT pb.platform_id) = 3
),
ftp_non_ftp_counts AS (
    SELECT
        gm.game_id,
        CASE WHEN gm.initial_price = 0 THEN 1 ELSE 0 END AS is_ftp,
        CASE WHEN gm.initial_price > 0 THEN 1 ELSE 0 END AS is_non_ftp
    FROM game_metrics gm
)
SELECT
    gl.genre,
    gl.genre_id,
    COUNT(DISTINCT gm.game_id) AS total_games,
    SUM(gm.ccu) AS total_ccu,
    ROUND(AVG(r.pct_pos), 2) AS avg_pos_user_rating,
    ROUND(AVG(r.pct_neg), 2) AS avg_neg_user_rating,
    ROUND(AVG((gm.owners_min + gm.owners_max) * 0.5), 0) AS avg_owners,
    CASE
        WHEN ROUND(AVG(gm.initial_price), 2) < 0.00 THEN 0.00
        ELSE ROUND(AVG(gm.initial_price), 2)
    END AS avg_initial_price,
    CASE
        WHEN ROUND(AVG(gm.current_price), 2) < 0.00 THEN 0.00
        ELSE ROUND(AVG(gm.current_price), 2)
    END AS avg_current_price,
    SUM(gt.revenue) AS total_revenue,
    COUNT(gap.game_id) AS num_games_all_platforms,
    (COUNT(DISTINCT gm.game_id) - COUNT(gap.game_id)) AS num_games_not_all_platforms,
    SUM(ftp.is_ftp) AS count_ftp,
    SUM(ftp.is_non_ftp) AS count_non_ftp
FROM genres_lookup gl
JOIN game_genres_bridge ggb ON gl.genre_id = ggb.genre_id
JOIN game_metrics gm ON ggb.game_id = gm.game_id
LEFT JOIN game_totals gt ON gm.game_id = gt.game_id
LEFT JOIN games_on_all_platforms gap ON gm.game_id = gap.game_id
LEFT JOIN game_rating r ON gm.game_id = r.game_id
LEFT JOIN ftp_non_ftp_counts ftp ON gm.game_id = ftp.game_id
GROUP BY gl.genre, gl.genre_id
ORDER BY total_games DESC;


CREATE VIEW seasonal_genre_release AS
WITH seasons AS (
	SELECT
		game_id,
		CASE 
			WHEN MONTH(release_date) IN (12,1,2) THEN 'winter'
			WHEN MONTH(release_date) IN (3, 4, 5) THEN 'Spring'
			WHEN MONTH(release_date) IN (6, 7, 8) THEN 'Summer'
			WHEN MONTH(release_date) IN (9, 10, 11) THEN 'Fall'
		END AS season_released,
		YEAR(release_date) AS release_year
	FROM game_metrics
	WHERE release_date < '2024-11-12' 
)

SELECT
	s.release_year,
	s.season_released,
	gl.genre,
    gl.genre_id,
    COUNT(s.game_id) as num_releases
FROM genres_lookup gl
JOIN game_genres_bridge gb
ON gl.genre_id = gb.genre_id
JOIN seasons s ON
gb.game_id = s.game_id
JOIN genre_details gd
ON gb.genre_id = gd.genre_id
GROUP BY gl.genre, gl.genre_id, s.season_released, s.release_year
ORDER BY s.release_year, s.season_released;

    

