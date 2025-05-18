open Color
open Rectangle

module Brick : sig
    type t = {
        rectangle : Rectangle.t;
        color : Color.t;
    }

    val paint (Tsdl.Sdl.renderer, Brick.t) -> unit
end
