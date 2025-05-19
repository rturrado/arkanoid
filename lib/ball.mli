open Rectangle

module Ball : sig
    type t = Rectangle.t

    val default : Rectangle.t

    val paint : Tsdl.Sdl.renderer -> t -> (unit, string) result
end
