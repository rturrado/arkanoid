open Game_state
open Level_state
open Player_state

module Context = struct
    type t = {
        game_state : Game_state.t;
        level_state : Level_state.t;
        player_state : Player_state.t;
    }

    let default : t = {
        game_state = Game_state.default;
        level_state = Level_state.default;
        player_state = Player_state.default
    }

    let get_notification_message game_state player_state =
        match game_state with
        | Game_state.Ready -> "Use < and > to move the paddle. You have 3 lives! Press any key to start the game..."
        | Game_state.Paused -> "Press any key to resume the game..."
        | Game_state.Running -> "Running"
        | Game_state.ReportingKill ->
            let number_of_lives = player_state.Player_state.number_of_lives in
            [%string "Oh no! They've kill you! You have now %d$number_of_lives lives! Press any key to resume the game..."]
        | Over -> "Game over! Press Y to start a new game or N to exit..."

    let process_event_at_pause context event =
        match event with
        | Some `Quit -> Ok context
        | _ -> Ok context

    let process_event_at_playing context event =
        match event with
        | Some `Quit -> Ok context
        | _ -> Ok context

    let process_event_at_over context event =
        match event with
        | Some `Quit -> Ok context
        | _ -> Ok context

    let process_frame context =
        Ok context
end
