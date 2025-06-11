module Game_state : sig
    type t =
        | Ready (* Game has just started *)
        | Paused (* Game is paused by the player *)
        | Running (* Game is running *)
        | ReportingKill (* Game is paused because the player was killed *)
        | Over (* Game is over *)

    val default : t

    val is_over : t -> bool
    val to_string : t -> string
end
