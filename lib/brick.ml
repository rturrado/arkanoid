open Color
open Rectangle

let (>>=) = Result.bind

module Brick = struct
    type t = {
        rectangle : Rectangle.t;
        fill_color : Color.t;
        border_color : Color.t;
    }

    let paint sdl_renderer brick : (unit, string) result =
        Rectangle.paint sdl_renderer brick.rectangle brick.fill_color >>= fun () ->
            Rectangle.paint_border sdl_renderer brick.rectangle brick.border_color
end
