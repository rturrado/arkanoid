open Color
open Tsdl

module Graphics = struct
    type t = {
        sdl_renderer : Tsdl.Sdl.renderer;
    }

    let render sdl_renderer : unit =
        Sdl.render_present sdl_renderer

    let delay milliseconds : unit =
        Sdl.delay milliseconds

    let clear sdl_renderer : (unit, string) result =
        let red = Color.black.red in
        let green = Color.black.green in
        let blue = Color.black.blue in
        let alpha = Color.black.alpha in
        match Sdl.set_render_draw_color sdl_renderer red green blue alpha with
        | Error (`Msg err) -> Sdl.log "Graphics.clear: set render draw color error: %s" err; Error err
        | Ok () ->
            match Sdl.render_clear sdl_renderer with
            | Error (`Msg  err) -> Error err
            | Ok () -> Ok ()
end
