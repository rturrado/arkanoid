module Events = struct
    let current_pressed_keycode : Tsdl.Sdl.K.keycode option ref = ref None

    let handle () = (event option, string) result =
        let event = Sdl.Event.create () then (
            match Sdl.Event.get event Sdl.Event.type_enum with
            | `Quit -> Ok (Some `Quit)
            | `Keydown ->
                let keycode = Sdl.Event.get event Sdl.Event.keyboard_keycode in
                current_pressed_keycode := Some keycode;
                Ok (Some (`Keydown keycode))
            | `Keyup ->
                current_pressed_keycode := None;
                Ok None
            | _ ->
                Ok (Option.map (fun k -> `Keydown k) !current_pressed_keycode)
        ) else (
            Ok (Option.map (fun k -> `Keydown k) !current_pressed_keycode)
        )
    end
end
