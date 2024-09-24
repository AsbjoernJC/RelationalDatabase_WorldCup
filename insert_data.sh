#! /bin/bash
CSV_FILE="games.csv"

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams;")
cat "$CSV_FILE" | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS; do
    if [[ $YEAR == "year" ]]; then
      continue
    else
      echo "$YEAR | $ROUND | $WINNER | $OPPONENT | $WINNER_GOALS | $OPPONENT_GOALS"
      
      #Insert teams
      echo $($PSQL "Insert INTO teams(name) VALUES('$WINNER')")
      echo $($PSQL "Insert INTO teams(name) VALUES('$OPPONENT')")

      #Get team_id
      WINNER_ID=$($PSQL "Select team_id FROM teams WHERE name='$WINNER'")
      OPPONENT_ID=$($PSQL "Select team_id FROM teams WHERE name='$OPPONENT'")


      #INSERT GAME
      echo $($PSQL "Insert INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
                    VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    fi
  echo "------------------------------------------"
done
echo -e "\Teams"
echo $($PSQL "SELECT * FROM teams")
echo -e "\nGames"
echo $($PSQL "SELECT * FROM games")