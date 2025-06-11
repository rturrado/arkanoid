open Color
open Graphics
open Rectangle
open Tsdl

module Ball = struct
    type t = {
        rectangle : Rectangle.t;
        vx : float;
        vy : float;
    }

    let default : t = {
        rectangle = {
            x = 0.0;
            y = 0.0;
            width = 20.0;
            height = 20.0;
        };
        vx = 2.8;
        vy = 2.8
    }

    let get_center (ball : t)
    : float * float =
        Rectangle.get_center ball.rectangle

    let move (ball : t) (time : float)
    : t =
        let delta_x = ball.vx *. time in
        let delta_y = ball.vy *. time *. -1.0 in
        let new_x = ball.rectangle.x +. delta_x in
        let new_y = ball.rectangle.y +. delta_y in
        let new_rectangle = { ball.rectangle with x = new_x; y = new_y } in
        { ball with rectangle = new_rectangle }

    let paint (sdl_renderer : Sdl.renderer) (ball : t)
    : (unit, string) result =
        Graphics.paint_rectangle sdl_renderer ball.rectangle Color.yellow
end
