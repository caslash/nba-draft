from nba_api.stats.endpoints import playerawards, playercareerstats, commonplayerinfo
from nba_api.stats.static import players
import json

def main():
    playerId = 1628443
    playerInfo = commonplayerinfo.CommonPlayerInfo(player_id=playerId).get_dict()
    playerAwards = playerawards.PlayerAwards(player_id=playerId).get_dict()
    playerStats = playercareerstats.PlayerCareerStats(per_mode36='PerGame', player_id=playerId).career_totals_regular_season.get_dict()
    player = { 
        "info": playerInfo,
        "awards": playerAwards,
        "stats": playerStats
    }
    with open(f'{playerId}.json', 'w') as f:
        f.write(json.dumps(player))

if __name__ == '__main__':
    main()