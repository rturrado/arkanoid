module Graphics = sig
    type t = {
        sdl_renderer : Tsdl.Sdl.renderer;
    }

    val render : Tsdl.Sdl.renderer -> (Context.t, string) result

    val delay : int -> unit

    val clear : Tsdl.Sdl.renderer -> (unit, string) result
end
