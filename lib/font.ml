open Tsdl_ttf

module Font = struct
    type t = {
        path : string;
        size : int
    }

    let arcade_r_20 : t = {
        path = Filename.concat "./res" "arcade_r.ttf";
        size = 20
    }

    let open_font (font : t)
    : (Ttf.font, string) result =
        match Ttf.open_font font.path font.size with
        | Error (`Msg err) -> Error ("Ttf.open_font error: " ^ err)
        | Ok sdl_font -> Ok sdl_font

    let close_font (font : Ttf.font)
    : unit =
        Ttf.close_font font

    let with_font (font : Ttf.font) (f : Ttf.font -> ('a, string) result)
    : ('a, string) result =
        let result = f font in
        close_font font;
        result
end
