open Font

module Message_box : sig
    val paint : Tsdl.Sdl.renderer -> string -> Font.t -> (unit, string) result
end
