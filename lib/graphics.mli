module Graphics : sig
    type t = {
        sdl_renderer : Tsdl.Sdl.renderer;
    }

    val render : t -> unit

    val delay : int32 -> unit

    val clear : t -> (unit, string) result
end
