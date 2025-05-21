open Color
open Rectangle

module Brick : sig
    type t = {
        rectangle : Rectangle.t;
        fill_color : Color.t;
        border_color : Color.t;
    }

    val paint : Tsdl.Sdl.renderer -> t -> (unit, string) result
end
