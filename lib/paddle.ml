open Color
open Rectangle
open Tsdl

module Paddle =  struct
    type t = Rectangle.t

    let default : Rectangle.t = { x = 0; y = 0; w = 80; h = 20; }

    let paint sdl_renderer paddle : unit =
        paint_rectangle sdl_renderer paddle Color.grey
end
