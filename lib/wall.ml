open Color
open Rectangle
open Tsdl

module Wall = struct
    type t = Brick.t list

    let default : Brick.t list = []

    let paint sdl_renderer wall : unit =
        List.iter (fun brick -> paint_brick sdl_renderer brick) wall
end
