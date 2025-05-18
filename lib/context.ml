open GameState
open LevelState
open PlayerState

module Context = struct
    type t = {
        game_state : GameState.t;
        level_state : LevelState.t;
        player_state : PlayerState.t;
    }

    let default : t = {
        game_state = GameState.default;
        level_state = LevelState.default;
        player_state = PlayerState.default
    }

    let get_notification_message game_state player_state =
        match game_state with
        | Ready -> "Use < and > to move the paddle. You have 3 lives! Press any key to start the game..."
        | Paused -> "Press any key to resume the game..."
        | Playing -> "Playing"
        | ReportingKill ->
            let number_of_lives = player_state.PlayerState.number_of_lives;
            [%string "Oh no! They've kill you! You have now ${number_of_lives} lives! Press any key to resume the game..."]
        | Over -> "Game over! Press Y to start a new game or N to exit..."
end
