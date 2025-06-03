open Tsdl

module Events = struct
    type event = [
        | `Quit
        | `Keydown of Sdl.keycode
    ] option

    let current_pressed_keycode : Sdl.keycode option ref = ref None

    let handle ()
    : (event, string) result =
        let sdl_event = Sdl.Event.create () in
        if Sdl.poll_event (Some sdl_event) then (
            match Sdl.Event.get sdl_event Sdl.Event.typ with
            | t when t = Sdl.Event.quit -> Ok (Some `Quit)
            | t when t = Sdl.Event.key_down ->
                let keycode = Sdl.Event.get sdl_event Sdl.Event.keyboard_keycode in
                current_pressed_keycode := Some keycode;
                Ok (Some (`Keydown keycode))
            | t when t = Sdl.Event.key_up ->
                current_pressed_keycode := None;
                Ok None
            | _ ->
                Ok (Option.map (fun k -> `Keydown k) !current_pressed_keycode)
        ) else (
            Ok (Option.map (fun k -> `Keydown k) !current_pressed_keycode)
        )
end
