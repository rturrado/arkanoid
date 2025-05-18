module GameState : sig
    type t
        | Ready (* Game has just started *)
        | Paused (* Game is paused by the player *)
        | Running (* Game is running *)
        | ReportingKill (* Game is paused because the player was killed *)
        | Over (* Game is over *)

    val default : t

    val to_string : t -> string
end
