module Message_box : sig
    val paint : Tsdl.Sdl.renderer -> string -> (unit, string) result
end
