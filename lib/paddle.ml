open Canvas
open Color
open Rectangle

module Paddle =  struct
    type t = {
        rectangle : Rectangle.t;
        speed : int;
    }

    type direction = Left | Right

    let default : t = { rectangle = { x = 0; y = 0; width = 80; height = 20; }; speed = 10 }

    let move paddle direction =
        let new_x =
            match direction with
            | Left -> max 0 (paddle.rectangle.x - paddle.speed)
            | Right   -> min (Canvas.window_width - paddle.rectangle.width) (paddle.rectangle.x + paddle.speed)
        in
        let new_rectangle = { paddle.rectangle with x = new_x } in
        { paddle with rectangle = new_rectangle }

    let paint sdl_renderer paddle : (unit, string) result =
        Rectangle.paint sdl_renderer paddle.rectangle Color.grey
end
