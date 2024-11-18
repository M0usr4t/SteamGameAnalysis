import os
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.exc import IntegrityError
import pandas as pd

load_dotenv()
USER = os.getenv("USER")
PW = os.getenv("PW")
DB_NAME = os.getenv("DB_NAME")

engine = create_engine(f"mysql+pymysql://{USER}:{PW}@localhost/{DB_NAME}")

game_metrics_df = pd.read_csv("data/game_metrics.csv") 
developers_lookup_df = pd.read_csv("data/developers_lookup.csv")
game_developers_bridge_df = pd.read_csv("data/game_developers_bridge.csv")
publishers_lookup_df = pd.read_csv("data/publishers_lookup.csv")
game_publishers_bridge_df = pd.read_csv("data/game_publishers_bridge.csv")
genres_lookup_df = pd.read_csv("data/genres_lookup.csv")
game_genres_bridge_df = pd.read_csv("data/game_genres_bridge.csv")
platforms_lookup_df = pd.read_csv("data/platforms_lookup.csv")
game_platforms_bridge_df = pd.read_csv("data/game_platforms_bridge.csv")


game_metrics_df.to_sql('game_metrics', con=engine, if_exists='append', index=False)
developers_lookup_df.to_sql('developers_lookup', con=engine, if_exists='append', index=False)
game_developers_bridge_df.to_sql('game_developers_bridge', con=engine, if_exists='append', index=False)
publishers_lookup_df.to_sql('publishers_lookup', con=engine, if_exists='append', index=False)
game_publishers_bridge_df.to_sql('game_publishers_bridge', con=engine, if_exists='append', index=False)
genres_lookup_df.to_sql('genres_lookup', con=engine, if_exists='append', index=False)
game_genres_bridge_df.to_sql('game_genres_bridge', con=engine, if_exists='append', index=False)
platforms_lookup_df.to_sql('platforms_lookup', con=engine, if_exists='append', index=False)
game_platforms_bridge_df.to_sql('game_platforms_bridge', con=engine, if_exists='append', index=False)


