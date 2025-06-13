module Game_state = struct
    type t =
        | Ready (* Game has just started *)
        | Paused (* Game has been paused *)
        | Running (* Game is running *)
        | PlayerCompletedLevel (* Player completed a level *)
        | PlayerKilled (* Player has been killed *)
        | Over (* Game is over *)

    let default : t = Ready

    let is_over (game_state : t)
    : bool =
        game_state = Over

    let to_string (game_state : t)
    : string =
        match game_state with
        | Ready -> "Ready"
        | Paused -> "Paused"
        | Running -> "Playing"
        | PlayerCompletedLevel -> "PlayerCompletedLevel"
        | PlayerKilled -> "PlayerKilled"
        | Over -> "Over"
end
