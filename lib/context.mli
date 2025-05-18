module Context : sig
    type t = {
        game_state : GameState.t;
        level_state : LevelState.t;
        player_state : PlayerState.t;
    }

    val default : t

    val get_notification_message : GameState.t PlayerState.t -> string
end
