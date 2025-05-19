open Events
open Game_state
open Level_state
open Player_state

module Context : sig
    type t = {
        game_state : Game_state.t;
        level_state : Level_state.t;
        player_state : Player_state.t;
    }

    val default : t

    val get_notification_message : Game_state.t -> Player_state.t -> string

    val process_event_at_pause : t -> Events.event -> (t, string) result

    val process_event_at_playing : t -> Events.event -> (t, string) result

    val process_event_at_over : t -> Events.event -> (t, string) result

    val process_frame : t -> (t, string) result
end
