open Rectangle

module Paddle : sig
    type t = {
        rectangle : Rectangle.t;
        speed : int;
    }

    type direction = Left | Right

    val default : t

    val move : t -> direction -> t

    val paint : Tsdl.Sdl.renderer -> t -> (unit, string) result
end
