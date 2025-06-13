module Game_state : sig
    type t =
        | Ready (* Game has just started *)
        | Paused (* Game has been paused *)
        | Running (* Game is running *)
        | PlayerCompletedLevel (* Player completed a level *)
        | PlayerKilled (* Player has been killed *)
        | Over (* Game is over *)

    val default : t

    val is_over : t -> bool
    val to_string : t -> string
end
