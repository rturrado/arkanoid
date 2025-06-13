open Color
open Font
open Graphics
open Rectangle
open Tsdl
open Tsdl_ttf

let (>>=) = Result.bind

module Text = struct
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

    let render_text_solid (ttf_font : Ttf.font) (text : string) (color : Color.t)
    : (Sdl.surface, string) result =
        let sdl_color = Sdl.Color.create ~r:color.red ~g:color.green ~b:color.blue ~a:color.alpha in
        match Ttf.render_text_solid ttf_font text sdl_color with
        | Error (`Msg err) -> Error ("Ttf.render_text_solid error: " ^ err)
        | Ok sdl_surface -> Ok sdl_surface

    let rec generate_textures (sdl_renderer : Sdl.renderer) (lines : string list) (ttf_font : Ttf.font) (color : Color.t)
    : (Graphics.textures_t, string) result =
        match lines with
        | [] -> Ok []
        | first_line :: rest_lines ->
            render_text_solid ttf_font first_line color >>= fun sdl_surface ->
                Graphics.with_surface sdl_surface (fun sdl_surface ->
                    Graphics.create_texture_from_surface sdl_renderer sdl_surface >>= fun texture ->
                        match generate_textures sdl_renderer rest_lines ttf_font color with
                        | Error err -> Graphics.destroy_texture texture; Error err
                        | Ok textures -> Ok (texture :: textures)
                )

    let get_textures_width (textures : Graphics.textures_t)
    : float =
        match textures with
        | [] -> 0.0
        | first :: rest ->
            let textures_max_width = List.fold_left
                (fun (acc : float) (t : Graphics.texture_t) -> if t.width > acc then t.width else acc)
                first.width
                rest
            in
            textures_max_width

    let get_textures_height (textures : Graphics.textures_t)
    : float =
        match textures with
        | [] -> 0.0
        | first :: _ ->
            let first_with_spacing_height = first.height *. line_with_spacing_ratio in
            let spacing_height = first.height *. line_spacing_ratio in
            (float_of_int (List.length textures)) *. first_with_spacing_height -. spacing_height

    let get_textures_size (textures : Graphics.textures_t)
    : float * float =
        let textures_width = get_textures_width textures in
        let textures_height = get_textures_height textures in
        (textures_width, textures_height)

    let render_texture (sdl_renderer : Sdl.renderer) (texture : Graphics.texture_t) (dst : Rectangle.t)
    : (unit, string) result =
        Graphics.render_copy sdl_renderer texture dst

    let rec render_textures (sdl_renderer : Sdl.renderer) (textures : Graphics.textures_t) (dst : Rectangle.t)
    : (unit, string) result =
        match textures with
        | [] -> Ok ()
        | first_texture :: rest_textures ->
            let first_dst = { dst with
                x = dst.x +. ((dst.width -. first_texture.width) /. 2.0);
                width = first_texture.width;
                height = first_texture.height
            } in
            match render_texture sdl_renderer first_texture first_dst with
            | Error err -> Error err
            | Ok () ->
                let first_texture_with_spacing_height = first_texture.height *. line_with_spacing_ratio in
                let rest_textures_dst = { dst with
                    y = dst.y +. first_texture_with_spacing_height;
                    height = dst.height -. first_texture_with_spacing_height
                } in
                render_textures sdl_renderer rest_textures rest_textures_dst

    let calculate_textures_bounding_box (textures : Graphics.textures_t) (dst : Rectangle.t)
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
        Font.open_font font >>= fun ttf_font ->
            Font.with_font ttf_font (fun ttf_font ->
                let lines = String.split_on_char '\n' text in
                generate_textures sdl_renderer lines ttf_font color >>= fun textures ->
                    Graphics.with_textures textures (fun textures ->
                        calculate_textures_bounding_box textures dst >>= fun bounding_box ->
                            render_textures sdl_renderer textures bounding_box
                    )
            )
end
