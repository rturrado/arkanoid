open Color
open Rectangle
open Tsdl

let (>>=) = Result.bind

module Message_box = struct
    let paint (sdl_renderer : Sdl.renderer) (_ : string)
    : (unit, string) result =
        let background_box : Rectangle.t = { x = 150.0; y = 100.0; width = 340.0; height = 280.0 } in
        let foreground_box : Rectangle.t = { x = 160.0; y = 110.0; width = 320.0; height = 260.0 } in
        Rectangle.paint sdl_renderer background_box Color.black_3 >>= fun () ->
            Rectangle.paint sdl_renderer foreground_box Color.black_2
end
