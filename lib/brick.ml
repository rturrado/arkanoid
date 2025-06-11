open Color
open Graphics
open Rectangle
open Tsdl

let (>>=) = Result.bind

module Brick = struct
    type id = int

    type t = {
        id : id;
        rectangle : Rectangle.t;
        fill_color : Color.t;
        border_color : Color.t;
        hardness : int;
    }

    let compare (brick_1 : t) (brick_2 : t)
    : int =
        Int.compare brick_1.id brick_2.id

    let paint (sdl_renderer : Sdl.renderer) (brick : t)
    : (unit, string) result =
        Graphics.paint_rectangle sdl_renderer brick.rectangle brick.fill_color >>= fun () ->
            Graphics.paint_rectangle_border sdl_renderer brick.rectangle brick.border_color
end
