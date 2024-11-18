# Developer and Publisher Views
SELECT * FROM developers_lookup;
SELECT * FROM publishers_lookup;
SELECT * FROM game_metrics;
SELECT * FROM game_developers_bridge;
SELECT * FROM game_publishers_bridge;
SELECT * FROM game_rating;


CREATE VIEW popular_dev_details AS
    SELECT 
        dl.developer,
        dl.developer_id,
        SUM(gm.ccu) AS total_ccu,
        ROUND(AVG((gm.owners_min + gm.owners_max) * 0.5),
                0) AS avg_ownership,
        SUM(gm.positive_user_score) + SUM(gm.negative_user_score) AS total_votes,
        COUNT(DISTINCT gm.game_id) AS total_games,
        ROUND(AVG(r.pct_pos), 2) AS avg_pos_user_rating,
        ROUND(AVG(r.pct_neg), 2) AS avg_neg_user_rating,
        CASE
            WHEN ROUND(AVG(gm.initial_price), 2) < 0.00 THEN 0.00
            ELSE ROUND(AVG(gm.initial_price), 2)
        END AS avg_initial_price,
        CASE
            WHEN ROUND(AVG(gm.current_price), 2) < 0.00 THEN 0.00
            ELSE ROUND(AVG(gm.current_price), 2)
        END AS avg_current_price,
        SUM(CASE
            WHEN gm.initial_price = 0 THEN 1
            ELSE 0
        END) AS ftp_count,
        SUM(CASE
            WHEN gm.initial_price > 0 THEN 1
            ELSE 0
        END) AS non_ftp_count
    FROM
        developers_lookup dl
            JOIN
        game_developers_bridge db ON dl.developer_id = db.developer_id
            JOIN
        game_metrics gm ON gm.game_id = db.game_id
            JOIN
        game_rating r ON gm.game_id = r.game_id
    GROUP BY dl.developer , dl.developer_id
    HAVING total_ccu > 5000
        AND avg_ownership > 10000
        AND total_votes > 10000;

CREATE VIEW popular_pub_details AS
    SELECT 
        pl.publisher,
        pl.publisher_id,
        SUM(gm.ccu) AS total_ccu,
        ROUND(AVG((gm.owners_min + gm.owners_max) * 0.5),
                0) AS avg_ownership,
        SUM(gm.positive_user_score) + SUM(gm.negative_user_score) AS total_votes,
        COUNT(DISTINCT gm.game_id) AS total_games,
        ROUND(AVG(r.pct_pos), 2) AS avg_pos_user_rating,
        ROUND(AVG(r.pct_neg), 2) AS avg_neg_user_rating,
        CASE
            WHEN ROUND(AVG(gm.initial_price), 2) < 0.00 THEN 0.00
            ELSE ROUND(AVG(gm.initial_price), 2)
        END AS avg_initial_price,
        CASE
            WHEN ROUND(AVG(gm.current_price), 2) < 0.00 THEN 0.00
            ELSE ROUND(AVG(gm.current_price), 2)
        END AS avg_current_price,
        SUM(CASE
            WHEN gm.initial_price = 0 THEN 1
            ELSE 0
        END) AS ftp_count,
        SUM(CASE
            WHEN gm.initial_price > 0 THEN 1
            ELSE 0
        END) AS non_ftp_count
    FROM
        publishers_lookup pl
            JOIN
        game_publishers_bridge pb ON pl.publisher_id = pb.publisher_id
            JOIN
        game_metrics gm ON gm.game_id = pb.game_id
            JOIN
        game_rating r ON gm.game_id = r.game_id
    GROUP BY pl.publisher , pl.publisher_id
    HAVING total_ccu > 5000
        AND avg_ownership > 10000
        AND total_votes > 10000;
        
# free to play vs non-free to play game counts
CREATE VIEW ftp_dev_counts AS
SELECT 
    dl.developer,
    SUM(CASE
        WHEN gm.initial_price = 0 THEN 1
        ELSE 0
    END) AS ftp_count,
    SUM(CASE
        WHEN gm.initial_price > 0 THEN 1
        ELSE 0
    END) AS non_ftp_count
FROM
    developers_lookup dl
        JOIN
    game_developers_bridge db ON dl.developer_id = db.developer_id
        JOIN
    game_metrics gm ON db.game_id = gm.game_id
GROUP BY dl.developer;

CREATE VIEW ftp_pub_counts AS
SELECT 
    pl.publisher,
    SUM(CASE
        WHEN gm.initial_price = 0 THEN 1
        ELSE 0
    END) AS ftp_count,
    SUM(CASE
        WHEN gm.initial_price > 0 THEN 1
        ELSE 0
    END) AS non_ftp_count
FROM
    publishers_lookup pl
        JOIN
    game_publishers_bridge pb ON pl.publisher_id = pb.publisher_id
        JOIN
    game_metrics gm ON pb.game_id = gm.game_id
GROUP BY pl.publisher;
    
    
