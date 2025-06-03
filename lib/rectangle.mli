open Color

module Rectangle : sig
    type t = {
        x : float;
        y : float;
        width : float;
        height : float
    }

    val default : t

    val get_center : t -> float * float
    val paint : Tsdl.Sdl.renderer -> t -> Color.t -> (unit, string) result
    val paint_border : Tsdl.Sdl.renderer -> t -> Color.t -> (unit, string) result
end
