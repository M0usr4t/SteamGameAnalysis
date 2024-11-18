drop table game_developers_bridge;
drop table developers_lookup;
drop table game_publishers_bridge;
drop table publishers_lookup;
drop table game_genres_bridge;
drop table genres_lookup;
drop table game_platforms_bridge;
drop table platforms_lookup;
drop table game_metrics;

create table game_metrics (
	game_id INT primary key NOT NULL,
    name CHAR(255) NOT NULL,
    initial_price DECIMAL(10, 2),
    current_price DECIMAL(10, 2),
    positive_user_score INT,
    negative_user_score INT,
    metacritic_score FLOAT,
    ccu INT,
    owners_min INT,
    owners_max INT,
    release_date DATE
);

create table developers_lookup (
	developer_id INT PRIMARY KEY,
    developer CHAR(255)
);

create table game_developers_bridge (
	game_id INT,
    developer_id INT,
    PRIMARY KEY(game_id, developer_id),
    FOREIGN KEY (game_id) REFERENCES game_metrics(game_id),
    FOREIGN KEY (developer_id) REFERENCES developers_lookup(developer_id),
	INDEX idx_game_id (game_id),
    INDEX idx_developer_id (developer_id) 
);

create table publishers_lookup (
	publisher_id INT PRIMARY KEY,
    publisher CHAR(255)
);

create table game_publishers_bridge (
	game_id INT,
    publisher_id INT,
    PRIMARY KEY(game_id, publisher_id),
    FOREIGN KEY (game_id) REFERENCES game_metrics(game_id),
    FOREIGN KEY (publisher_id) REFERENCES publishers_lookup(publisher_id),
	INDEX idx_game_id (game_id),
    INDEX idx_developer_id (publisher_id) 
);

create table genres_lookup (
	genre_id INT PRIMARY KEY,
    genre CHAR(255)
);

create table game_genres_bridge (
	game_id INT,
    genre_id INT,
    PRIMARY KEY(game_id, genre_id),
    FOREIGN KEY (game_id) REFERENCES game_metrics(game_id),
    FOREIGN KEY (genre_id) REFERENCES genres_lookup(genre_id),
	INDEX idx_game_id (game_id),
    INDEX idx_developer_id (genre_id) 
);

create table platforms_lookup (
	platform_id INT PRIMARY KEY,
    platform CHAR(255)
);

create table game_platforms_bridge (
	game_id INT,
    platform_id INT,
    PRIMARY KEY(game_id, platform_id),
    FOREIGN KEY (game_id) REFERENCES game_metrics(game_id),
    FOREIGN KEY (platform_id) REFERENCES platforms_lookup(platform_id),
	INDEX idx_game_id (game_id),
    INDEX idx_developer_id (platform_id) 
);
