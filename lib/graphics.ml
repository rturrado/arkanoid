open Color
open Tsdl

module Graphics = struct
    type t = {
        sdl_renderer : Sdl.renderer
    }

    let init ()
    : (unit, string) result =
        match Sdl.init Sdl.Init.(video + events) with
        | Error (`Msg err) -> Error ("Sdl.Init error: " ^ err)
        | Ok () -> Ok ()

    let create_window (width : int) (height : int) (title : string)
    : (Sdl.window, string) result =
        match Sdl.create_window ~w:width ~h:height title Sdl.Window.opengl with
        | Error (`Msg err) -> Error ("Sdl.create_window error: " ^ err)
        | Ok sdl_window -> Ok sdl_window

    let create_renderer (sdl_window : Sdl.window)
    : (Sdl.renderer, string) result =
        match Sdl.create_renderer sdl_window ~flags:Sdl.Renderer.accelerated with
        | Error (`Msg err) -> Error ("Sdl.create_renderer error: " ^ err)
        | Ok sdl_renderer -> Ok sdl_renderer

    let clear (sdl_renderer : Sdl.renderer)
    : (unit, string) result =
        let red = Color.black.red in
        let green = Color.black.green in
        let blue = Color.black.blue in
        let alpha = Color.black.alpha in
        match Sdl.set_render_draw_color sdl_renderer red green blue alpha with
        | Error (`Msg err) -> Error ("Graphics.clear: set render draw color error: " ^ err)
        | Ok () ->
            match Sdl.render_clear sdl_renderer with
            | Error (`Msg  err) -> Error err
            | Ok () -> Ok ()

    let render (sdl_renderer : Sdl.renderer)
    : unit =
        Sdl.render_present sdl_renderer

    let delay (milliseconds : int32)
    : unit =
        Sdl.delay milliseconds
end
