open Color
open Graphics
open Image
open Rectangle
open Tsdl

let (>>=) = Result.bind

module Intro = struct
    let intro_640_480 : Image.t = {
        path = Filename.concat "./res" "intro.jpg";
        width = 640.0;
        height = 480.0;
    }

    let paint (sdl_renderer : Sdl.renderer)
    : (unit, string) result =
        let image = intro_640_480 in
        Image.load image.path >>= fun sdl_surface ->
            Graphics.with_surface sdl_surface (fun sdl_surface ->
                Graphics.create_texture_from_surface sdl_renderer sdl_surface >>= fun texture ->
                    Graphics.with_texture texture (fun texture ->
                        Graphics.set_render_draw_color sdl_renderer Color.black >>= fun () ->
                            Graphics.render_clear sdl_renderer >>= fun () ->
                                let dst : Rectangle.t = { x = 0.0; y = 0.0; width = image.width; height = image.height } in
                                Graphics.render_copy sdl_renderer texture dst >>= fun () ->
                                    Graphics.render_present sdl_renderer;
                                    Graphics.delay 3000l;
                                    Graphics.destroy_texture texture;
                                    Graphics.free_surface sdl_surface;
                                    Ok ()
                    )
            )
end
