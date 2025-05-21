open Color
open Tsdl

module Rectangle = struct
    type t = {
        x : int;
        y : int;
        width : int;
        height : int;
    }

    let paint sdl_renderer rectangle color : (unit, string) result =
        let red = color.Color.red in
        let green = color.Color.green in
        let blue = color.Color.blue in
        let alpha = color.Color.alpha in
        match Sdl.set_render_draw_color sdl_renderer red green blue alpha with
        | Error (`Msg err) -> Sdl.log "Rectangle.paint: set render draw color error: %s" err; Error err
        | Ok () ->
            let x = rectangle.x in
            let y = rectangle.y in
            let width = rectangle.width in
            let height = rectangle.height in
            let sdl_rectangle = Sdl.Rect.create ~x:x ~y:y ~w:width ~h:height in
            match Sdl.render_fill_rect sdl_renderer (Some sdl_rectangle) with
            | Error (`Msg  err) -> Error err
            | Ok () -> Ok ()

    let paint_border sdl_renderer rectangle color =
        let red = color.Color.red in
        let green = color.Color.green in
        let blue = color.Color.blue in
        let alpha = color.Color.alpha in
        match Sdl.set_render_draw_color sdl_renderer red green blue alpha with
        | Error (`Msg err) -> Sdl.log "Rectangle.paint_border: set render draw color error: %s" err; Error err
        | Ok () ->
            let x = rectangle.x in
            let y = rectangle.y in
            let width = rectangle.width in
            let height = rectangle.height in
            let sdl_rectangle = Sdl.Rect.create ~x:x ~y:y ~w:width ~h:height in
            match Sdl.render_draw_rect sdl_renderer (Some sdl_rectangle) with
            | Error (`Msg  err) -> Error err
            | Ok () -> Ok ()
end
