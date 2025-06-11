open Tsdl
open Tsdl_image

module Image = struct
    type t = {
        path : string;
        width : float;
        height : float
    }

    let init ()
    : (unit, string) result =
        let expected_flags = Image.init Image.Init.(jpg) in
        let initialized_flags = Image.init expected_flags in
        if not (Image.(Init.test initialized_flags expected_flags)) then
            Error "Image.init error"
        else
            Ok ()

    let quit ()
    : unit =
        Image.quit ()

    let load (path : string)
    : (Sdl.surface, string) result =
        match Image.load path with
        | Error (`Msg err) -> Error ("Sdl.load err: " ^ err)
        | Ok surface -> Ok surface
end
