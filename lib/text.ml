open Color
open Font
open Rectangle
open Tsdl
open Tsdl_ttf

let (>>=) = Result.bind

module Text = struct
    type texture_t = {
        data : Sdl.texture;
        width : float;
        height : float;
    }

    type textures_t = texture_t list

    let line_spacing_ratio : float = 0.5
    let line_with_spacing_ratio : float = 1.5

    let init ()
    : (unit, string) result =
        match Ttf.init () with
        | Error (`Msg err) -> Error ("Ttf.init error: " ^ err)
        | Ok () -> Ok ()

    let quit ()
    : unit =
        Ttf.quit ()

    let open_font (font : Font.t)
    : (Ttf.font, string) result =
        match Ttf.open_font font.path font.size with
        | Error (`Msg err) -> Error ("Ttf.open_font error: " ^ err)
        | Ok sdl_font -> Ok sdl_font

    let close_font (font : Ttf.font)
    : unit =
        Ttf.close_font font

    let destroy_surface (surface : Sdl.surface)
    : unit =
        Sdl.free_surface surface

    let destroy_texture (texture : texture_t)
    : unit =
        Sdl.destroy_texture texture.data

    let with_font (font : Ttf.font) (f : Ttf.font -> ('a, string) result)
    : ('a, string) result =
        let result = f font in
        close_font font;
        result

    let with_surface (surface : Sdl.surface) (f : Sdl.surface -> ('a, string) result)
    : ('a, string) result =
        let result = f surface in
        destroy_surface surface;
        result

    let with_textures (textures : textures_t) (f : textures_t -> ('a, string) result)
    : ('a, string) result =
        let result = f textures in
        List.iter (fun t -> destroy_texture t) textures;
        result

    let render_text_solid (ttf_font : Ttf.font) (text : string) (color : Color.t)
    : (Sdl.surface, string) result =
        let sdl_color = Sdl.Color.create ~r:color.red ~g:color.green ~b:color.blue ~a:color.alpha in
        match Ttf.render_text_solid ttf_font text sdl_color with
        | Error (`Msg err) -> Error ("Ttf.render_text_solid error: " ^ err)
        | Ok sdl_surface -> Ok sdl_surface

    let create_texture_from_surface (sdl_renderer : Sdl.renderer) (sdl_surface : Sdl.surface)
    : (texture_t, string) result =
        match Sdl.create_texture_from_surface sdl_renderer sdl_surface with
        | Error (`Msg err) -> Error ("Sdl.create_texture_from_surface error: " ^ err)
        | Ok sdl_texture ->
            let (width, height) = Sdl.get_surface_size sdl_surface in
            let texture = { data = sdl_texture; width = (float_of_int width); height = (float_of_int height) } in
            Ok texture

    let render_copy (sdl_renderer : Sdl.renderer) (sdl_texture : Sdl.texture) (dst : Sdl.rect)
    : (unit, string) result =
        match Sdl.render_copy sdl_renderer sdl_texture ~dst:dst with
        | Error (`Msg err) -> Error ("Sdl.render_copy error: " ^ err)
        | Ok () -> Ok ()

    let rec generate_textures (sdl_renderer : Sdl.renderer) (lines : string list) (ttf_font : Ttf.font) (color : Color.t)
    : (textures_t, string) result =
        match lines with
        | [] -> Ok []
        | first_line :: rest_lines ->
            render_text_solid ttf_font first_line color >>= fun sdl_surface ->
                with_surface sdl_surface (fun sdl_surface ->
                    create_texture_from_surface sdl_renderer sdl_surface >>= fun texture ->
                        match generate_textures sdl_renderer rest_lines ttf_font color with
                        | Error err -> destroy_texture texture; Error err
                        | Ok textures -> Ok (texture :: textures)
                )

    let get_textures_width (textures : texture_t list)
    : float =
        match textures with
        | [] -> 0.0
        | first :: rest ->
            let textures_max_width = List.fold_left
                (fun acc t -> if t.width > acc then t.width else acc)
                first.width
                rest
            in
            textures_max_width

    let get_textures_height (textures : texture_t list)
    : float =
        match textures with
        | [] -> 0.0
        | first :: _ ->
            let first_with_spacing_height = first.height *. line_with_spacing_ratio in
            let spacing_height = first.height *. line_spacing_ratio in
            (float_of_int (List.length textures)) *. first_with_spacing_height -. spacing_height

    let get_textures_size (textures : texture_t list)
    : float * float =
        let textures_width = get_textures_width textures in
        let textures_height = get_textures_height textures in
        (textures_width, textures_height)

    let render_texture (sdl_renderer : Sdl.renderer) (texture : texture_t) (dst : Rectangle.t)
    : (unit, string) result =
        let sdl_texture = texture.data in
        let sdl_rect = Sdl.Rect.create
            ~x:(int_of_float dst.x)
            ~y:(int_of_float dst.y)
            ~w:(int_of_float dst.width)
            ~h:(int_of_float dst.height)
        in
        render_copy sdl_renderer sdl_texture sdl_rect

    let rec render_textures (sdl_renderer : Sdl.renderer) (textures : textures_t) (dst : Rectangle.t)
    : (unit, string) result =
        match textures with
        | [] -> Ok ()
        | first_texture :: rest_textures ->
            let first_dst = { dst with height = first_texture.height } in
            match render_texture sdl_renderer first_texture first_dst with
            | Error err -> Error err
            | Ok () ->
                let first_texture_with_spacing_height = first_texture.height *. line_with_spacing_ratio in
                let rest_textures_dst = { dst with
                    y = dst.y +. first_texture_with_spacing_height;
                    height = dst.height -. first_texture_with_spacing_height
                } in
                render_textures sdl_renderer rest_textures rest_textures_dst

    let calculate_textures_bounding_box (textures : textures_t) (dst : Rectangle.t)
    : (Rectangle.t, string) result =
        let (textures_width, textures_height) = get_textures_size textures in
        if textures_width > dst.width || textures_height > dst.height then
            Error "Text.paint error: texture area exceeds destination area"
        else
            Ok {
                x = dst.x +. ((dst.width -. textures_width) /. 2.0);
                y = dst.y +. ((dst.height -. textures_height) /. 2.0);
                width = textures_width;
                height = textures_height;
            }

    let paint (sdl_renderer : Sdl.renderer) (text : string) (font : Font.t) (color : Color.t) (dst : Rectangle.t)
    : (unit, string) result =
        open_font font >>= fun ttf_font ->
            with_font ttf_font (fun ttf_font ->
                let lines = String.split_on_char '\n' text in
                generate_textures sdl_renderer lines ttf_font color >>= fun textures ->
                    with_textures textures (fun textures ->
                        calculate_textures_bounding_box textures dst >>= fun bounding_box ->
                            render_textures sdl_renderer textures bounding_box
                    )
            )
end
