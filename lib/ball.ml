open Color
open Rectangle

module Ball = struct
    type t = Rectangle.t

    let default : Rectangle.t = { x = 0; y = 0; width = 20; height = 20; }

    let paint sdl_renderer ball : (unit, string) result =
        Rectangle.paint sdl_renderer ball Color.yellow
end
