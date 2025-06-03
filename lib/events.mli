module Events : sig
    type event = [
        | `Quit
        | `Keydown of Tsdl.Sdl.keycode
    ] option

    val current_pressed_keycode : Tsdl.Sdl.keycode option ref

    val handle : unit -> (event, string) result
end
