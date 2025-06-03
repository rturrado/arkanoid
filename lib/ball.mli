open Rectangle

module Ball : sig
    type t = {
        rectangle : Rectangle.t;
        vx : float;
        vy : float;
    }

    val default : t

    val get_center : t -> float * float
    val move : t -> float -> t
    val paint : Tsdl.Sdl.renderer -> t -> (unit, string) result
end
