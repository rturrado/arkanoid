import Color

module Rectangle : sig
    type t = Tsdl.Sdl.Rect

    val paint_rectangle : (Tsdl.Sdl.renderer, Color) -> unit
end
