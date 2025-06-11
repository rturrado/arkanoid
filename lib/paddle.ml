open Canvas
open Color
open Graphics
open Rectangle
open Tsdl

module Paddle =  struct
    type direction_t =
        | Left
        | Right

    type t = {
        rectangle : Rectangle.t;
        vx : float
    }

    let default : t = {
        rectangle = {
            x = 0.0;
            y = 0.0;
            width = 80.0;
            height = 20.0;
        };
        vx = 10.0
    }

    let move (paddle : t) (direction : direction_t)
    : t =
        let new_x =
            match direction with
            | Left -> Float.max 0.0 (paddle.rectangle.x -. paddle.vx)
            | Right   -> Float.min (Canvas.window_width -. paddle.rectangle.width) (paddle.rectangle.x +. paddle.vx)
        in
        let new_rectangle = { paddle.rectangle with x = new_x } in
        { paddle with rectangle = new_rectangle }

    let paint (sdl_renderer : Sdl.renderer) (paddle : t)
    : (unit, string) result =
        Graphics.paint_rectangle sdl_renderer paddle.rectangle Color.grey
end
