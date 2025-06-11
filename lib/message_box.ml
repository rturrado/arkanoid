open Color
open Font
open Rectangle
open Text
open Tsdl

let (>>=) = Result.bind

module Message_box = struct
    let paint (sdl_renderer : Sdl.renderer) (message : string) (font : Font.t)
    : (unit, string) result =
        let background_box : Rectangle.t = { x = 50.0; y = 100.0; width = 540.0; height = 280.0 } in
        let foreground_box : Rectangle.t = { x = 60.0; y = 110.0; width = 520.0; height = 260.0 } in
        let text_box : Rectangle.t = { x = 70.0; y = 120.0; width = 500.0; height = 240.0 } in
        Rectangle.paint sdl_renderer background_box Color.black_3 >>= fun () ->
            Rectangle.paint sdl_renderer foreground_box Color.black_2 >>= fun () ->
                Text.paint sdl_renderer message font Color.grey_1 text_box
end
