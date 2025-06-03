open Color
open Rectangle

module Brick : sig
    type id = int

    type t = {
        id : int;
        rectangle : Rectangle.t;
        fill_color : Color.t;
        border_color : Color.t;
        hardness : int;
    }

    val compare : t -> t -> int
    val paint : Tsdl.Sdl.renderer -> t -> (unit, string) result
end
