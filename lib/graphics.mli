module Graphics : sig
    type t = {
        sdl_renderer : Tsdl.Sdl.renderer;
    }

    val render : Tsdl.Sdl.renderer -> unit

    val delay : int32 -> unit

    val clear : Tsdl.Sdl.renderer -> (unit, string) result
end
