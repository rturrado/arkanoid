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
        Sdl.set_render_draw_color sdl_renderer red green blue alpha;
        Sdl.render_clear sdl_renderer;
end
