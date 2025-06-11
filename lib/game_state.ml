module Game_state = struct
    type t =
        | Ready (* Game has just started *)
        | Paused (* Game is paused by the player *)
        | Running (* Game is playing *)
        | ReportingKill (* Game is paused because the player was killed *)
        | Over (* Game is over *)

    let default : t = Ready

    let to_string game_state =
        match game_state with
        | Ready -> "Ready"
        | Paused -> "Paused"
        | Running -> "Playing"
        | ReportingKill -> "ReportingKill"
        | Over -> "Over"
end
