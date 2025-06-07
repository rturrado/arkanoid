open Tsdl

module Events = struct
    type event = [
        | `Quit
        | `Key_press of Sdl.keycode
        | `Key_hold of Sdl.keycode
    ] option

    let current_held_keycode : Sdl.keycode option ref = ref None

    let handle ()
    : (event, string) result =
        let sdl_event = Sdl.Event.create () in
        if Sdl.poll_event (Some sdl_event) then (
            match Sdl.Event.get sdl_event Sdl.Event.typ with
            | t when t = Sdl.Event.quit -> Ok (Some `Quit)
            | t when t = Sdl.Event.key_down ->
                let keycode = Sdl.Event.get sdl_event Sdl.Event.keyboard_keycode in
                let repeat = Sdl.Event.get sdl_event Sdl.Event.keyboard_repeat in
                current_held_keycode := Some keycode;
                if repeat  = 0 then
                    Ok (Some (`Key_press keycode))
                else
                    Ok (Some (`Key_hold keycode))
            | t when t = Sdl.Event.key_up ->
                current_held_keycode := None;
                Ok None
            | _ ->
                match !current_held_keycode with
                | None -> Ok None
                | Some keycode -> Ok (Some (`Key_hold keycode))
        ) else
            match !current_held_keycode with
            | None -> Ok None
            | Some keycode -> Ok (Some (`Key_hold keycode))
end
