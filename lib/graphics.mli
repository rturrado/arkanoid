module Graphics : sig
    type t = {
        sdl_renderer : Tsdl.Sdl.renderer
    }

    val init : unit -> (unit, string) result
    val create_window : int -> int ->  string -> (Tsdl.Sdl.window, string) result
    val create_renderer : Tsdl.Sdl.window -> (Tsdl.Sdl.renderer, string) result
    val clear : Tsdl.Sdl.renderer -> (unit, string) result
    val render : Tsdl.Sdl.renderer -> unit
    val delay : int32 -> unit
end
