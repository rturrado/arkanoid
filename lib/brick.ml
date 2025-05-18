open Color
open Rectangle

module Brick = struct
    type t = {
        rectangle : Rectangle.t;
        color : Color.t;
    }

    let paint sdl_renderer brick =
        paint_rectangle sdl_renderer brick.rectangle brick.color
end
