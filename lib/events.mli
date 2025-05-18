module Events : sig
    type event = [`Quit | `Keydown of Tsdl.Sdl.K.keycode] option

    val current_pressed_keycode : Tsdl.Sdl.K.keycode option ref

    val handle : () -> (event option, string) result
end
