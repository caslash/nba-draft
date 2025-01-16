from flask import Flask, request
from nba_api.stats.endpoints import playerprofilev2

app = Flask(__name__)

@app.route("/<player_id>/teams")
def player_teams(player_id):
    stats_df = playerprofilev2.PlayerProfileV2(per_mode36='PerGame', player_id=player_id).season_totals_regular_season.get_data_frame()
    filtered_df = stats_df[stats_df['TEAM_ID'] != 0]
    unique_team_ids = filtered_df['TEAM_ID'].loc[filtered_df['TEAM_ID'].shift() != filtered_df['TEAM_ID']].astype(str).tolist()
    return { "player_id": player_id, "player_team_history": unique_team_ids }