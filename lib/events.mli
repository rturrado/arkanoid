module Events : sig
    type event = [
        | `Quit
        | `Key_press of Tsdl.Sdl.keycode
        | `Key_hold of Tsdl.Sdl.keycode
    ] option

    val handle : unit -> event
end
