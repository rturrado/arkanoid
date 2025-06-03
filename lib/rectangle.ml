open Color
open Maths
open Tsdl

module Rectangle = struct
    type t = {
        x : float;
        y : float;
        width : float;
        height : float
    }

    let default : t = {
        x = 0.0;
        y = 0.0;
        width = 1.0;
        height = 1.0
    }

    let get_center (rectangle : t)
    : float * float =
        (
            rectangle.x +. rectangle.width /. 2.0,
            rectangle.y +. rectangle.height /. 2.0
        )

    let paint (sdl_renderer : Sdl.renderer) (rectangle : t) (color : Color.t)
    : (unit, string) result =
        let red = color.Color.red in
        let green = color.Color.green in
        let blue = color.Color.blue in
        let alpha = color.Color.alpha in
        match Sdl.set_render_draw_color sdl_renderer red green blue alpha with
        | Error (`Msg err) -> Sdl.log "Rectangle.paint: set render draw color error: %s" err; Error err
        | Ok () ->
            let x = Maths.int_of_float rectangle.x in
            let y = Maths.int_of_float rectangle.y in
            let width = Maths.int_of_float rectangle.width in
            let height = Maths.int_of_float rectangle.height in
            let sdl_rectangle = Sdl.Rect.create ~x:x ~y:y ~w:width ~h:height in
            match Sdl.render_fill_rect sdl_renderer (Some sdl_rectangle) with
            | Error (`Msg  err) -> Error err
            | Ok () -> Ok ()

    let paint_border (sdl_renderer : Sdl.renderer) (rectangle : t) (color : Color.t)
    : (unit, string) result =
        let red = color.Color.red in
        let green = color.Color.green in
        let blue = color.Color.blue in
        let alpha = color.Color.alpha in
        match Sdl.set_render_draw_color sdl_renderer red green blue alpha with
        | Error (`Msg err) -> Sdl.log "Rectangle.paint_border: set render draw color error: %s" err; Error err
        | Ok () ->
            let x = Maths.int_of_float rectangle.x in
            let y = Maths.int_of_float rectangle.y in
            let width = Maths.int_of_float rectangle.width in
            let height = Maths.int_of_float rectangle.height in
            let sdl_rectangle = Sdl.Rect.create ~x:x ~y:y ~w:width ~h:height in
            match Sdl.render_draw_rect sdl_renderer (Some sdl_rectangle) with
            | Error (`Msg  err) -> Error err
            | Ok () -> Ok ()
end
