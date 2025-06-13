open Events
open Game_state
open Level_state
open Player_state

module Context : sig
    type t = {
        game_state : Game_state.t;
        level_state : Level_state.t;
        player_state : Player_state.t
    }

    val default : t

    val process_event_at_pause : t -> Events.event -> (t, string) result
    val process_event_at_running : t -> Events.event -> (t, string) result
    val process_event_at_over : t -> Events.event -> (t, string) result
    val process_frame : t -> t
    val paint : Tsdl.Sdl.renderer -> t -> (unit, string) result
end
