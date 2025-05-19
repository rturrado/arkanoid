open Color
open Rectangle

module Paddle =  struct
    type t = Rectangle.t

    let default : Rectangle.t = { x = 0; y = 0; width = 80; height = 20; }

    let paint sdl_renderer paddle : (unit, string) result =
        Rectangle.paint sdl_renderer paddle Color.grey
end
