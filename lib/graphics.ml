open Color
open Maths
open Rectangle
open Tsdl

let (>>=) = Result.bind

module Graphics = struct
    type t = Sdl.renderer

    type texture_t = {
        data : Sdl.texture;
        width : float;
        height : float;
    }

    type textures_t = texture_t list

    let init ()
    : (unit, string) result =
        match Sdl.init Sdl.Init.(video + events) with
        | Error (`Msg err) -> Error ("Sdl.Init error: " ^ err)
        | Ok () -> Ok ()

    let quit ()
    : unit =
        Sdl.quit ()

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

    let create_texture_from_surface (sdl_renderer : Sdl.renderer) (sdl_surface : Sdl.surface)
    : (texture_t, string) result =
        match Sdl.create_texture_from_surface sdl_renderer sdl_surface with
        | Error (`Msg err) -> Error ("Sdl.create_texture_from_surface error: " ^ err)
        | Ok sdl_texture ->
            let (width, height) = Sdl.get_surface_size sdl_surface in
            let texture = { data = sdl_texture; width = (float_of_int width); height = (float_of_int height) } in
            Ok texture

    let create_rectangle (rectangle : Rectangle.t)
    : Sdl.rect =
        let x = Maths.int_of_float rectangle.x in
        let y = Maths.int_of_float rectangle.y in
        let w = Maths.int_of_float rectangle.width in
        let h = Maths.int_of_float rectangle.height in
        Sdl.Rect.create ~x:x ~y:y ~w:w ~h:h

    let destroy_window (window : Sdl.window)
    : unit =
        Sdl.destroy_window window

    let destroy_renderer (sdl_renderer : Sdl.renderer)
    : unit =
        Sdl.destroy_renderer sdl_renderer

    let free_surface (surface : Sdl.surface)
    : unit =
        Sdl.free_surface surface

    let destroy_texture (texture : texture_t)
    : unit =
        Sdl.destroy_texture texture.data

    let with_surface (surface : Sdl.surface) (f : Sdl.surface -> ('a, string) result)
    : ('a, string) result =
        let result = f surface in
        free_surface surface;
        result

    let with_texture (texture : texture_t) (f : texture_t -> ('a, string) result)
    : ('a, string) result =
        let result = f texture in
        destroy_texture texture;
        result

    let with_textures (textures : textures_t) (f : textures_t -> ('a, string) result)
    : ('a, string) result =
        let result = f textures in
        List.iter (fun t -> destroy_texture t) textures;
        result

    let set_render_draw_color (sdl_renderer : Sdl.renderer) (color : Color.t)
    : (unit, string) result =
        match Sdl.set_render_draw_color sdl_renderer color.red color.green color.blue color.alpha with
        | Error (`Msg err) -> Error ("Sdl.set_render_draw_color error: " ^ err)
        | Ok () -> Ok ()

    let render_clear (sdl_renderer : Sdl.renderer)
    : (unit, string) result =
        set_render_draw_color sdl_renderer Color.black >>= fun () ->
            match Sdl.render_clear sdl_renderer with
            | Error (`Msg  err) -> Error err
            | Ok () -> Ok ()

    let render_copy (sdl_renderer : Sdl.renderer) (texture : texture_t) (dst : Rectangle.t)
    : (unit, string) result =
        let sdl_texture = texture.data in
        let sdl_rect = create_rectangle dst in
        match Sdl.render_copy sdl_renderer sdl_texture ~dst:sdl_rect with
        | Error (`Msg err) -> Error ("Sdl.render_copy error: " ^ err)
        | Ok () -> Ok ()

    let render_draw_rect (sdl_renderer : Sdl.renderer) (rectangle : Rectangle.t)
    : (unit, string) result =
        let sdl_rectangle = create_rectangle rectangle in
        match Sdl.render_draw_rect sdl_renderer (Some sdl_rectangle) with
        | Error (`Msg err) -> Error ("Sdl.set_render_draw_color error: " ^ err)
        | Ok () -> Ok ()

    let render_fill_rect (sdl_renderer : Sdl.renderer) (rectangle : Rectangle.t)
    : (unit, string) result =
        let sdl_rectangle = create_rectangle rectangle in
        match Sdl.render_fill_rect sdl_renderer (Some sdl_rectangle) with
        | Error (`Msg err) -> Error ("Sdl.set_render_fill_color error: " ^ err)
        | Ok () -> Ok ()

    let render_present (sdl_renderer : Sdl.renderer)
    : unit =
        Sdl.render_present sdl_renderer

    let paint_rectangle (sdl_renderer : Sdl.renderer) (rectangle : Rectangle.t) (color : Color.t)
    : (unit, string) result =
        set_render_draw_color sdl_renderer color >>= fun () ->
            render_fill_rect sdl_renderer rectangle

    let paint_rectangle_border (sdl_renderer : Sdl.renderer) (rectangle : Rectangle.t) (color : Color.t)
    : (unit, string) result =
        set_render_draw_color sdl_renderer color >>= fun () ->
            render_draw_rect sdl_renderer rectangle

    let delay (milliseconds : int32)
    : unit =
        Sdl.delay milliseconds
end
