open Rectangle

module Paddle : sig
    type direction_t =
        | Left
        | Right

    type t = {
        rectangle : Rectangle.t;
        vx : float
    }

    val default : t

    val move : t -> direction_t -> t
    val paint : Tsdl.Sdl.renderer -> t -> (unit, string) result
end
