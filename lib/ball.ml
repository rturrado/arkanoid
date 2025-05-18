open Color
open Rectangle
open Tsdl

module Ball = struct
    type t = Rectangle.t

    let default : Rectangle.t = { x = 0; y = 0; w = 20; h = 20; }

    let paint sdl_renderer ball : unit =
        paint_rectangle sdl_renderer ball Color.yellow
end
